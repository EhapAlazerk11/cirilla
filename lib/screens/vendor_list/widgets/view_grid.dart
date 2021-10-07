import 'package:flutter/material.dart';

class ViewGrid extends StatelessWidget {
  final int length;
  final double pad;
  final EdgeInsetsGeometry? padding;
  final Widget Function({required int index, double? widthItem}) buildItem;

  ViewGrid({
    Key? key,
    this.length = 5,
    this.pad = 16,
    this.padding,
    required this.buildItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          double widthItem = (width - pad) / 2;
          return Wrap(
            spacing: pad,
            runSpacing: pad,
            children: List.generate(length, (index) {
              return SizedBox(
                width: widthItem,
                child: buildItem(index: index, widthItem: widthItem),
              );
            }),
          );
        },
      ),
    );
  }
}
