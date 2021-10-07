import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/widgets/cirilla_divider.dart';
import 'package:flutter/material.dart';

class LayoutGrid extends StatelessWidget {
  final List<Brand> brands;
  final BuildItemBrandType buildItem;
  final int column;
  final double ratio;
  final double pad;
  final EdgeInsetsDirectional padding;
  final double widthView;
  final double dividerWidth;
  final Color dividerColor;

  const LayoutGrid({
    Key? key,
    required this.brands,
    required this.buildItem,
    this.column = 2,
    this.ratio = 1,
    this.pad = 0,
    this.padding = EdgeInsetsDirectional.zero,
    this.widthView = 300,
    this.dividerWidth = 1,
    this.dividerColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int col = column is int && column > 1 ? column : 2;
    double widthWidget = widthView - padding.end - padding.start;
    double widthItem = (widthWidget - (col - 1) * pad) / col;
    double heightItem = widthItem / ratio;

    return Padding(
      padding: padding,
      child: Wrap(
        spacing: pad,
        runSpacing: pad,
        children: List.generate(
          brands.length,
          (index) {
            return SizedBox(
              width: widthItem,
              child: Column(
                children: [
                  buildItem(context, brand: brands[index], width: widthItem, height: heightItem),
                  if (dividerWidth is double && dividerWidth > 0) ...[
                    SizedBox(height: pad),
                    CirillaDivider(color: dividerColor, height: 0, thickness: dividerWidth),
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
