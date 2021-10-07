import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/country.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'widgets/address_field_form.dart';

class AddressBookScreen extends StatefulWidget {
  @override
  _AddressBookScreenState createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> with SnackMixin, LoadingMixin, AppBarMixin {
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
        data: {'billing': data},
      );
      showSuccess(context, translate('address_billing_success'));
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

  Map<String, dynamic> convertFields(Map<String, dynamic> data, TranslateType translate) {
    Map<String, dynamic> result = {...data};
    dynamic defaultValue = result['default'];
    dynamic dataDefault = defaultValue is Map<String, dynamic> ? {...defaultValue} : {};
    if (dataDefault is Map) {
      Map<String, dynamic> valueAdd = {
        'email': <String, dynamic>{
          "type": "email",
          "label": translate('address_email'),
          "required": true,
          "class": ["form-row-wide", "address-field"],
          "validate": ["email"],
          "autocomplete": "email",
          "priority": 999,
        },
        'phone': {
          "type": "phone",
          "label": translate('address_phone'),
          "required": true,
          "class": ["form-row-wide", "address-field"],
          "validate": ["phone"],
          "autocomplete": "phone",
          "priority": 1000,
        },
      };
      dataDefault.addAll(valueAdd);
      result.addAll({
        'default': <String, dynamic>{
          ...dataDefault as Map<String, dynamic>,
        }
      });
    }
    return result;
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
        appBar: baseStyleAppBar(context, title: translate('address_billing')!),
        body: Stack(
          children: [
            if (loading && customer == null)
              Container()
            else
              AddressChild(
                address: customer!.billing ?? {},
                addressFields: convertFields(addressFields, translate),
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

class AddressChild extends StatefulWidget {
  final Map<String, dynamic>? address;
  final Map<String, dynamic>? addressFields;
  final List<CountryData> countries;
  final Function(Map<String, dynamic> address) onSave;
  final bool? loading;
  final List<String>? hideFields;
  final Widget? titleModal;
  final bool note;
  final bool? borderFields;

  AddressChild({
    Key? key,
    this.address,
    this.addressFields,
    this.hideFields,
    this.titleModal,
    this.borderFields,
    this.note = true,
    required this.countries,
    required this.onSave,
    this.loading = false,
  }) : super(key: key);

  @override
  _AddressChildState createState() => _AddressChildState();
}

class _AddressChildState extends State<AddressChild> with LoadingMixin {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> data = {};

  @override
  void didChangeDependencies() {
    if (widget.address != null) {
      setState(() {
        data = widget.address!;
      });
    }
    super.didChangeDependencies();
  }

  void changeValue(String keyValue, String value) {
    setState(() {
      if (keyValue == 'country') {
        data = {
          ...data,
          keyValue: value,
          'state': '',
        };
      } else {
        data = {
          ...data,
          keyValue: value,
        };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return ListView(
      padding: EdgeInsets.fromLTRB(layoutPadding, itemPaddingMedium, layoutPadding, itemPaddingLarge),
      children: [
        AddressFieldForm(
            formKey: _formKey,
            data: data,
            addressFields: widget.addressFields,
            countries: widget.countries,
            changeValue: changeValue,
            hideFields: widget.hideFields,
            titleModal: widget.titleModal,
            borderFields: widget.borderFields),
        if (widget.note == true) ...[
          SizedBox(height: itemPaddingMedium),
          Text(translate('address_note')!, style: theme.textTheme.caption),
          SizedBox(height: itemPaddingLarge),
        ],
        if (widget.note == false) SizedBox(height: 70),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              if (widget.loading != true && _formKey.currentState!.validate()) {
                widget.onSave(data);
              }
            },
            child: widget.loading == true
                ? entryLoading(context, color: theme.colorScheme.onPrimary)
                : Text(
                    widget.note == true ? translate('address_save')! : 'Update Address',
                  ),
          ),
        ),
      ],
    );
  }
}
