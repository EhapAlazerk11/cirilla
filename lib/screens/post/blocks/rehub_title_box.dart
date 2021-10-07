import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:flutter/material.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';

import 'html_text.dart';

class RehubTitleBox extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const RehubTitleBox({Key? key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    String? title = get(attrs, ['title'], '');
    String? text = get(attrs, ['text'], '');
    String? style = get(attrs, ['style'], '1');

    Color borderColor = theme.dividerColor;
    Color? titleColor = theme.textTheme.subtitle1!.color;

    switch (style) {
      case '2':
        borderColor = Colors.black;
        titleColor = Colors.black;
        break;
      case '3':
        borderColor = ColorBlock.orange;
        titleColor = ColorBlock.orange;
        break;
      case 'main':
        borderColor = theme.primaryColor;
        titleColor = theme.primaryColor;
        break;
      case 'secondary':
        borderColor = theme.colorScheme.secondary;
        break;
      case '6':
        borderColor = theme.dividerColor;
        break;
    }

    return TitleBox(
      heading: title!.isNotEmpty
          ? Text(
              title.toUpperCase(),
              style: theme.textTheme.headline6!.copyWith(color: titleColor),
              maxLines: 1,
            )
          : null,
      // title: Text(text, style: theme.textTheme.bodyText2),
      title: HtmlText(
        text: text,
        fontColor: theme.textTheme.bodyText2!.color,
        fontSize: theme.textTheme.bodyText2!.fontSize,
      ),
      borderColor: borderColor,
      doubleBorder: style == '6',
    );
  }
}
