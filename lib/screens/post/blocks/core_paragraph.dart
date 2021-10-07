import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

Map<String, Style> styleBlog({String align = 'left', bool pad = true, double fontSize = 15}) {
  return {
    'html': Style(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
    ),
    'body': Style(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
    ),
    'p': Style(
      lineHeight: LineHeight(1.8),
      fontSize: FontSize(fontSize),
      padding: EdgeInsets.zero,
      textAlign: ConvertData.toTextAlign(align),
    ),
    'div': Style(
      lineHeight: LineHeight(1.8),
      fontSize: FontSize(fontSize),
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
    ),
    'img': Style(
      padding: EdgeInsets.symmetric(vertical: 8),
    )
  };
}

class Paragraph extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  final String? alignCover;

  final bool padCover;

  const Paragraph({Key? key, this.block, this.alignCover, this.padCover = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};

    String alignCover = attrs['align'] ?? '';

    Map? style = get(attrs, ['style'], {}) is Map ? get(attrs, ['style'], {}) : {};

    int fontSize = get(style, ['typography', 'fontSize'], 15);

    return Html(
        data: "<div>${block!['innerHTML']}</div>",
        style: styleBlog(align: alignCover, pad: padCover, fontSize: fontSize.toDouble()));
  }
}
