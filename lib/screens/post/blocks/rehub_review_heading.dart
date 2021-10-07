import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:flutter/material.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';
import 'package:url_launcher/url_launcher.dart';

class RehubReviewHeading extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const RehubReviewHeading({Key? key, this.block}) : super(key: key);

  void openUrl(String? url) {
    if (url != null && url.isNotEmpty) {
      launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    bool enablePosition = get(attrs, ['includePosition'], true);
    bool enableImage = get(attrs, ['includeImage'], true);
    String? titlePosition = get(attrs, ['position'], '1');
    String title = get(attrs, ['title'], '');
    String subtitle = get(attrs, ['subtitle'], '');
    String? image = get(attrs, ['image', 'url'], Assets.noImageUrl);
    String? link = get(attrs, ['link'], '');

    Widget? imageWidget = enableImage && image!.isNotEmpty
        ? GestureDetector(
            onTap: () => openUrl(link),
            child: CirillaCacheImage(
              image,
              width: 72,
              height: 72,
            ),
          )
        : null;
    return ReviewHeading(
      positionNumber: enablePosition && titlePosition!.isNotEmpty
          ? Text(
              titlePosition,
              style: theme.textTheme.headline3!.copyWith(color: theme.dividerColor),
            )
          : null,
      title: title.isNotEmpty
          ? Text(
              title,
              style: theme.textTheme.headline6,
            )
          : null,
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: theme.textTheme.bodyText2,
            )
          : null,
      image: imageWidget,
    );
  }
}
