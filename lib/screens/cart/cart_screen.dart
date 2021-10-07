import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/cart_mixin.dart';
import 'package:cirilla/mixins/loading_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/mixins/navigation_mixin.dart';
import 'package:cirilla/mixins/snack_mixin.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/models/cart/cart.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/cart/widgets/cart_coupon.dart';
import 'package:cirilla/screens/cart/widgets/cart_items.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';

class CartScreen extends StatefulWidget {
  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen>
    with LoadingMixin, Utility, CartMixin, SnackMixin, NavigationMixin, AppBarMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  TextEditingController myController = TextEditingController();
  CartStore? _cartStore;
  SettingStore? _settingStore;

  List<CartItem>? _items = List<CartItem>.of([]);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartStore = Provider.of<CartStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
    if (_cartStore!.cartData != null) {
      setState(() {
        _items = _cartStore!.cartData!.items;
      });
    }
    getData();
  }

  Future<void> getData() async {
    await _cartStore!.getCart();
    if (_cartStore!.cartData != null) {
      if (mounted) {
        setState(() {
          _items = _cartStore!.cartData!.items;
        });
      }
    }
  }

  updateQuantity(BuildContext context, CartItem cartItem, int value) {
    _cartStore!.updateQuantity(key: cartItem.key, quantity: value);
  }

  Future<void> onRemoveItem(BuildContext context, CartItem cartItem, int index) async {
    _listKey.currentState!.removeItem(index, (_, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: Item(
          cartItem: cartItem,
          updateQuantity: (BuildContext context, CartItem cartItem, int value) {
            print('removed');
          },
        ),
      );
    }, duration: Duration(milliseconds: 250));
    _items!.removeAt(index);
    try {
      await _cartStore!.removeCart(key: cartItem.key);
    } catch (e) {
      showError(context, e);
    }
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    bool enableGuestCheckout = true;
    bool loadingShipping = true;
    // Configs
    Data data = _settingStore!.data!.screens!['cart']!;
    Map<String, WidgetConfig> widgets = data.widgets ?? {};
    Map<String, dynamic> fields = widgets['cartPage']?.fields ?? {};
    bool enableShipping = get(fields, ['enableShipping'], true);
    bool enableCoupon = get(fields, ['enableCoupon'], true);

    return Observer(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: _cartStore!.cartData != null
              ? Text(
                  translate('cart_count', {'count': '(${_items!.length.toString()})'})!,
                  style: Theme.of(context).textTheme.subtitle1,
                )
              : Text(translate('cart_no_count')!, style: Theme.of(context).textTheme.subtitle1),
          shadowColor: Colors.transparent,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            if (_cartStore!.cartData != null) ...[
              if (_items!.length < 1 && !_cartStore!.loading) buildCartEmpty(context),
              if (_items!.length != 0)
                AnimatedList(
                  key: _listKey,
                  initialItemCount: _items!.length + 1,
                  itemBuilder: (context, index, animation) {
                    if (index == _items!.length) {
                      return buildCoupon(context, _cartStore, enableGuestCheckout, enableShipping, enableCoupon);
                    }
                    return buildItem(_items![index], animation, index);
                  },
                ),
            ],
            if (_cartStore!.loading && _items!.length == 0) buildLoading(context, isLoading: _cartStore!.loading),
            if (_cartStore!.loadingShipping && loadingShipping)
              Align(
                child: buildLoadingOverlay(context),
                alignment: FractionalOffset.center,
              ),
          ],
        ),
      );
    });
  }

  Widget buildItem(CartItem cartItem, Animation animation, int index) {
    return SizeTransition(
      sizeFactor: animation as Animation<double>,
      child: Column(
        children: [
          Item(
            cartItem: cartItem,
            onRemove: () => {if (!_cartStore!.loading) onRemoveItem(context, cartItem, index)},
            updateQuantity: updateQuantity,
          ),
          Divider(height: 2, thickness: 1),
        ],
      ),
    );
  }

  Widget buildCoupon(
      BuildContext context, CartStore? cartStore, bool enableGuestCheckout, bool enableShipping, bool enableCoupon) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: layoutPadding, end: layoutPadding, top: itemPaddingLarge, bottom: 150),
      child: CartCoupon(
        cartStore: cartStore,
        enableGuestCheckout: enableGuestCheckout,
        enableShipping: enableShipping,
        enableCoupon: enableCoupon,
      ),
    );
  }

  Widget buildCartEmpty(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Container(
      child: NotificationScreen(
        title: Text(translate('cart_no_count')!, style: Theme.of(context).textTheme.headline6),
        content: Text(
          translate('cart_is_currently_empty')!,
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
        iconData: FeatherIcons.shoppingCart,
        textButton: Text(translate('cart_return_shop')!),
        styleBtn: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: itemPaddingLarge)),
        onPressed: () => navigate(context, {
          "type": "tab",
          "router": "/",
          "args": {"key": "screens_category"}
        }),
      ),
    );
  }
}
