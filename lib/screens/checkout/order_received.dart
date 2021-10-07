import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/mixins/navigation_mixin.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';

class OrderReceived extends StatefulWidget {
  @override
  _OrderReceivedState createState() => _OrderReceivedState();
}

class _OrderReceivedState extends State<OrderReceived> with NavigationMixin, AppBarMixin {
  late CartStore _cartStore;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _cartStore = Provider.of<CartStore>(context);
    await _cartStore.cleanCart();
    await _cartStore.getCart();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate('order_info')!),
      body: buildNotification(context),
    );
  }

  Widget buildNotification(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Container(
      child: NotificationScreen(
        title: Text(translate('order_congrats')!, style: Theme.of(context).textTheme.headline6),
        content: Text(
          translate('order_thank_you_purchase')!,
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
        iconData: FeatherIcons.check,
        textButton: Text(translate('order_return_shop')!),
        onPressed: () => navigate(context, {
          "type": "tab",
          "router": "/",
          "args": {"key": "screens_category"}
        }),
      ),
    );
  }
}
