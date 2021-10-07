import 'package:cirilla/screens/profile/notification_list.dart';
import 'package:cirilla/screens/profile/notification_detail.dart';
import 'package:cirilla/screens/profile/order.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/screens/web_view/web_view.dart';
import 'package:cirilla/store/store.dart';
import 'package:flutter/material.dart';

import 'screens/profile/address_shipping.dart';

///
/// Define route
class Routes {
  Routes._();

  static const String posts = '/post_list';

  static const String contact = '/contact';

  static const String account = '/profile/account';
  static const String edit_account = '/profile/edit_account';
  static const String help_info = '/profile/help_info';
  static const String change_password = '/profile/change_password';
  static const String address_billing = '/profile/address_billing';
  static const String address_shipping = '/profile/address_shipping';
  static const String setting = '/profile/setting';
  static const String order = '/profile/order';

  static const String checkout = '/checkout';

  static routes(SettingStore store) => <String, WidgetBuilder>{
        HomeScreen.routeName: (context) => HomeScreen(store: store),

        // Auth
        LoginScreen.routeName: (context) => LoginScreen(store: store),
        RegisterScreen.routeName: (context) => RegisterScreen(store: store),
        ForgotScreen.routeName: (context) => ForgotScreen(),
        LoginMobileScreen.routeName: (context) => LoginMobileScreen(),

        // onboarding
        OnBoardingScreen.routeName: (context) => OnBoardingScreen(store: store),

        Checkout.routeName: (context) => Checkout(),

        account: (context) => AccountScreen(),
        edit_account: (context) => EditAccountScreen(),
        change_password: (context) => ChangePasswordScreen(),
        address_billing: (context) => AddressBookScreen(),
        address_shipping: (context) => AddressShippingScreen(),
        help_info: (context) => HelpInfoScreen(store: store),
        setting: (context) => SettingScreen(),
        order: (context) => OrderScreen(),
        contact: (context) => ContactScreen(store: store),

        BrandListScreen.routeName: (context) => BrandListScreen(store: store),
      };

  static onGenerateRoute(dynamic settings, SettingStore store) {
    Uri uri = Uri.parse(settings.name);
    String? name = uri.pathSegments.length > 1 ? "/${uri.pathSegments[0]}" : settings.name;
    dynamic args = uri.pathSegments.length > 1 ? {'id': uri.pathSegments[1]} : settings.arguments;

    return MaterialPageRoute(
      builder: (context) {
        switch (name) {
          case PostScreen.routeName:
            return PostScreen(store: store, args: args);
          case PostListScreen.routeName:
            return PostListScreen(store: store, args: args);
          case PostAuthorScreen.routeName:
            return PostAuthorScreen(args: args);
          case ProductListScreen.routeName:
            return ProductListScreen(store: store, args: args);
          case ProductScreen.routeName:
            return ProductScreen(store: store, args: args);
          case WebViewScreen.routeName:
            return WebViewScreen(args: args);
          case PageScreen.routeName:
            return PageScreen(args: args);
          case CustomScreen.routeName:
            return CustomScreen(screenKey: args['key']);
          case NotificationList.routeName:
            return NotificationList();
          case NotificationDetail.routeName:
            return NotificationDetail(args: args);
          case VendorScreen.routeName:
            return VendorScreen(store: store, args: args);
          default:
            return NotFound();
        }
      },
    );
  }
}
