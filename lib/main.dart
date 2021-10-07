import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'constants/strings.dart';
import 'constants/languages.dart';
import 'mixins/mixins.dart';
import 'routes.dart';
import 'service/service.dart';
import 'store/store.dart';
import 'utils/utils.dart';

late AppService appServiceInject;
String? language;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializePushNotificationService();
  SharedPreferences sharedPref = await getSharedPref();

  appServiceInject = await AppServiceInject.create(
    PreferenceModule(sharedPref: sharedPref),
    NetworkModule(),
  );

  language = await appServiceInject.providerPersistHelper.getLanguage();

  runApp(appServiceInject.getApp);
}

class MyApp extends StatelessWidget with Utility, ThemeMixin {
  final GlobalKey<NavigatorState> _rootNav = GlobalKey<NavigatorState>();

  final SettingStore _settingStore = SettingStore(
    appServiceInject.providerPersistHelper,
    appServiceInject.providerRequestHelper,
  );

  // Instance product category store
  final ProductCategoryStore _productCategoryStore = ProductCategoryStore(
    appServiceInject.providerRequestHelper,
    parent: 0,
    language: language,
  )..getCategories();

  // Instance auth store
  final AuthStore _authStore = AuthStore(
    appServiceInject.providerPersistHelper,
    appServiceInject.providerRequestHelper,
  );

  // Instance app store
  final AppStore _appStore = AppStore();

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<RequestHelper>(create: (_) => appServiceInject.providerRequestHelper),
          Provider<AppStore>(create: (_) => _appStore),
          Provider<AuthStore>(create: (_) => _authStore),
          ProxyProvider<AuthStore, CartStore>(
            update: (_, _auth, __) => CartStore(
              appServiceInject.providerPersistHelper,
              appServiceInject.providerRequestHelper,
              _auth,
            ),
          ),
          Provider<SettingStore>(create: (_) => _settingStore),
          Provider<ProductCategoryStore>(create: (_) => _productCategoryStore),
          Provider<MessageStore>(create: (_) => MessageStore(appServiceInject.providerPersistHelper)),
        ],
        child: Consumer<SettingStore>(
          builder: (_, store, __) => Observer(
            builder: (_) => MaterialApp(
              navigatorKey: _rootNav,
              navigatorObservers: <NavigatorObserver>[observer],
              debugShowCheckedModeBanner: false,
              title: Strings.appName,
              initialRoute: '/',
              theme: buildTheme(store),
              routes: Routes.routes(store),
              onGenerateRoute: (settings) => Routes.onGenerateRoute(settings, store),
              locale: LANGUAGES[store.locale] ?? Locale.fromSubtags(languageCode: store.locale),
              supportedLocales: store.supportedLanguages
                  .map((language) => LANGUAGES[language.locale!] ?? Locale.fromSubtags(languageCode: language.locale!))
                  .toList(),
              localizationsDelegates: [
                // A class which loads the translations from JSON files
                AppLocalizations.delegate,
                // Built-in localization of basic text for Material widgets
                GlobalMaterialLocalizations.delegate,
                // Built-in localization for text direction LTR/RTL
                GlobalWidgetsLocalizations.delegate,
              ],
              // Returns a locale which will be used by the app
              localeResolutionCallback: (locale, supportedLocales) =>
                  // Check if the current device locale is supported
                  supportedLocales.firstWhere((supportedLocale) => supportedLocale.languageCode == locale?.languageCode,
                      orElse: () => supportedLocales.first),
            ),
          ),
        ),
      );
}
