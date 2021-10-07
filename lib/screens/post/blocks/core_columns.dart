import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';

import 'blocks.dart';

class Columns extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const Columns({Key? key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double pad = 16;
    // ThemeData theme = Theme.of(context);
    dynamic attrs = get(block, ['attrs'], []);
    String strBackground = attrs is Map ? get(attrs, ['style', 'color', 'background'], '') : '';
    // String strText = attrs is Map ? get(attrs, ['style', 'color', 'text'], '') : 'null';
    Color? background = strBackground.isNotEmpty ? ConvertData.fromHex(strBackground, Colors.transparent) : null;
    // Color textColor = strText.isNotEmpty ? ConvertData.fromHex(strText, Colors.transparent) : null;

    List? innerBlocks = get(block, ['innerBlocks'], []);

    return Container(
      color: background,
      padding: background != null ? EdgeInsets.all(16) : null,
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          double widthView = width - (innerBlocks!.length - 1) * pad;
          List<Widget> widgetBlocks = [];

          for (int i = 0; i < innerBlocks.length; i++) {
            widgetBlocks.add(buildItem(context, item: innerBlocks.elementAt(i), widthView: widthView));
            if (i < innerBlocks.length - 1) {
              widgetBlocks.add(SizedBox(width: pad));
            }
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgetBlocks,
          );
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, {dynamic item, double? widthView}) {
    List blockItems = get(item, ['innerBlocks'], []);
    dynamic attrs = get(item, ['attrs'], []);
    dynamic percentWidth = attrs is Map ? get(attrs, ['width'], null) : null;
    double? percent = percentWidth != null &&
            percentWidth is String &&
            ConvertData.stringToDouble(percentWidth.substring(0, percentWidth.length - 1)) is double
        ? ConvertData.stringToDouble(percentWidth.substring(0, percentWidth.length - 1))
        : null;

    Widget? child = blockItems.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(blockItems.length, (index) {
              dynamic itemChild = blockItems.elementAt(index);
              if (itemChild is Map<String, dynamic>) {
                return PostBlock(
                  block: itemChild,
                );
              }
              return Container();
            }),
          )
        : null;
    if (percent != null) {
      double widthItem = (widthView! * percent) / 100;
      return SizedBox(
        width: widthItem,
        child: child,
      );
    }
    return Expanded(child: child ?? Container());
  }
}
