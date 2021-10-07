import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as dom;

import 'html_text.dart';

Map<String, double> size = {'small': 14.0, 'normal': 16.0, 'medium': 23.0, 'large': 26.0, 'Huge': 37.0};

class Heading extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;
  const Heading({Key? key, required this.block});
  @override
  Widget build(BuildContext context) {
    dom.Document document = htmlParser.parse(block!['innerHTML']);

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};

    Map? style = get(attrs, ['style'], {}) is Map ? get(attrs, ['style'], {}) : {};

    TextAlign textAlign = ConvertData.toTextAlign(get(attrs, ['textAlign'], ''));

    int level = ConvertData.stringToInt(get(attrs, ['level'], 2), 2);

    double? fontCustom = ConvertData.stringToDoubleCanBeNull(get(style, ['typography', 'fontSize']), null);

    // String? fontDefault = get(attrs, ['fontSize']);

    bool? bold = document.getElementsByTagName('strong').isNotEmpty;

    bool? italic = document.getElementsByTagName('em').isNotEmpty;

    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    String nameTag = 'h$level';
    return HtmlText(
      text: '<$nameTag>${document.body?.text}<$nameTag/>',
      fontColor: textTheme.headline6!.color,
      fontWeight: bold == true ? FontWeight.bold : null,
      fontSize: fontCustom,
      fontStyle: italic == true ? FontStyle.italic : null,
      textAlign: textAlign,
    );
  }
}
