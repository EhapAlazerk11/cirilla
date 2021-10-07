import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/post/post.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';
import 'package:cirilla/extension/strings.dart';

class RehubPostOfferbox extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const RehubPostOfferbox({Key? key, this.block}) : super(key: key);

  void goDetail(BuildContext context, dynamic postId) {
    Navigator.of(context).pushNamed(PostScreen.routeName, arguments: {
      'id': ConvertData.stringToInt(postId),
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    dynamic postId = get(attrs, ['selectedPost'], null);
    String? name = get(attrs, ['name'], '');
    String? image = get(attrs, ['thumbnail', 'url'], '');
    String? buttonText = get(attrs, ['button', 'text'], translate('post_detail_offerbox_button'));
    double? rating = ConvertData.stringToDouble(get(attrs, ['rating'], 0));
    if (postId == null) {
      return Container();
    }
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        double screenWidth = MediaQuery.of(context).size.width;
        double width = maxWidth is double && maxWidth != double.infinity ? maxWidth : screenWidth;
        double widthImage = width;
        double heightImage = (widthImage * 200) / 335;
        return SizedBox(
          width: width,
          child: PostOfferBox(
            image: CirillaCacheImage(image, width: widthImage, height: heightImage),
            title: Text(
              name!,
              style: theme.textTheme.subtitle1,
            ),
            rating: rating > 0 ? CirillaRating(initialValue: rating) : null,
            button: SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                child: Text(buttonText!.capitalizeFirstofEach),
                onPressed: () => goDetail(context, postId),
              ),
            ),
          ),
        );
      },
    );
  }
}
