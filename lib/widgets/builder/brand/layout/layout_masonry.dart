import 'package:cirilla/types/types.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/widgets/cirilla_divider.dart';
import 'package:flutter/material.dart';

class LayoutMasonry extends StatelessWidget {
  final List<Brand> brands;
  final BuildItemBrandType buildItem;
  final double pad;
  final EdgeInsetsDirectional padding;
  final double widthView;
  final double dividerWidth;
  final Color dividerColor;

  LayoutMasonry({
    Key? key,
    required this.brands,
    required this.buildItem,
    this.pad = 0,
    this.padding = EdgeInsetsDirectional.zero,
    this.widthView = 300,
    this.dividerWidth = 1,
    this.dividerColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> listLeft = [];
    List<int> listRight = [];

    for (int i = 0; i < brands.length; i++) {
      if (i % 2 == 0) {
        listLeft.add(i);
      } else {
        listRight.add(i);
      }
    }
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildList(context, items: listLeft, mod: 0)),
          SizedBox(width: pad),
          Expanded(child: _buildList(context, items: listRight)),
        ],
      ),
    );
  }

  Widget _buildList(context, {required List<int> items, int mod = 1}) {
    double widthWidget = widthView - padding.end - padding.start;
    double width = (widthWidget - pad) / 2;
    double height = width;
    return Column(
      children: List.generate(
        items.length,
        (int index) {
          double newHeight = height;

          if (index % 2 == mod) {
            newHeight = height * 0.8;
          }

          return Column(
            children: [
              buildItem(
                context,
                brand: brands[items[index]],
                height: newHeight,
                width: width,
              ),
              if (index < items.length - 1) ...[
                if (dividerWidth is double && dividerWidth > 0)
                  CirillaDivider(color: dividerColor, thickness: dividerWidth, height: pad)
                else
                  SizedBox(height: pad),
              ]
            ],
          );
        },
      ),
    );
  }
}
