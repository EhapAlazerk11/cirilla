import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/widgets/cirilla_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LayoutCarousel extends StatelessWidget {
  final List<Brand> brands;
  final BuildItemBrandType buildItem;
  final double pad;
  final EdgeInsetsDirectional padding;
  final double height;
  final double width;
  final double dividerWidth;
  final Color dividerColor;

  const LayoutCarousel({
    Key? key,
    required this.brands,
    required this.buildItem,
    this.pad = 0,
    this.padding = EdgeInsetsDirectional.zero,
    this.height = 200,
    this.width = 300,
    this.dividerWidth = 1,
    this.dividerColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => Column(
        children: [buildItem(context, brand: brands[index], width: width, height: height)],
      ),
      separatorBuilder: (context, index) {
        if (dividerWidth > 0) {
          return CirillaDivider(
            color: dividerColor,
            thickness: dividerWidth,
            height: pad,
            axis: Axis.vertical,
          );
        }
        return SizedBox(width: pad);
      },
      itemCount: brands.length,
    );
  }
}
