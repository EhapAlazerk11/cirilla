import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/post/post.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:flutter/material.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';

class PostOfferListing extends StatelessWidget with Utility, BlockMixin {
  final Map<String, dynamic>? block;

  const PostOfferListing({Key? key, this.block}) : super(key: key);

  void goDetail(BuildContext context, dynamic id) {
    if (id != null) {
      Navigator.of(context).pushNamed(PostScreen.routeName, arguments: {
        'id': ConvertData.stringToInt(id),
      });
    }
  }

  Widget buildImage({String? url, double? score, ThemeData? theme}) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        double widthImage = maxWidth;
        double heightImage = 180;
        return Stack(
          children: [
            CirillaCacheImage(
              url,
              width: widthImage,
              height: heightImage,
            ),
            PositionedDirectional(
              top: 8,
              end: 8,
              child: score! > 0
                  ? buildCircleNumber(
                      number: score,
                      theme: theme!,
                    )
                  : Container(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    List selectPosts = get(attrs, ['selectedPosts'], []);
    List? offers = get(attrs, ['offers'], []);

    if (selectPosts.isEmpty || selectPosts.length != offers!.length) {
      return Container();
    }
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, int index) {
        dynamic idPost = selectPosts[index];
        dynamic item = offers[index];
        String name = get(item, ['title'], '');
        String copy = get(item, ['copy'], '');
        String? image = get(item, ['thumbnail', 'url'], '');
        double? score = ConvertData.stringToDouble(get(item, ['score'], '0'));
        return GestureDetector(
          onTap: () => goDetail(context, idPost),
          child: PostOfferListingItem(
            image: buildImage(url: image, score: score, theme: theme),
            name: Text(
              name,
              style: theme.textTheme.headline6,
            ),
            description: copy.isNotEmpty
                ? Text(
                    copy,
                    style: theme.textTheme.bodyText2,
                  )
                : null,
            color: theme.cardColor,
          ),
        );
      },
      separatorBuilder: (_, int index) {
        return SizedBox(height: 24);
      },
      itemCount: offers.length,
    );
  }
}
