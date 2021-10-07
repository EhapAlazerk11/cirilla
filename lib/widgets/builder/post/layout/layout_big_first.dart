import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/loading_mixin.dart';
import 'package:cirilla/mixins/post_mixin.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/models/post/post.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_divider.dart';
import 'package:flutter/material.dart';

class LayoutBigFirst extends StatelessWidget with PostMixin, LoadingMixin {
  final List<Post>? posts;
  final String? template;
  final Function(
    BuildContext context, {
    Post? post,
    int? index,
    double? widthView,
    String? template,
    double? width,
    double? height,
    BorderRadius? radius,
    double? radiusImage,
    EdgeInsetsGeometry? paddingContent,
  })? buildItem;
  final double? pad;
  final Color? dividerColor;
  final double? dividerHeight;
  final EdgeInsetsDirectional padding;
  final double? width;
  final double? height;
  final BorderRadius? radius;
  final double? radiusImage;
  final EdgeInsetsGeometry? paddingContent;
  final bool loading;
  final bool canLoadMore;
  final bool? enableLoadMore;
  final Function? onLoadMore;

  const LayoutBigFirst({
    Key? key,
    this.posts,
    this.buildItem,
    this.pad = 0,
    this.dividerColor,
    this.dividerHeight = 1,
    this.padding = EdgeInsetsDirectional.zero,
    this.template,
    this.width,
    this.height,
    this.radius,
    this.radiusImage,
    this.paddingContent,
    this.loading = false,
    this.canLoadMore = false,
    this.enableLoadMore = false,
    this.onLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (posts!.length <= 0) return Container();
    TranslateType translate = AppLocalizations.of(context)!.translate;
    List<Post> _posts = List<Post>.of(posts!);
    Post firstPost = _posts.removeAt(0);

    double? width = ConvertData.stringToDouble(get(template, ['data', 'size', 'width'], 100));
    double? height = ConvertData.stringToDouble(get(template, ['data', 'size', 'height'], 100));

    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          double widthView = constraints.maxWidth;

          return Column(
            children: [
              Column(
                children: [
                  buildItem!(
                    context,
                    post: firstPost,
                    index: 0,
                    template: Strings.postItemDefault,
                    widthView: widthView,
                    width: 335,
                    height: 260,
                  ),
                  if (_posts.length > 0)
                    CirillaDivider(color: dividerColor, height: pad, thickness: dividerHeight)
                  else ...[
                    SizedBox(height: pad),
                    CirillaDivider(color: dividerColor, height: dividerHeight, thickness: dividerHeight)
                  ]
                ],
              ),
              ...List.generate(
                _posts.length,
                (int index) {
                  return Column(
                    children: [
                      buildItem!(
                        context,
                        post: _posts[index],
                        index: index,
                        template: template,
                        widthView: widthView,
                        width: width,
                        height: height,
                        radius: radius,
                        radiusImage: radiusImage,
                        paddingContent: paddingContent,
                      ),
                      if (index < _posts.length - 1)
                        CirillaDivider(color: dividerColor, height: pad, thickness: dividerHeight)
                      else ...[
                        SizedBox(height: pad),
                        CirillaDivider(color: dividerColor, height: dividerHeight, thickness: dividerHeight)
                      ],
                    ],
                  );
                },
              ),
              if (enableLoadMore! && canLoadMore) ...[
                SizedBox(height: pad),
                SizedBox(
                  height: 34,
                  child: ElevatedButton(
                    onPressed: onLoadMore as void Function()?,
                    child:
                        loading ? entryLoading(context, size: 14, color: Colors.white) : Text(translate('load_more')!),
                  ),
                )
              ],
            ],
          );
        },
      ),
    );
  }
}
