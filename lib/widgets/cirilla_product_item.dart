import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/cart_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/mixins/product_mixin.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/product/product_brand.dart';
import 'package:cirilla/models/product/product_type.dart';
import 'package:cirilla/screens/auth/login_screen.dart';
import 'package:cirilla/screens/product/product.dart';
import 'package:cirilla/screens/product/product_quick_view.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';

class CirillaProductItem extends StatefulWidget {
  final Product? product;

  // Product item template
  final String? template;

  final double width;

  final double height;

  final Map<String, dynamic>? dataTemplate;

  final Color? background;
  final Color? textColor;
  final Color? subTextColor;
  final Color? priceColor;
  final Color? salePriceColor;
  final Color? regularPriceColor;
  final Color? wishlistColor;

  final Color? labelNewColor;
  final Color? labelNewTextColor;
  final double? labelNewRadius;

  final Color? labelSaleColor;
  final Color? labelSaleTextColor;
  final double? labelSaleRadius;

  final IconData? iconAddCart;
  final double? radiusAddCart;
  final bool? outlineAddCart;
  // use card vartical or card horizontal
  final bool? enableIconCart;

  final double? radius;
  final double? radiusImage;

  final List<BoxShadow>? boxShadow;

  final Border? border;
  final EdgeInsetsGeometry? padding;

  const CirillaProductItem({
    Key? key,
    this.product,
    this.template = Strings.productItemContained,
    this.width = 160,
    this.height = 190,
    this.dataTemplate = const {},
    this.background,
    this.textColor,
    this.subTextColor,
    this.priceColor,
    this.salePriceColor,
    this.regularPriceColor,
    this.wishlistColor,
    this.labelNewColor,
    this.labelNewTextColor,
    this.labelNewRadius = 10,
    this.labelSaleColor,
    this.labelSaleTextColor,
    this.labelSaleRadius = 10,
    this.radius,
    this.radiusImage,
    this.boxShadow,
    this.border,
    this.iconAddCart,
    this.outlineAddCart,
    this.radiusAddCart,
    this.enableIconCart,
    this.padding,
  }) : super(key: key);

  @override
  _CirillaProductItemState createState() => _CirillaProductItemState();
}

