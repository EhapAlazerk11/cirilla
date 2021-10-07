import 'package:flutter/material.dart';

class ViewList extends StatelessWidget {
  final int length;
  final double pad;
  final EdgeInsetsGeometry? padding;
  final Widget Function({required int index, double? widthItem}) buildItem;

  ViewList({
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
          return ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, int index) {
              return buildItem(index: index, widthItem: width);
            },
            separatorBuilder: (_, int index) {
              return SizedBox(height: pad);
            },
            itemCount: length,
          );
        },
      ),
    );
  }
}
