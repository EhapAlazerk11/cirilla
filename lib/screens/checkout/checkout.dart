import 'dart:async';
import 'dart:io';
import 'package:cirilla/mixins/loading_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/checkout/order_received.dart';
import 'package:cirilla/service/constants/endpoints.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Checkout extends StatefulWidget {
  static const routeName = '/checkout';

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> with LoadingMixin, TransitionMixin, AppBarMixin {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  bool _loading = true;
  late SettingStore _settingStore;
  late CartStore _cartStore;
  late AuthStore _authStore;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _cartStore = Provider.of<CartStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    super.didChangeDependencies();
  }

  void navigateOrderReceived(BuildContext context) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, _a1, _a2) => OrderReceived(),
      transitionsBuilder: slideTransition,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      Map<String, String?> queryParams = {
        'cart_key_restore': _cartStore.cartKey,
        'app-builder-checkout-body-class': 'app-builder-checkout'
      };

      if (_authStore.isLogin) {
        queryParams.putIfAbsent('app-builder-decode', () => 'true');
      }

      if (_settingStore.isCurrencyChanged) {
        queryParams.putIfAbsent('currency', () => _settingStore.currency);
      }

      if (_settingStore.languageKey != "text") {
        queryParams.putIfAbsent(_authStore.isLogin ? '_lang' : 'lang', () => _settingStore.locale);
      }

      String url = _authStore.isLogin ? Endpoints.restUrl + Endpoints.loginToken : _settingStore.checkoutUrl!;

      String checkoutUrl = url + "?" + Uri(queryParameters: queryParams).query;

      TranslateType translate = AppLocalizations.of(context)!.translate;
      return Scaffold(
        appBar: baseStyleAppBar(context, title: translate('cart_checkout')!),
        body: Builder(builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(top: 20),
            child: Stack(
              children: [
                WebView(
                  // initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                    webViewController.clearCache();
                    final cookieManager = CookieManager();
                    cookieManager.clearCookies();

                    if (_authStore.isLogin) {
                      Map<String, String> headers = {"Authorization": "Bearer " + _authStore.token!};
                      webViewController.loadUrl(checkoutUrl, headers: headers);
                    } else {
                      webViewController.loadUrl(checkoutUrl);
                    }
                  },
                  onProgress: (int progress) {
                    print("WebView is loading (progress : $progress%)");
                  },
                  navigationDelegate: (NavigationRequest request) {
                    print(request.url);
                    if (request.url.contains('/order-received/')) {
                      navigateOrderReceived(context);
                    }

                    if (request.url.contains('/cart/')) {
                      Navigator.of(context).pop();
                      return NavigationDecision.prevent;
                    }

                    if (request.url.contains('/my-account/')) {
                      return NavigationDecision.prevent;
                    }

                    return NavigationDecision.navigate;
                  },
                  onPageStarted: (String url) {
                    if (url.contains('/order-received/')) {
                      navigateOrderReceived(context);
                    }
                    print('Page started loading: $url');
                  },
                  onPageFinished: (String url) {
                    setState(() {
                      _loading = false;
                    });
                  },
                  gestureNavigationEnabled: true,
                ),
                if (_loading) buildLoading(context, isLoading: _loading),
              ],
            ),
          );
        }),
      );
    });
  }
}