class _CirillaProductItemState extends State<CirillaProductItem>
    with CartMixin, SnackMixin, ProductMixin, Utility, WishListMixin, LoadingMixin, ShapeMixin, GeneralMixin {
  int _quantity = 1;
  bool _loading = false;
  SettingStore? _settingStore;
  late AuthStore _authStore;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    super.didChangeDependencies();
  }

  ///
  /// Handle add to cart
  Future<void> _handleAddToCart(BuildContext context) async {
    if (widget.product == null || widget.product!.id == null) return;

    if (widget.product!.type == ProductType.external) {
      await launch(widget.product!.externalUrl!);
      return;
    }

    if (getConfig(_settingStore!, ['forceLoginAddToCart'], false) && !_authStore.isLogin) {
      Navigator.of(context).pushNamed(
        LoginScreen.routeName,
        arguments: {'showMessage': ({String? message}) => print('Login Success')},
      );
      return;
    }

    if (getConfig(_settingStore!, ['enableProductQuickView'], false)) {
      _showQuickView();
      return;
    }

    if (widget.product!.type == ProductType.variable || widget.product!.type == ProductType.grouped) {
      _navigate(context);
      return;
    }

    setState(() {
      _loading = true;
    });
    try {
      await addToCart(productId: widget.product!.id, qty: _quantity);
      showSuccess(context, AppLocalizations.of(context)!.translate('product_add_to_cart_success'));
      setState(() {
        _loading = false;
      });
    } catch (e) {
      showError(context, e);
      setState(() {
        _loading = false;
      });
    }
  }

  ///
  /// Handle navigate
  void _navigate(BuildContext context) {
    if (widget.product == null || widget.product!.id == null) return;
    Navigator.pushNamed(context, ProductScreen.routeName, arguments: {'product': widget.product});
  }

  ///
  /// Handle wishlist
  void _wishlist(BuildContext context) {
    if (widget.product == null || widget.product!.id == null) return;
    addWishList(productId: widget.product!.id);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    String themeModeKey = _settingStore!.themeModeKey;

    WidgetConfig widgetConfig = _settingStore!.data!.settings!['general']!.widgets!['general']!;
    bool productItemLabelEnableRating = get(widgetConfig.fields, ['productItemLabelEnableRating'], true);
    bool productItemLabelEnableSale = get(widgetConfig.fields, ['productItemLabelEnableSale'], true);
    bool productItemLabelEnableNew = get(widgetConfig.fields, ['productItemLabelEnableNew'], true);
    bool productItemEnableQuantity = get(widgetConfig.fields, ['productItemEnableQuantity'], true);

    bool? enableLabelNew = get(widget.dataTemplate, ['enableLabelNew'], productItemLabelEnableNew);
    bool? enableLabelSale = get(widget.dataTemplate, ['enableLabelSale'], productItemLabelEnableSale);
    bool? enableCategory = get(widget.dataTemplate, ['enableCategory'], true);
    bool? enableRating = get(widget.dataTemplate, ['enableRating'], productItemLabelEnableRating);
    bool enableQuantity = get(widget.dataTemplate, ['enableQuantity'], productItemEnableQuantity);
    BoxFit fit = ConvertData.toBoxFit(get(widget.dataTemplate, ['imageSize'], 'cover'));

    TextStyle stylePrice = theme.textTheme.subtitle2!.copyWith(color: widget.priceColor);
    TextStyle styleSale = theme.textTheme.subtitle2!.copyWith(color: widget.salePriceColor ?? Color(0xFFF01F0E));
    TextStyle styleRegular =
        theme.textTheme.subtitle2!.copyWith(color: widget.regularPriceColor, fontWeight: FontWeight.normal);
    TextStyle styleTextFrom = theme.textTheme.caption!.copyWith(color: widget.subTextColor);
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        switch (widget.template) {
          case Strings.productItemHorizontal:
            double widthImage = 86;
            double heightImage = (widthImage * widget.height) / widget.width;
            double widthView = widget.width;
            return SizedBox(
              width: widthView,
              child: ProductHorizontalItem(
                image: buildImage(
                  context,
                  product: widget.product!,
                  width: widthImage,
                  height: heightImage,
                  borderRadius: widget.radiusImage,
                  fit: fit,
                ),
                name: buildName(
                  context,
                  product: widget.product!,
                  style: theme.textTheme.bodyText2!.copyWith(color: widget.textColor),
                ),
                price: buildPrice(
                  context,
                  product: widget.product!,
                  priceStyle: stylePrice,
                  saleStyle: styleSale,
                  regularStyle: styleRegular,
                  styleFrom: styleTextFrom,
                ),
                tagExtra: enableLabelNew! || enableLabelSale!
                    ? buildTagExtra(
                        context,
                        product: widget.product!,
                        enableNew: enableLabelNew,
                        newColor: widget.labelNewColor,
                        newTextColor: widget.labelNewTextColor,
                        newRadius: widget.labelNewRadius,
                        enableSale: enableLabelSale,
                        saleColor: widget.labelSaleColor,
                        saleTextColor: widget.labelSaleTextColor,
                        saleRadius: widget.labelSaleRadius,
                      )
                    : null,
                addCard: _loading
                    ? _buildLoading(context)
                    : buildAddCart(
                        context,
                        product: widget.product!,
                        onTap: () => _handleAddToCart(context),
                        icon: widget.iconAddCart ?? FeatherIcons.plus,
                        radius: widget.radiusAddCart ?? 8,
                        isButtonOutline: widget.outlineAddCart ?? false,
                      ),
                rating:
                    enableRating! ? buildRating(context, product: widget.product!, color: widget.subTextColor) : null,
                quantity: enableQuantity
                    ? buildQuantityItem(
                        context,
                        product: widget.product!,
                        quantity: _quantity,
                        onChanged: (int value) => setState(() {
                          _quantity = value;
                        }),
                      )
                    : null,
                borderRadius: BorderRadius.circular(widget.radius ?? 0),
                border: widget.border,
                boxShadow: widget.boxShadow,
                color: widget.background ?? Colors.transparent,
                onClick: () => _navigate(context),
                padding: widget.padding ?? EdgeInsets.zero,
              ),
            );
          case Strings.productItemEmerge:
            return ProductEmergeItem(
              image: buildImage(
                context,
                product: widget.product!,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
              ),
              name: buildName(
                context,
                product: widget.product!,
                style: theme.textTheme.subtitle1!.copyWith(color: widget.textColor),
              ),
              price: buildPrice(
                context,
                product: widget.product!,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew! || enableLabelSale!
                  ? buildTagExtra(
                      context,
                      product: widget.product!,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              addCart: _loading
                  ? _buildLoading(context)
                  : buildAddCart(
                      context,
                      product: widget.product!,
                      onTap: () => _handleAddToCart(context),
                      icon: widget.iconAddCart ?? FeatherIcons.plus,
                      radius: widget.radiusAddCart ?? 34,
                      isButtonOutline: widget.outlineAddCart ?? false,
                    ),
              rating: enableRating! ? buildRating(context, product: widget.product!, color: widget.subTextColor) : null,
              category: enableCategory!
                  ? buildCategory(context, product: widget.product!, color: widget.subTextColor)
                  : Container(),
              wishlist: buildWishlist(
                context,
                product: widget.product!,
                isSelected: existWishList(productId: widget.product!.id),
                color: widget.wishlistColor,
                onTap: () => _wishlist(context),
              ),
              quantity: enableQuantity
                  ? buildQuantityItem(
                      context,
                      product: widget.product!,
                      quantity: _quantity,
                      onChanged: (int value) => setState(() {
                        _quantity = value;
                      }),
                    )
                  : null,
              width: widget.width,
              borderRadius: BorderRadius.circular(widget.radius ?? 0),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background,
              padding: widget.padding,
              onClick: () => _navigate(context),
            );
          case Strings.productItemVertical:
            return ProductVerticalItem(
              image: buildImage(
                context,
                product: widget.product!,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
              ),
              name: buildName(
                context,
                product: widget.product!,
                style: theme.textTheme.subtitle1!.copyWith(color: widget.textColor),
              ),
              price: buildPrice(
                context,
                product: widget.product!,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew! || enableLabelSale!
                  ? buildTagExtra(
                      context,
                      product: widget.product!,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              addCard: _loading
                  ? _buildLoading(context)
                  : buildAddCart(
                      context,
                      product: widget.product!,
                      icon: widget.iconAddCart ?? FeatherIcons.plus,
                      radius: widget.radiusAddCart ?? 34,
                      isButtonOutline: widget.outlineAddCart ?? false,
                      onTap: () => _handleAddToCart(context),
                    ),
              rating: enableRating! ? buildRating(context, product: widget.product!, color: widget.subTextColor) : null,
              category: enableCategory!
                  ? buildCategory(context, product: widget.product!, color: widget.subTextColor)
                  : Container(),
              wishlist: buildWishlist(
                context,
                product: widget.product!,
                color: widget.wishlistColor,
                isSelected: existWishList(productId: widget.product!.id),
                onTap: () => _wishlist(context),
              ),
              quantity: enableQuantity
                  ? buildQuantityItem(
                      context,
                      product: widget.product!,
                      quantity: _quantity,
                      onChanged: (int value) => setState(() {
                        _quantity = value;
                      }),
                    )
                  : null,
              width: widget.width,
              borderRadius: BorderRadius.circular(widget.radius ?? 0),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background,
              padding: widget.padding,
              onClick: () => _navigate(context),
            );
          case Strings.productItemVerticalCenter:
            return ProductVerticalItem(
              image: buildImage(
                context,
                product: widget.product!,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
              ),
              name: buildName(
                context,
                product: widget.product!,
                style: theme.textTheme.subtitle1!.copyWith(color: widget.textColor),
              ),
              price: buildPrice(
                context,
                product: widget.product!,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew! || enableLabelSale!
                  ? buildTagExtra(
                      context,
                      product: widget.product!,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              addCard: _loading
                  ? _buildLoading(context)
                  : buildAddCart(
                      context,
                      product: widget.product!,
                      icon: widget.iconAddCart,
                      text: translate('product_add_to_cart'),
                      isButtonOutline: widget.outlineAddCart ?? true,
                      radius: widget.radiusAddCart ?? 8,
                      onTap: () => _handleAddToCart(context),
                    ),
              rating: enableRating! ? buildRating(context, product: widget.product!, color: widget.subTextColor) : null,
              category: enableCategory!
                  ? buildCategory(context, product: widget.product!, color: widget.subTextColor)
                  : false as Widget,
              wishlist: buildWishlist(
                context,
                product: widget.product!,
                color: widget.wishlistColor,
                isSelected: existWishList(productId: widget.product!.id),
                onTap: () => _wishlist(context),
              ),
              quantity: enableQuantity
                  ? buildQuantityItem(
                      context,
                      product: widget.product!,
                      quantity: _quantity,
                      onChanged: (int value) => setState(() {
                        _quantity = value;
                      }),
                    )
                  : null,
              width: widget.width,
              type: ProductVerticalItemType.center,
              borderRadius: BorderRadius.circular(widget.radius ?? 0),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background,
              padding: widget.padding,
              onClick: () => _navigate(context),
            );
          case Strings.productItemCardHorizontal:
            bool enablePrice = get(widget.dataTemplate, ['enablePrice'], false);
            double? opacity = ConvertData.stringToDouble(get(widget.dataTemplate, ['opacity'], 0.6), 0.6);
            dynamic opacityColor = get(widget.dataTemplate, ['opacityColor'], Colors.black);
            Color colorOpacity = opacityColor is Color
                ? opacityColor
                : opacityColor is Map
                    ? ConvertData.fromRGBA(get(opacityColor, [themeModeKey], {}), Colors.black)
                    : Colors.black;

            return ProductCardHorizontalItem(
              image: buildImage(
                context,
                product: widget.product!,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
              ),
              category: enableCategory!
                  ? buildCategory(context, product: widget.product!, color: widget.subTextColor ?? Colors.white)
                  : null,
              name: buildName(
                context,
                product: widget.product!,
                style: theme.textTheme.subtitle2!.copyWith(color: widget.textColor ?? Colors.white),
              ),
              price: enablePrice
                  ? buildPrice(
                      context,
                      product: widget.product!,
                      priceStyle: stylePrice,
                      saleStyle: styleSale,
                      regularStyle: styleRegular,
                      styleFrom: styleTextFrom,
                    )
                  : null,
              tagExtra: enableLabelNew! || enableLabelSale!
                  ? buildTagExtra(
                      context,
                      product: widget.product!,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              quantity: enableQuantity
                  ? buildQuantityItem(
                      context,
                      product: widget.product!,
                      quantity: _quantity,
                      onChanged: (int value) => setState(() {
                        _quantity = value;
                      }),
                    )
                  : null,
              wishlist: buildWishlist(
                context,
                product: widget.product!,
                color: widget.wishlistColor ?? Colors.black,
                isSelected: existWishList(productId: widget.product!.id),
                onTap: () => _wishlist(context),
              ),
              addCart: _loading
                  ? _buildLoading(context)
                  : buildAddCart(
                      context,
                      product: widget.product!,
                      enableIconCart: widget.enableIconCart ?? false,
                      icon: widget.iconAddCart,
                      text: translate('product_buy_product'),
                      radius: widget.radiusAddCart ?? 8,
                      isButtonOutline: widget.outlineAddCart ?? false,
                      onTap: () => _handleAddToCart(context),
                    ),
              width: widget.width,
              padding: widget.padding ?? EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background,
              opacity: opacity,
              colorOpacity: colorOpacity,
              onClick: () => _navigate(context),
            );
          case Strings.productItemCardVertical:
            List<ProductBrand?> brands = widget.product?.brands ?? [];
            return ProductCardVerticalItem(
              image: buildImage(
                context,
                product: widget.product!,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
              ),
              category: enableCategory!
                  ? buildCategory(context, product: widget.product!, color: widget.subTextColor ?? Colors.white)
                  : null,
              name: buildName(
                context,
                product: widget.product!,
                style: theme.textTheme.subtitle2!.copyWith(color: widget.textColor ?? Colors.white),
              ),
              price: buildPrice(
                context,
                product: widget.product!,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              rating: enableRating! ? buildRating(context, product: widget.product!, color: widget.subTextColor) : null,
              wishlist: buildWishlist(
                context,
                product: widget.product!,
                color: widget.wishlistColor ?? Colors.black,
                isSelected: existWishList(productId: widget.product!.id),
                onTap: () => _wishlist(context),
              ),
              addCard: _loading
                  ? _buildLoading(context)
                  : SizedBox(
                      width: double.infinity,
                      child: buildAddCart(
                        context,
                        product: widget.product!,
                        enableIconCart: widget.enableIconCart ?? false,
                        icon: widget.iconAddCart,
                        text: translate('product_buy_product'),
                        radius: widget.radiusAddCart ?? 8,
                        isButtonOutline: widget.outlineAddCart ?? false,
                        onTap: () => _handleAddToCart(context),
                      ),
                    ),
              tagExtra: brands.length > 0
                  ? buildBrand(
                      context,
                      product: widget.product,
                      color: widget.subTextColor,
                    )
                  : null,
              quantity: enableQuantity
                  ? buildQuantityItem(
                      context,
                      product: widget.product!,
                      quantity: _quantity,
                      onChanged: (int value) => setState(() {
                        _quantity = value;
                      }),
                    )
                  : null,
              borderRadius: BorderRadius.circular(widget.radius ?? 8),
              border: widget.border,
              color: widget.background,
              boxShadow: widget.boxShadow ?? initBoxShadow,
              padding: widget.padding ?? EdgeInsets.all(16),
              width: widget.width,
              onClick: () => _navigate(context),
            );
          case Strings.productItemCurve:
            double pad = widget.padding != null ? widget.padding!.horizontal : 16;
            double widthImage = widget.width - pad;
            double heightImage = (widthImage * widget.height) / widget.width;
            return ProductCurveItem(
              image: buildImage(
                context,
                product: widget.product!,
                width: widthImage,
                height: heightImage,
                borderRadius: widget.radiusImage ?? 12,
                fit: fit,
              ),
              name: buildName(
                context,
                product: widget.product!,
                style: theme.textTheme.bodyText2!.copyWith(color: widget.textColor),
              ),
              price: buildPrice(
                context,
                product: widget.product!,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew! || enableLabelSale!
                  ? buildTagExtra(
                      context,
                      product: widget.product!,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              wishlist: buildWishlist(
                context,
                product: widget.product!,
                color: widget.wishlistColor ?? Colors.black,
                isSelected: existWishList(productId: widget.product!.id),
                onTap: () => _wishlist(context),
              ),
              addCard: _loading
                  ? _buildLoading(context)
                  : buildAddCart(
                      context,
                      product: widget.product!,
                      icon: widget.iconAddCart ?? FeatherIcons.plus,
                      radius: widget.radiusAddCart ?? 8,
                      isButtonOutline: widget.outlineAddCart ?? false,
                      onTap: () => _handleAddToCart(context),
                      enableAllRadius: false,
                    ),
              rating: enableRating!
                  ? buildRating(context, product: widget.product!, showNumber: true, color: widget.subTextColor)
                  : null,
              quantity: enableQuantity
                  ? buildQuantityItem(
                      context,
                      product: widget.product!,
                      quantity: _quantity,
                      onChanged: (int value) => setState(() {
                        _quantity = value;
                      }),
                    )
                  : null,
              width: widget.width,
              borderRadius: BorderRadius.circular(widget.radius ?? 16),
              border: widget.border,
              boxShadow: widget.boxShadow ?? initBoxShadow,
              color: widget.background ?? theme.cardColor,
              padding: widget.padding ?? EdgeInsets.all(8),
              onClick: () => _navigate(context),
            );
          default:
            return ProductContainedItem(
              image: buildImage(
                context,
                product: widget.product!,
                width: widget.width,
                height: widget.height,
                borderRadius: widget.radiusImage,
                fit: fit,
              ),
              name: buildName(
                context,
                product: widget.product!,
                style: theme.textTheme.bodyText2!.copyWith(color: widget.textColor),
              ),
              price: buildPrice(
                context,
                product: widget.product!,
                priceStyle: stylePrice,
                saleStyle: styleSale,
                regularStyle: styleRegular,
                styleFrom: styleTextFrom,
              ),
              tagExtra: enableLabelNew! || enableLabelSale!
                  ? buildTagExtra(
                      context,
                      product: widget.product!,
                      enableNew: enableLabelNew,
                      newColor: widget.labelNewColor,
                      newTextColor: widget.labelNewTextColor,
                      newRadius: widget.labelNewRadius,
                      enableSale: enableLabelSale,
                      saleColor: widget.labelSaleColor,
                      saleTextColor: widget.labelSaleTextColor,
                      saleRadius: widget.labelSaleRadius,
                    )
                  : null,
              wishlist: buildWishlist(
                context,
                product: widget.product!,
                color: widget.wishlistColor ?? Colors.black,
                isSelected: existWishList(productId: widget.product!.id),
                onTap: () => _wishlist(context),
              ),
              addCard: _loading
                  ? _buildLoading(context)
                  : buildAddCart(
                      context,
                      product: widget.product!,
                      icon: widget.iconAddCart ?? FeatherIcons.plus,
                      radius: widget.radiusAddCart ?? 8,
                      isButtonOutline: widget.outlineAddCart ?? false,
                      onTap: () => _handleAddToCart(context),
                    ),
              rating: enableRating! ? buildRating(context, product: widget.product!, color: widget.subTextColor) : null,
              quantity: enableQuantity
                  ? buildQuantityItem(
                      context,
                      product: widget.product!,
                      quantity: _quantity,
                      onChanged: (int value) => setState(() {
                        _quantity = value;
                      }),
                    )
                  : null,
              width: widget.width,
              borderRadius: BorderRadius.circular(widget.radius ?? 0),
              border: widget.border,
              boxShadow: widget.boxShadow,
              color: widget.background ?? Colors.transparent,
              padding: widget.padding,
              onClick: () => _navigate(context),
            );
        }
      },
    );
  }

  _buildLoading(BuildContext context) {
    return Container(child: Center(child: entryLoading(context)), width: 32, height: 32);
  }

  _showQuickView() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: borderRadiusTop(),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(top: 20),
          child: ProductQuickView(
            store: _settingStore,
            args: {'product': widget.product},
          ),
        );
      },
    );
  }
}
