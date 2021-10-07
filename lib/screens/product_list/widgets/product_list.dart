import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/widgets/cirilla_product_item.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';

class ProductListLayout extends StatelessWidget with Utility, NavigationMixin {
  // List product
  final List<Product>? products;

  final int typeView;

  // config styles
  final Map<String, dynamic>? styles;

  const ProductListLayout({
    Key? key,
    required this.products,
    this.typeView = 0,
    this.styles,
  }) : super(key: key);

  // Build Item product
  Widget buildItem(
    BuildContext context, {
    Product? product,
    String? templateItem,
    required Size size,
    Map<String, dynamic>? styles,
  }) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    Color textColor =
        ConvertData.fromRGBA(get(styles, ['textColor', themeModeKey], {}), theme.textTheme.subtitle1!.color);
    Color subTextColor =
        ConvertData.fromRGBA(get(styles, ['subTextColor', themeModeKey], {}), theme.textTheme.caption!.color);
    Color priceColor =
        ConvertData.fromRGBA(get(styles, ['priceColor', themeModeKey], {}), theme.textTheme.subtitle1!.color);
    Color salePriceColor = ConvertData.fromRGBA(get(styles, ['salePriceColor', themeModeKey], {}), Color(0xFFF01F0E));
    Color regularPriceColor =
        ConvertData.fromRGBA(get(styles, ['regularPriceColor', themeModeKey], {}), theme.textTheme.caption!.color);
    Map wishlist = get(styles, ['wishlistColor', themeModeKey], {});
    Color? wishlistColor = wishlist.isNotEmpty ? ConvertData.fromRGBA(wishlist, Colors.black) : null;

    Color labelNewColor = ConvertData.fromRGBA(get(styles, ['labelNewColor', themeModeKey], {}), Color(0xFF21BA45));
    Color labelNewTextColor = ConvertData.fromRGBA(get(styles, ['labelNewTextColor', themeModeKey], {}), Colors.white);
    double? radiusLabelNew = ConvertData.stringToDouble(get(styles, ['radiusLabelNew'], 10));
    Color labelSaleColor = ConvertData.fromRGBA(get(styles, ['labelSaleColor', themeModeKey], {}), Color(0xFFF01F0E));
    Color labelSaleTextColor =
        ConvertData.fromRGBA(get(styles, ['labelSaleTextColor', themeModeKey], {}), Colors.white);
    double? radiusLabelSale = ConvertData.stringToDouble(get(styles, ['radiusLabelSale'], 10));

    double? radiusImage = ConvertData.stringToDouble(get(styles, ['radiusImage'], 8));
    String? typeCart = get(styles, ['typeCart'], 'elevated');
    double? radiusCart = ConvertData.stringToDouble(get(styles, ['radiusCart'], 8));
    String? iconCart = get(styles, ['iconCart', 'name'], 'plus');
    String? sizeImage = get(styles, ['sizeImage'], 'cover');

    return CirillaProductItem(
      product: product,
      template: templateItem,
      dataTemplate: {'imageSize': sizeImage},
      width: size.width,
      height: size.height,
      textColor: textColor,
      subTextColor: subTextColor,
      priceColor: priceColor,
      salePriceColor: salePriceColor,
      regularPriceColor: regularPriceColor,
      labelNewColor: labelNewColor,
      labelNewTextColor: labelNewTextColor,
      labelNewRadius: radiusLabelNew,
      labelSaleColor: labelSaleColor,
      labelSaleTextColor: labelSaleTextColor,
      labelSaleRadius: radiusLabelSale,
      radiusImage: radiusImage,
      background: Colors.transparent,
      wishlistColor: wishlistColor,
      radius: 0,
      iconAddCart: get(FeatherIconsMap, [iconCart], FeatherIcons.plus),
      radiusAddCart: radiusCart,
      outlineAddCart: typeCart == 'outline',
    );
  }

  @override
  Widget build(BuildContext context) {
    const List itemSettingList = [
      {
        'layout': 'grid',
        'type': Strings.productItemContained,
        'pad': 32.0,
        'isDivider': false,
        'size': Size(160, 190),
      },
      {
        'layout': 'list',
        'type': Strings.productItemContained,
        'pad': 32.0,
        'isDivider': false,
        'size': Size(335, 397),
      },
      {
        'layout': 'list',
        'type': Strings.productItemHorizontal,
        'pad': 48.0,
        'isDivider': true,
        'size': Size(86, 102),
      },
    ];
    Map settingItem = itemSettingList.elementAt(typeView) ?? itemSettingList.elementAt(0);
    String? layout = get(settingItem, ['layout'], 'grid');
    String? type = get(settingItem, ['type'], Strings.productItemContained);
    double? pad = get(settingItem, ['pad'], 32);
    bool? isDivider = get(settingItem, ['isDivider'], false);
    Size? size = get(settingItem, ['size'], Size(160, 190));
    // double width = MediaQuery.of(context).size.width;
    if (layout == 'grid') {
      return SliverToBoxAdapter(
        child: LayoutBuilder(
          builder: (_, BoxConstraints constraints) {
            double widthView = constraints.maxWidth;
            double spacing = 16;

            double widthItem = (widthView - spacing) / 2;
            double widthImage = widthItem;
            double heightImage = (widthImage * size!.height) / size.width;

            Size sizeImage = Size(widthImage, heightImage);
            return products!.length == 0 || products!.isEmpty
                ? buidEmpty(context)
                : Wrap(
                    spacing: 16,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: List.generate(
                      products!.length,
                      (index) => SizedBox(
                        width: widthItem,
                        child: Column(
                          children: [
                            buildItem(
                              context,
                              product: products!.elementAt(index),
                              templateItem: type,
                              size: sizeImage,
                              styles: styles,
                            ),
                            if (isDivider!) Divider(height: pad, thickness: 1) else SizedBox(height: pad),
                          ],
                        ),
                      ),
                    ),
                  );
          },
        ),
      );
    }
    return products!.length == 0 || products!.isEmpty
        ? SliverToBoxAdapter(child: LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              return buidEmpty(context);
            },
          ))
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                return LayoutBuilder(
                  builder: (_, BoxConstraints constraints) {
                    double widthView = constraints.maxWidth;
                    double widthImage = widthView;
                    double heightImage = (widthImage * size!.height) / size.width;

                    Size sizeImage = Size(widthImage, heightImage);

                    return Column(
                      children: [
                        buildItem(
                          context,
                          product: products!.elementAt(index),
                          templateItem: type,
                          size: sizeImage,
                          styles: styles,
                        ),
                        if (isDivider!) Divider(height: pad, thickness: 1) else SizedBox(height: pad),
                      ],
                    );
                  },
                );
              },
              childCount: products!.length,
            ),
          );
  }

  Widget buidEmpty(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return NotificationScreen(
      title: Text(
        translate('product')!,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      ),
      content: Text(translate('product_no_products_were_found')!,
          style: Theme.of(context).textTheme.bodyText2, textAlign: TextAlign.center),
      iconData: FeatherIcons.layers,
      textButton: Text(translate('order_return_shop')!),
      onPressed: () => navigate(context, {
        "type": "tab",
        "router": "/",
        "args": {"key": "screens_category"}
      }),
    );
  }
}
