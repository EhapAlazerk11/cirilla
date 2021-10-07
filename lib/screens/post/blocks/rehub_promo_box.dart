import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';
import 'package:url_launcher/url_launcher.dart';

class RehubPromoBox extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const RehubPromoBox({Key? key, this.block}) : super(key: key);

  void openUrl(String? url) {
    if (url != null && url.isNotEmpty) {
      launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    String title = get(attrs, ['title'], translate('post_detail_sample_title'));
    String content = get(attrs, ['content'], translate('post_detail_sample_content'));
    String? buttonText = get(attrs, ['buttonText'], translate('post_detail_purchase_now'));
    String? buttonLink = get(attrs, ['buttonLink'], '');

    Color? backgroundColor = ConvertData.fromHex(get(attrs, ['backgroundColor'], '#f8f8f8'));
    Color? textColor = ConvertData.fromHex(get(attrs, ['textColor'], '#333333'));
    bool showBorder = get(attrs, ['showBorder'], false);
    bool showHighlightBorder = get(attrs, ['showHighlightBorder'], false);
    bool showButton = get(attrs, ['showButton'], false);
    Color? borderColor = ConvertData.fromHex(get(attrs, ['borderColor'], '#dddddd'));
    Color? highlightColor = ConvertData.fromHex(get(attrs, ['highlightColor'], '#fb7203'));
    String? highlightPosition = get(attrs, ['highlightPosition'], 'Left');
    double borderSize = ConvertData.stringToDouble(get(attrs, ['borderSize'], 1));

    HighlightPosition position = highlightPosition == 'Right'
        ? HighlightPosition.end
        : highlightPosition == 'Top'
            ? HighlightPosition.top
            : highlightPosition == 'Bottom'
                ? HighlightPosition.bottom
                : HighlightPosition.start;

    return PromoBox(
      title: title.isNotEmpty ? Text(title, style: theme.textTheme.headline6!.copyWith(color: textColor)) : null,
      subtitle: content.isNotEmpty ? Text(content, style: theme.textTheme.bodyText2!.copyWith(color: textColor)) : null,
      button: showButton
          ? SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () => openUrl(buttonLink),
                child: Text(buttonText!.isNotEmpty ? buttonText : translate('post_detail_buy_item')!),
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 24)),
              ),
            )
          : null,
      background: backgroundColor,
      enableBorder: showBorder,
      enableHighlightBorder: showHighlightBorder,
      borderColor: borderColor,
      borderSize: borderSize,
      highlightPosition: position,
      highlightBorderColor: highlightColor,
    );
  }
}
