import 'package:flutter/material.dart';

class CarouselLayout extends StatelessWidget {
  final int itemCount;
  final double? axisSpacing;
  final Widget Function(BuildContext context, int index) renderItem;
  final EdgeInsetsGeometry padding;

  CarouselLayout({
    Key? key,
    this.itemCount = 2,
    required this.renderItem,
    this.axisSpacing = 0,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => Column(
        children: [renderItem(context, index)],
      ),
      separatorBuilder: (context, index) => SizedBox(width: axisSpacing),
      itemCount: itemCount,
    );
  }
}
