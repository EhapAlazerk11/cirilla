import 'package:flutter/material.dart';

class LayoutGrid extends StatelessWidget {
  final int? length;
  final double? pad;
  final EdgeInsetsDirectional? padding;
  final int col;
  final double? ratio;
  final Widget Function(BuildContext context, {int? index, double? widthItem}) buildItem;

  LayoutGrid({
    Key? key,
    this.length = 5,
    this.pad = 12,
    this.padding = EdgeInsetsDirectional.zero,
    this.col = 2,
    this.ratio = 1,
    required this.buildItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          double widthItem = (width - (col - 1) * pad!) / col;
          double heightItem = widthItem / ratio!;
          return Wrap(
            spacing: pad!,
            runSpacing: pad!,
            children: List.generate(
              length!,
              (index) {
                return Container(
                  width: widthItem,
                  height: heightItem,
                  decoration: BoxDecoration(),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [buildItem(context, index: index, widthItem: widthItem)],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
