import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/models/product/product_brand.dart';

import 'package:cirilla/models/product/product_category.dart';
import 'package:cirilla/models/product/product_type.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/utils/currency_format.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_quantity.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:ui/ui.dart';
import 'package:cirilla/widgets/widgets.dart';

mixin ProductMixin {
  Widget buildImage(
    BuildContext context, {
    required Product product,
    double width = 100,
    double height = 100,
    double? borderRadius,
    BoxFit fit = BoxFit.cover,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      child: CirillaCacheImage(
        product.images!.length > 0 ? product.images![0]!.shopCatalog : Assets.noImageUrl,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }

  Widget buildName(
    BuildContext context, {
    required Product product,
    TextStyle? style,
    double shimmerWidth = 140,
    double shimmerHeight = 16,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
    }

    return Text(
      product.name!,
      style: style,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  double getPercent(Product product) {
    double salePrice = ConvertData.stringToDouble(product.salePrice);
    double regularPrice = ConvertData.stringToDouble(product.regularPrice);
    if (salePrice > 0 && salePrice <= regularPrice) {
      return ((regularPrice - salePrice) * 100) / (regularPrice == 0 ? 1 : regularPrice);
    }
    return 0;
  }

  Widget buildPrice(
    BuildContext context, {
    required Product product,
    TextStyle? priceStyle,
    TextStyle? saleStyle,
    TextStyle? regularStyle,
    TextStyle? styleFrom,
    TextStyle? stylePercentSale,
    bool enablePercentSale = false,
    Color colorPercentSale = const Color(0xFFF01F0E),
    double sizePercentSale = 19,
    double spacing = 4,
    double shimmerWidth = 50,
    double shimmerHeight = 12,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          margin: EdgeInsets.only(top: 4),
          height: shimmerHeight,
          width: shimmerWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
    }
    ThemeData theme = Theme.of(context);
    TextStyle? stylePrice = priceStyle is TextStyle ? priceStyle : theme.textTheme.subtitle2;
    TextStyle styleSale =
        saleStyle is TextStyle ? saleStyle : theme.textTheme.subtitle2!.copyWith(color: Color(0xFFF01F0E));
    TextStyle? styleRegular = regularStyle is TextStyle ? regularStyle : theme.textTheme.subtitle2;
    TextStyle? styleTextFrom = styleFrom is TextStyle ? styleFrom : theme.textTheme.caption;
    TextStyle stylePercent =
        stylePercentSale is TextStyle ? stylePercentSale : theme.textTheme.overline!.copyWith(color: Colors.white);

    String? price = product.regularPrice is String && product.regularPrice != ''
        ? product.regularPrice
        : product.price is String && product.price != ''
            ? product.price
            : '0';
    String? sale = product.salePrice is String && product.salePrice != '' ? product.salePrice : '0';

    if (product.type == ProductType.variable || product.type == ProductType.grouped) {
      return RichText(
        text: TextSpan(
          text: AppLocalizations.of(context)!.translate('product_from'),
          children: [TextSpan(text: formatCurrency(context, price: price), style: stylePrice)],
          style: styleTextFrom,
        ),
      );
    }
    if (product.onSale!) {
      double percent = getPercent(product);
      return Wrap(
        spacing: spacing,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            formatCurrency(context, price: price),
            style: styleRegular!.copyWith(decoration: TextDecoration.lineThrough),
          ),
          Text(
            formatCurrency(context, price: sale),
            style: styleSale,
          ),
          if (enablePercentSale)
            Badge(
              text: Text('-${percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1)}%',
                  style: stylePercent),
              size: sizePercentSale,
              color: colorPercentSale,
              padding: EdgeInsets.symmetric(horizontal: 8),
            )
        ],
      );
    }
    return Text(
      formatCurrency(context, price: price),
      style: stylePrice,
    );
  }

  Widget buildTagExtra(
    BuildContext context, {
    required Product product,
    double shimmerWidth = 0,
    double shimmerHeight = 0,
    bool? enableNew = true,
    Color? newColor,
    Color? newTextColor,
    double? newRadius,
    bool? enableSale = true,
    Color? saleColor,
    Color? saleTextColor,
    double? saleRadius,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }

    TextStyle style = Theme.of(context).textTheme.overline!.copyWith(color: Colors.white);

    List<Widget> children = [];

    if (enableNew! && compareSpaceDate(date: product.date!, space: spaceTimeNew)) {
      children.add(
        Badge(
          text: Text(
            AppLocalizations.of(context)!.translate('product_new')!,
            style: style.copyWith(color: newTextColor ?? Colors.white),
          ),
          color: newColor ?? Color(0xFF21BA45),
          padding: EdgeInsets.symmetric(horizontal: 8),
          radius: newRadius,
        ),
      );
    }

    if (enableSale! && product.onSale!) {
      if (product.type == ProductType.variable || product.type == ProductType.grouped) {
        children.add(
          Badge(
            text: Text(
              AppLocalizations.of(context)!.translate('product_sale')!,
              style: style.copyWith(color: saleTextColor ?? Colors.white),
            ),
            color: saleColor ?? Color(0xFFF01F0E),
            padding: EdgeInsets.symmetric(horizontal: 8),
            radius: saleRadius,
          ),
        );
      } else {
        String? price = product.regularPrice is String && product.regularPrice != ''
            ? product.regularPrice
            : product.price is String && product.price != ''
                ? product.price
                : '0';
        String? sale = product.salePrice is String && product.salePrice != '' ? product.salePrice : '0';

        double numberPrice = ConvertData.stringToDouble(price);
        double numberSale = ConvertData.stringToDouble(sale);
        double percent = ((numberPrice - numberSale) * 100) / numberPrice;

        children.add(
          Badge(
            text: Text(
              '-${percent.floor()}%',
              style: style.copyWith(color: saleTextColor ?? Colors.white),
            ),
            color: saleColor ?? Color(0xFFF01F0E),
            padding: EdgeInsets.symmetric(horizontal: 8),
            radius: saleRadius,
          ),
        );
      }
    }
    return Wrap(
      spacing: 8,
      children: children,
    );
  }

  Widget buildRating(
    BuildContext context, {
    required Product product,
    Color? color,
    bool showNumber = false,
    double shimmerWidth = 80,
    double shimmerHeight = 12,
    WrapAlignment wrapAlignment = WrapAlignment.start,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
            width: shimmerWidth,
            height: shimmerHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1),
            )),
      );
    }

    double rating = ConvertData.stringToDouble(product.averageRating ?? 0);

    return Wrap(
      spacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: wrapAlignment,
      children: [
        if (showNumber)
          CirillaRating.number(initialValue: rating, textColor: color)
        else
          Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: CirillaRating(initialValue: rating),
          ),
        Text('(${product.ratingCount})', style: Theme.of(context).textTheme.overline!.copyWith(color: color))
      ],
    );
  }

  Widget buildWishlist(
    BuildContext context, {
    required Product product,
    Color? color,
    bool isSelected = false,
    GestureTapCallback? onTap,
    double shimmerWidth = 0,
    double shimmerHeight = 0,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }
    return InkWell(
      onTap: onTap,
      child: Icon(isSelected ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, size: 16, color: color),
    );
  }

  Widget buildQuantityItem(
    BuildContext context, {
    required Product product,
    Color? color,
    int quantity = 1,
    ValueChanged<int>? onChanged,
    double shimmerWidth = 90,
    double shimmerHeight = 34,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }
    ThemeData theme = Theme.of(context);

    return CirillaQuantity(
      value: quantity,
      width: shimmerWidth,
      height: shimmerHeight,
      borderColor: theme.dividerColor,
      onChanged: onChanged,
      actionEmpty: () => {},
    );
  }

  Widget buildAddCart(
    BuildContext context, {
    required Product product,
    bool isButtonOutline = false,
    bool enableIconCart = true,
    IconData? icon,
    String? text,
    double? radius,
    bool enableAllRadius = true,
    GestureTapCallback? onTap,
    double shimmerWidth = 0,
    double shimmerHeight = 0,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }

    ThemeData theme = Theme.of(context);
    String titleText = text ?? '';

    Radius valueRadius = Radius.circular(radius ?? 8);
    BorderRadiusGeometry borderRadius = enableAllRadius
        ? BorderRadius.all(valueRadius)
        : BorderRadiusDirectional.only(
            topStart: valueRadius,
            bottomEnd: valueRadius,
          );
    ButtonStyle style = ElevatedButton.styleFrom(
      minimumSize: titleText.isEmpty ? Size(34, 0) : null,
      padding: EdgeInsets.zero,
      textStyle: theme.textTheme.caption!.copyWith(fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      elevation: 0,
    );
    if (isButtonOutline) {
      style = style.merge(ElevatedButton.styleFrom(
        primary: theme.primaryColor.withOpacity(0.1),
        onPrimary: theme.primaryColor,
      ));
    }
    Icon iconWidget = Icon(icon ?? FeatherIcons.plus, size: 14);
    Widget? titleWidget = titleText.isNotEmpty ? Text(titleText) : null;
    Widget child = titleWidget == null
        ? iconWidget
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (enableIconCart && icon != null) ...[
                  iconWidget,
                  SizedBox(width: 8),
                ],
                Flexible(child: titleWidget),
              ],
            ),
          );
    Widget button = SizedBox(
      height: 34,
      width: titleWidget == null ? 34 : null,
      child: ElevatedButton(
        onPressed: product.stockStatus != 'outofstock' ? onTap : null,
        child: child,
        style: style,
      ),
    );
    return isButtonOutline
        ? DottedBorder(
            borderType: BorderType.RRect,
            radius: valueRadius,
            padding: EdgeInsets.zero,
            color: theme.primaryColor,
            child: button,
          )
        : button;
  }

  Widget buildCategory(
    BuildContext context, {
    required Product product,
    Color? color,
    double shimmerWidth = 0,
    double shimmerHeight = 0,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }
    List<ProductCategory?> categories = product.categories ?? [];
    String name = categories.map((ProductCategory? category) => category!.name).toList().join(' | ');
    return Text(name, style: Theme.of(context).textTheme.caption!.copyWith(color: color));
  }

  Widget buildBrand(
    BuildContext context, {
    Product? product,
    Color? color,
    double shimmerWidth = 70,
    double shimmerHeight = 14,
  }) {
    if (product?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }
    List<ProductBrand?> brands = product?.brands ?? [];
    String name = brands.map((ProductBrand? brand) => brand?.name ?? '').toList().join(' | ');
    return Text(name, style: Theme.of(context).textTheme.caption?.copyWith(color: color));
  }
}
