import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/app_bar_mixin.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/screens/profile/notification_list.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/widgets/cirilla_badge.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'widgets/profile_content_login.dart';
import 'widgets/profile_content_logout.dart';
import 'widgets/profile_footer.dart';

const enableLogin = false;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with Utility, AppBarMixin {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  late AppStore _appStore;
  late SettingStore _settingStore;
  late AuthStore _authStore;
  late MessageStore _messageStore;
  CountryStore? _countryStore;
  AddressFieldStore? _addressFieldStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appStore = Provider.of<AppStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    _messageStore = Provider.of<MessageStore>(context)..getMessages();

    String keyCountry = 'country_list';
    String keyAddressField = 'address_fields_${_settingStore.locale}';
    if (_appStore.getStoreByKey(keyCountry) == null) {
      CountryStore store = CountryStore(_settingStore.requestHelper, key: keyCountry)..getCountry();
      _appStore.addStore(store);
      _countryStore ??= store;
    } else {
      _countryStore = _appStore.getStoreByKey(keyCountry);
    }
    if (_appStore.getStoreByKey(keyAddressField) == null) {
      AddressFieldStore store = AddressFieldStore(_settingStore.requestHelper, key: keyAddressField)
        ..getAddressField(queryParameters: {
          'lang': _settingStore.locale,
        });
      _appStore.addStore(store);
      _addressFieldStore ??= store;
    } else {
      _addressFieldStore = _appStore.getStoreByKey(keyAddressField);
    }
  }

  void logout() async {
    bool isLogout = await _authStore.logout();
    print(isLogout);
  }

  void showMessage({String? message}) {
    scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Colors.green,
        ),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: 40,
        child: Center(child: Text(message ?? '')),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    String title = enableLogin ? 'Account' : 'Profile';
    String language = _settingStore.locale;

    WidgetConfig widgetConfig = _settingStore.data!.screens!['profile']!.widgets!['profilePage']!;
    Map<String, dynamic>? fields = widgetConfig.fields;

    bool? enablePhone = get(fields, ['enablePhone'], true);
    String? textCopyRight = ConvertData.stringFromConfigs(get(fields, ['textCopyRight'], '© Cirrilla 2020'), language);
    String? phone = ConvertData.stringFromConfigs(get(fields, ['phone'], '0123456789'), language);
    List? socials = get(fields, ['itemSocial'], []);

    // Padding
    Map<String, dynamic>? _padding = get(widgetConfig.styles, ['padding']);
    EdgeInsetsDirectional padding = _padding != null ? ConvertData.space(_padding, 'padding') : defaultScreenPadding;

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: baseStyleAppBar(
          context,
          title: title,
          automaticallyImplyLeading: false,
          actions: [
            buildIconNotification(),
          ],
        ),
        body: SingleChildScrollView(
          padding: padding,
          child: SizedBox(
              width: double.infinity,
              child: Observer(
                builder: (_) => _authStore.isLogin
                    ? ProfileContentLogin(
                        logout: logout,
                        user: _authStore.user,
                        enablePhone: enablePhone,
                        phone: phone,
                        footer: ProfileFooter(
                          copyright: textCopyRight,
                          socials: socials,
                          lang: language,
                        ),
                      )
                    : ProfileContentLogout(
                        showMessage: showMessage,
                        enablePhone: enablePhone,
                        phone: phone,
                        footer: ProfileFooter(
                          copyright: textCopyRight,
                          socials: socials,
                          lang: language,
                        ),
                      ),
              )),
        ),
      ),
    );
  }

  Widget buildIconNotification() {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          IconButton(
            icon: Icon(
              FeatherIcons.bell,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pushNamed(NotificationList.routeName),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(top: 7, start: 24),
            padding: EdgeInsetsDirectional.only(end: 20),
            child: Observer(
              builder: (_) => InkWell(
                onTap: () => Navigator.of(context).pushNamed(NotificationList.routeName),
                child: CirillaBadge(
                  size: 18,
                  label: "${_messageStore.countUnRead}",
                  type: CirillaBadgeType.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
