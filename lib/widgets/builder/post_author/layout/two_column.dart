import 'package:flutter/material.dart';

class TwoColumnLayout extends StatelessWidget {
  final int? itemCount;
  final double? axisSpacing;
  final Widget Function(BuildContext context, int index, double width) buildItem;
  final EdgeInsetsGeometry padding;

  TwoColumnLayout({
    Key? key,
    this.itemCount,
    this.axisSpacing,
    required this.buildItem,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          double col = 2;

          double widthView = constraints.maxWidth;

          double widthItem = (widthView - (col - 1) * axisSpacing!) / col;

          return Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: axisSpacing!,
            runSpacing: axisSpacing!,
            children: List.generate(itemCount!, (index) {
              return SizedBox(
                width: widthItem,
                child: buildItem(
                  context,
                  index,
                  widthItem,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
