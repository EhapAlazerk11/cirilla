import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_divider.dart';
import 'package:flutter/material.dart';

class LayoutMasonry extends StatelessWidget with LoadingMixin {
  final List<Product>? products;
  final BuildItemProductType? buildItem;
  final double? pad;
  final Color? dividerColor;
  final double? dividerHeight;
  final EdgeInsetsDirectional? padding;

  final double? width;
  final double? height;
  final double widthView;

  final bool loading;
  final bool canLoadMore;
  final bool? enableLoadMore;
  final Function? onLoadMore;

  LayoutMasonry({
    Key? key,
    this.products,
    this.buildItem,
    this.pad,
    this.dividerColor,
    this.dividerHeight,
    this.padding,
    this.width,
    this.height,
    this.widthView = 300,
    this.loading = false,
    this.canLoadMore = false,
    this.enableLoadMore = false,
    this.onLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    List<int> listLeft = [];
    List<int> listRight = [];

    for (int i = 0; i < products!.length; i++) {
      if (i % 2 == 0) {
        listLeft.add(i);
      } else {
        listRight.add(i);
      }
    }

    return Padding(
      padding: padding!,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildList(context, items: listLeft, mod: 0)),
              SizedBox(width: pad),
              Expanded(child: _buildList(context, items: listRight)),
            ],
          ),
          if (enableLoadMore! && canLoadMore)
            SizedBox(
              height: 34,
              child: ElevatedButton(
                onPressed: onLoadMore as void Function()?,
                child: loading ? entryLoading(context, size: 14, color: Colors.white) : Text(translate('load_more')!),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildList(context, {required List<int> items, int mod = 1}) {
    double widthWidget = widthView - padding!.end - padding!.start;
    double widthItem = (widthWidget - pad!) / 2;
    double heightItem = (widthItem * height!) / width!;

    return Column(
      children: List.generate(
        items.length,
        (int index) {
          double newHeight = heightItem;

          if (index % 2 == mod) {
            newHeight = height! * 0.8;
          }

          return Column(
            children: [
              buildItem!(
                context,
                product: products![items[index]],
                height: newHeight,
                width: widthItem,
              ),
              CirillaDivider(color: dividerColor, height: pad, thickness: dividerHeight)
            ],
          );
        },
      ),
    );
  }
}
