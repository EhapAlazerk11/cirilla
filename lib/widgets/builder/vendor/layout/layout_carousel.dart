import 'package:flutter/material.dart';

class LayoutCarousel extends StatelessWidget {
  final int? length;
  final double? pad;
  final double? widthItem;
  final EdgeInsetsDirectional? padding;
  final Widget Function(BuildContext context, {int? index, double? widthItem}) buildItem;

  LayoutCarousel({
    Key? key,
    this.length = 5,
    this.pad = 12,
    this.widthItem = 250,
    this.padding = EdgeInsetsDirectional.zero,
    required this.buildItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, int index) => Column(
        children: [
          buildItem(
            context,
            index: index,
            widthItem: widthItem ?? 250,
          ),
        ],
      ),
      separatorBuilder: (_, int index) => SizedBox(width: pad ?? 0),
      itemCount: length!,
    );
  }
}
