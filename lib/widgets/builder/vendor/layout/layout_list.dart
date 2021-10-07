import 'package:flutter/material.dart';

class LayoutList extends StatelessWidget {
  final int? length;
  final double? pad;
  final EdgeInsetsDirectional? padding;
  final Widget Function(BuildContext context, {int? index, double? widthItem}) buildItem;

  LayoutList({
    Key? key,
    this.length = 5,
    this.pad = 12,
    this.padding = EdgeInsetsDirectional.zero,
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
            itemBuilder: (_, int index) => buildItem(
              context,
              index: index,
              widthItem: width,
            ),
            separatorBuilder: (_, int index) => SizedBox(height: pad ?? 0),
            itemCount: length!,
          );
        },
      ),
    );
  }
}
