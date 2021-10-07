import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'address_billing.dart';

class AddressShippingScreen extends StatefulWidget {
  @override
  _AddressShippingScreenState createState() => _AddressShippingScreenState();
}

class _AddressShippingScreenState extends State<AddressShippingScreen> with SnackMixin, LoadingMixin, AppBarMixin {
  late AppStore _appStore;
  late AuthStore _authStore;
  late SettingStore _settingStore;
  CountryStore? _countryStore;
  AddressFieldStore? _addressFieldStore;
  late CustomerStore _customerStore;
  bool? _loading;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appStore = Provider.of<AppStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    _settingStore = Provider.of<SettingStore>(context);

    _customerStore = CustomerStore(_settingStore.requestHelper)..getCustomer(userId: _authStore.user!.id);
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

  postAddress(Map data) async {
    try {
      setState(() {
        _loading = true;
      });
      TranslateType translate = AppLocalizations.of(context)!.translate;
      await _customerStore.updateCustomer(
        userId: _authStore.user!.id,
        data: {'shipping': data},
      );
      showSuccess(context, translate('address_shipping_success'));
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

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(builder: (_) {
      bool loadingAddressField = _addressFieldStore!.loading;
      Map<String, dynamic> addressFields = _addressFieldStore!.addressFields;
      bool loadingCustomer = _customerStore.loading;
      Customer? customer = _customerStore.customer;
      bool loading = loadingAddressField || loadingCustomer;

      return Scaffold(
        appBar: baseStyleAppBar(context, title: translate('address_shipping')!),
        body: Stack(
          children: [
            if (loading && customer == null)
              Container()
            else
              AddressChild(
                address: customer!.shipping ?? {},
                addressFields: addressFields,
                countries: _countryStore?.country ?? [],
                onSave: postAddress,
                loading: _loading,
              ),
            if (loading && customer == null) buildLoading(context, isLoading: loading),
          ],
        ),
      );
    });
  }
}
