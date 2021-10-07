import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/widgets/cirilla_divider.dart';
import 'package:flutter/material.dart';

class LayoutList extends StatelessWidget {
  final List<Brand> brands;
  final BuildItemBrandType buildItem;
  final double pad;
  final EdgeInsetsDirectional padding;
  final double widthView;
  final double dividerWidth;
  final Color dividerColor;

  const LayoutList({
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
    double widthWidget = widthView - padding.end - padding.start;
    return Padding(
      padding: padding,
      child: Column(
        children: List.generate(
          brands.length,
          (int index) {
            return Column(
              children: [
                buildItem(context, brand: brands[index], width: widthWidget, height: null),
                if (index < brands.length - 1) ...[
                  if (dividerWidth is double && dividerWidth > 0)
                    CirillaDivider(
                      color: dividerColor,
                      thickness: dividerWidth,
                      height: pad,
                    )
                  else
                    SizedBox(height: pad),
                ]
              ],
            );
          },
        ),
      ),
    );
  }
}
