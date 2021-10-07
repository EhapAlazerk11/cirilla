import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/profile/address_billing.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/store/store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';

class CartChangeAddress extends StatefulWidget {
  final int? index;
  CartChangeAddress({Key? key, this.index});

  _CartChangeAddressState createState() => _CartChangeAddressState();
}

class _CartChangeAddressState extends State<CartChangeAddress> with SnackMixin, LoadingMixin, AppBarMixin {
  late AppStore _appStore;
  late SettingStore _settingStore;
  CountryStore? _countryStore;
  AddressFieldStore? _addressFieldStore;
  CartStore? _cartStore;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appStore = Provider.of<AppStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
    _cartStore = Provider.of<CartStore>(context);

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

  postAddressCart(Map data) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    try {
      await _cartStore!.updateCustomerCart(data: {'shipping_address': data, 'billing_address': data});
      showSuccess(context, translate('address_shipping_success'));
      Navigator.pop(context);
    } catch (e) {
      showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        return Observer(builder: (_) {
          bool loadingAddressField = _addressFieldStore!.loading;

          Map<String, dynamic> addressFields = _addressFieldStore!.addressFields;

          bool loading = loadingAddressField;

          Map? destination = _cartStore?.cartData?.shippingRate?.elementAt(widget.index!).destination;

          TranslateType translate = AppLocalizations.of(context)!.translate;

          return Container(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight - 200),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  if (loading)
                    Container()
                  else
                    AddressChild(
                      address: destination as Map<String, dynamic>?,
                      addressFields: addressFields,
                      countries: _countryStore?.country ?? [],
                      onSave: postAddressCart,
                      hideFields: ['first_name', 'last_name', 'address_1', 'address_2', 'company'],
                      titleModal: Text(
                        translate('address_change')!,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      note: false,
                      borderFields: true,
                    ),
                  if (loading) buildLoading(context, isLoading: loading),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
