import 'package:cirilla/mixins/loading_mixin.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_divider.dart';
import 'package:flutter/material.dart';

class LayoutMasonry extends StatelessWidget with LoadingMixin {
  final List<Post>? posts;
  final Widget Function(BuildContext context,
      {Post? post, int? index, double? widthView, double? width, double? height})? buildItem;
  final double? pad;
  final Color? dividerColor;
  final double? dividerHeight;
  final EdgeInsetsDirectional? padding;

  final double? width;
  final double? height;

  final bool loading;
  final bool canLoadMore;
  final bool? enableLoadMore;
  final Function? onLoadMore;

  LayoutMasonry({
    Key? key,
    this.posts,
    this.buildItem,
    this.pad,
    this.dividerColor,
    this.dividerHeight,
    this.padding,
    this.width,
    this.height,
    this.loading = false,
    this.canLoadMore = false,
    this.enableLoadMore = false,
    this.onLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    List<int> listLeft = [];
    List<int> listRight = [];

    for (int i = 0; i < posts!.length; i++) {
      if (i % 2 == 0) {
        listLeft.add(i);
      } else {
        listRight.add(i);
      }
    }
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          double maxWidth = constraints.maxWidth;
          double widthItem = (maxWidth - pad!) / 2;
          double heightRatio = (widthItem * height!) / width!;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildList(context, items: listLeft, mod: 0, width: widthItem, height: heightRatio)),
                  SizedBox(width: pad),
                  Expanded(child: _buildList(context, items: listRight, width: widthItem, height: heightRatio)),
                ],
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
                ),
              ]
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(context, {required List<int> items, int mod = 1, double? width, double? height}) {
    return Column(
      children: List.generate(
        items.length,
        (int index) {
          double? newHeight = height;
          if (index % 2 == mod) {
            newHeight = height! * 0.8;
          }
          return Column(
            children: [
              buildItem!(
                context,
                post: posts![items[index]],
                index: index,
                widthView: width,
                height: newHeight,
                width: width,
              ),
              if (index < items.length - 1)
                CirillaDivider(
                  color: dividerColor,
                  height: pad! / 2,
                  thickness: dividerHeight,
                )
              else ...[
                SizedBox(height: pad),
                CirillaDivider(
                  color: dividerColor,
                  height: 0,
                  thickness: dividerHeight,
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}
