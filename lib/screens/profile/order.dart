import 'package:cirilla/constants/constants.dart';

import 'package:cirilla/mixins/mixins.dart';

import 'package:cirilla/models/order/order.dart';

import 'package:cirilla/screens/order/order_detail.dart';

import 'package:cirilla/service/helpers/request_helper.dart';

import 'package:cirilla/store/auth/auth_store.dart';

import 'package:cirilla/store/order/order_store.dart';

import 'package:cirilla/types/types.dart';

import 'package:cirilla/utils/app_localization.dart';

import 'package:cirilla/utils/utils.dart';

import 'package:feather_icons/feather_icons.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:provider/provider.dart';

import 'package:ui/notification/notification_screen.dart';

import 'package:ui/ui.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with LoadingMixin, NavigationMixin, AppBarMixin {
  OrderStore? _orderStore;

  late AuthStore _authStore;

  final ScrollController _controller = ScrollController();

  void initState() {
    super.initState();

    _controller.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _authStore = Provider.of<AuthStore>(context);

    RequestHelper requestHelper = Provider.of<RequestHelper>(context);

    _orderStore = OrderStore(
      requestHelper,
      customer: ConvertData.stringToInt(_authStore.user!.id),
    )..getOrders();
  }

  void _onScroll() {
    if (!_controller.hasClients || _orderStore!.loading || !_orderStore!.canLoadMore) return;

    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _orderStore!.getOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(builder: (_) {
      return Scaffold(
        appBar: baseStyleAppBar(context, title: translate('order_return')!),
        body: Stack(
          children: [
            CustomScrollView(physics: BouncingScrollPhysics(), controller: _controller, slivers: <Widget>[
              CupertinoSliverRefreshControl(
                onRefresh: _orderStore!.refresh,
                builder: buildAppRefreshIndicator,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    OrderData order = _orderStore!.orders.elementAt(index);

                    List lineItems = order.lineItems!;

                    return _buildOrderList(_orderStore, order, lineItems);
                  },
                  childCount: _orderStore!.orders.length,
                ),
              ),
              if (_orderStore!.loading)
                SliverToBoxAdapter(
                  child: buildLoading(context, isLoading: _orderStore!.canLoadMore),
                ),
            ]),
            if (_orderStore!.orders.isEmpty && !_orderStore!.loading) _buildOrderEmpty()
          ],
        ),
      );
    });
  }

  Widget _buildOrderList(OrderStore? orderStore, OrderData order, List lineItems) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    String status = get(order.status, [], 'processing');

    Map<String, dynamic> types = {
      'on-hold': Color(0xFFFFA200),
      'processing': Color(0xFF0B69FF),
      'refund': Theme.of(context).errorColor,
      'successful': Color(0xFF21BA45),
      'completed': Color(0xFF2BBD69),
    };

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: layoutPadding, vertical: 10),
      child: OrderReturnItem(
        name: Text(
          lineItems.map((e) => e.name).join(' - '),
          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).textTheme.subtitle1!.color),
        ),
        dateTime: Text(
          formatDate(date: order.dateCreated!),
          style: Theme.of(context).textTheme.caption,
        ),
        code: Text(
          'ID: #${order.id}',
          style: Theme.of(context).textTheme.caption,
        ),
        total: Text(translate('order_total')!, style: Theme.of(context).textTheme.overline),
        price: Text(formatCurrency(context, currency: order.currency, price: order.total, symbol: order.currencySymbol),
            style: Theme.of(context).textTheme.subtitle1),
        onClick: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, _a1, _a2) => OrderDetailScreen(
                orderDetail: order,
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                Offset begin = Offset(0.0, 1.0);

                Offset end = Offset.zero;

                Curve curve = Curves.ease;

                Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        },
        status: Badge(
          text: Text(
            status,
            style: Theme.of(context).textTheme.overline!.copyWith(color: Color(0xFFFFFFFF)),
          ),
          color: types[status] ?? Theme.of(context).errorColor,
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Widget _buildOrderEmpty() {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return NotificationScreen(
      title: Text(
        translate('order')!,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      ),
      content: Text(translate('order_no_order_has_been_made_yet')!, style: Theme.of(context).textTheme.bodyText2),
      iconData: FeatherIcons.box,
      textButton: Text(translate('order_return_shop')!),
      onPressed: () => navigate(context, {
        "type": "tab",
        "router": "/",
        "args": {"key": "screens_category"}
      }),
    );
  }
}
