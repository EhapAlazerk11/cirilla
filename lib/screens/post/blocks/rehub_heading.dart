import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';

import 'html_text.dart';

class RehubDoubleHeading extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const RehubDoubleHeading({Key? key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    String? content = get(attrs, ['content'], 'Heading');
    String backgroundText = get(attrs, ['backgroundText'], '01.');
    int level = ConvertData.stringToInt(get(attrs, ['level'], 2), 2);
    TextAlign textAlign = ConvertData.toTextAlign(get(attrs, ['textAlign'], 'left'));

    String nameTag = 'h$level';

    return DoubleHeading(
      backgroundText: backgroundText.isNotEmpty
          ? Text(
              backgroundText,
              style: theme.textTheme.headline2!.copyWith(fontWeight: FontWeight.w900, color: theme.colorScheme.surface),
              textAlign: textAlign,
            )
          : null,
      // title: Text(content, style: theme.textTheme.headline6.copyWith(fontWeight: FontWeight.bold)),
      title: HtmlText(
        text: '<$nameTag>$content<$nameTag/>',
        fontColor: theme.textTheme.headline6!.color,
        fontWeight: FontWeight.w900,
        textAlign: textAlign,
      ),
      minHeight: 84,
    );
  }
}
