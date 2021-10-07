import 'package:flutter/material.dart';

class ViewCarousel extends StatelessWidget {
  final int length;
  final double pad;
  final EdgeInsetsGeometry? padding;
  final Widget Function({required int index, double? widthItem}) buildItem;

  ViewCarousel({
    Key? key,
    this.length = 5,
    this.pad = 16,
    this.padding,
    required this.buildItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: List.generate(
          length,
          (index) {
            return Padding(
              padding: EdgeInsetsDirectional.only(end: index < length - 1 ? pad : 0),
              child: buildItem(index: index, widthItem: null),
            );
          },
        ),
      ),
    );
  }
}
