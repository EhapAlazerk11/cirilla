import 'package:cirilla/constants/app.dart' as appConfigs;
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'setting_store.g.dart';

class SettingStore = _SettingStore with _$SettingStore;

List<Language> defaultLanguageSupport = appConfigs.languageSupport
    .map(
      (code) => Language(
        code: code,
        locale: code,
        language: getLanguages[code.split('-')[0]]['name'],
      ),
    )
    .toList();

abstract class _SettingStore with Store {
  final PersistHelper _persistHelper;
  final RequestHelper _requestHelper;

  _SettingStore(this._persistHelper, this._requestHelper) {
    init();
  }

  void init() async {
    await restore();
    getSetting();
  }

  Future<void> restore() async {
    _darkMode = await _persistHelper.getDarkMode();
    _locale = await _persistHelper.getLanguage();

    String? currency = await _persistHelper.getCurrency();
    if (currency != null && currency != '') {
      _currency = currency;
    }

    _enableGetStart = await _persistHelper.getEnableGetStart();
  }

  // Store variables: --------------------------------------------------------------------------------------------------
  @observable
  ObservableList<Language> _supportedLanguages = ObservableList<Language>.of(defaultLanguageSupport);

  // Default language
  @observable
  String _lang = appConfigs.defaultLanguage;

  @observable
  String _locale = appConfigs.defaultLanguage;

  @observable
  bool _darkMode = false;

  @observable
  bool _loading = true;

  @observable
  ObservableList<String?> _tabs = ObservableList<String?>.of([Strings.tabActive]);

  @observable
  DataScreen? _data;

  // Currency
  @observable
  ObservableMap<String, dynamic> _currencies = ObservableMap<String, dynamic>.of({});

  // Default currency
  @observable
  String? _defaultCurrency;

  @observable
  String? _currency;

  @observable
  String? _checkoutUrl = '';

  @observable
  bool _enableGetStart = true;

  // Computed: ---------------------------------------------------------------------------------------------------------
  @computed
  bool get darkMode => _darkMode;

  @computed
  String get themeModeKey => _darkMode ? 'dark' : 'value';

  @computed
  String get languageKey => _lang == _locale ? 'text' : _locale;

  @computed
  String get imageKey => _lang == _locale ? 'src' : _locale;

  @computed
  String get locale => _locale;

  @computed
  ObservableList<Language> get supportedLanguages => _supportedLanguages;

  @computed
  bool get loading => _loading;

  @computed
  PersistHelper get persistHelper => _persistHelper;

  @computed
  RequestHelper get requestHelper => _requestHelper;

  @computed
  String? get defaultCurrency => _defaultCurrency;

  @computed
  String? get currency => _currency;

  @computed
  bool get isCurrencyChanged => _currency != _defaultCurrency;

  @computed
  ObservableMap<String, dynamic> get currencies => _currencies;

  @computed
  String? get checkoutUrl => _checkoutUrl;

  // Get data screen
  @computed
  DataScreen? get data => _data;

  @computed
  ObservableList<String?> get tabs => _tabs;

  @computed
  bool get enableGetStart => _enableGetStart;

  // Actions: ----------------------------------------------------------------------------------------------------------
  @action
  void setTab(String? tab) {
    if (_tabs.isEmpty || _tabs[_tabs.length - 1] != tab) {
      _tabs.add(tab);
    }
  }

  @action
  removeTab() {
    if (_tabs.length > 1) return _tabs.removeLast();
    return true;
  }

  @action
  Future<void> changeLanguage(String value) async {
    _locale = value;
    await _persistHelper.saveLanguage(value);
  }

  @action
  Future<void> changeCurrency(String value) async {
    _currency = value;
    await _persistHelper.saveCurrency(value);
  }

  @action
  Future<void> setDarkMode({required bool value}) async {
    await _persistHelper.saveDarkMode(value);
    _darkMode = value;
  }

  @action
  Future<void> closeGetStart() async {
    await _persistHelper.saveEnableGetStart(false);
    _enableGetStart = false;
  }

  @action
  Future<void> getSetting() async {
    try {
      Map<String, dynamic> json = await _requestHelper.getSettings();
      setSetting(json);
    } on DioError catch (e) {
      print(e);
    }
  }

  @action
  void setSetting(json) {
    // Screens setting
    if (json['data'] != null && json['data'].length > 0) _data = DataScreen.fromJson(json['data']);

    // Languages setting
    _lang = json['language'];
    if (json['languages'] != null && json['languages'].length > 0) {
      List<Language> languages = json['languages']
          .keys
          .map((key) {
            final language = json['languages'][key];
            String code = language['code'] ?? language['language_code'];
            return Language(code: code.toUpperCase(), locale: code, language: language['native_name']);
          })
          .toList()
          .cast<Language>();
      _supportedLanguages = ObservableList<Language>.of(languages);
    }

    // Currency setting
    _defaultCurrency = json['currency'];
    _currency ??= json['currency'];
    if (json['currencies'] != null) _currencies = ObservableMap<String, dynamic>.of(json['currencies']);

    // Checkout url
    if (json['checkout_url'] != null) _checkoutUrl = json['checkout_url'];

    _loading = false;
  }
}
