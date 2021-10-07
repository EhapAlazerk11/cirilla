import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_divider.dart';
import 'package:flutter/material.dart';

class LayoutList extends StatelessWidget with LoadingMixin {
  final List<Product>? products;
  final BuildItemProductType? buildItem;
  final double? pad;
  final Color? dividerColor;
  final double? dividerHeight;
  final EdgeInsetsDirectional padding;

  final double? width;
  final double? height;
  final double widthView;
  final bool loading;
  final bool canLoadMore;
  final bool? enableLoadMore;
  final Function? onLoadMore;

  const LayoutList({
    Key? key,
    this.products,
    this.buildItem,
    this.pad = 0,
    this.dividerColor,
    this.dividerHeight = 1,
    this.padding = EdgeInsetsDirectional.zero,
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
    double widthWidget = widthView - padding.end - padding.start;

    double newWidth = widthWidget;
    double newHeight = (newWidth * height!) / width!;
    int count = enableLoadMore! && canLoadMore ? products!.length + 1 : products!.length;

    return Padding(
      padding: padding,
      child: Column(
        children: List.generate(
          count,
          (int index) {
            if (index == products!.length) {
              return SizedBox(
                height: 34,
                child: ElevatedButton(
                  onPressed: onLoadMore as void Function()?,
                  child: loading ? entryLoading(context, size: 14, color: Colors.white) : Text(translate('load_more')!),
                ),
              );
            }
            return Column(
              children: [
                buildItem!(
                  context,
                  product: products![index],
                  width: newWidth,
                  height: newHeight,
                ),
                if (index < count - 1) CirillaDivider(color: dividerColor, height: pad, thickness: dividerHeight),
              ],
            );
          },
        ),
      ),
    );
  }
}
