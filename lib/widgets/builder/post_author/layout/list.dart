import 'package:flutter/material.dart';

class ListLayout extends StatelessWidget {
  final int? itemCount;
  final double? axisSpacing;
  final Widget Function(BuildContext context, int index, double width) buildItem;
  final EdgeInsetsGeometry padding;

  ListLayout({
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
          double widthItem = constraints.maxWidth;
          return ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (_, int index) => buildItem(context, index, widthItem),
            separatorBuilder: (_, int index) => SizedBox(height: axisSpacing),
            itemCount: itemCount!,
            physics: NeverScrollableScrollPhysics(),
          );
        },
      ),
    );
  }
}
