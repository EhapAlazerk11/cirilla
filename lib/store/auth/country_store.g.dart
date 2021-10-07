// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AddressStore on _AddressStore, Store {
  Computed<Customer?>? _$customerComputed;

  @override
  Customer? get customer =>
      (_$customerComputed ??= Computed<Customer?>(() => super.customer, name: '_AddressStore.customer')).value;
  Computed<ObservableList<CountryData>>? _$countryComputed;

  @override
  ObservableList<CountryData> get country =>
      (_$countryComputed ??= Computed<ObservableList<CountryData>>(() => super.country, name: '_AddressStore.country'))
          .value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading, name: '_AddressStore.loading')).value;

  final _$fetchCountriesFutureAtom = Atom(name: '_AddressStore.fetchCountriesFuture');

  @override
  ObservableFuture<List<CountryData>?> get fetchCountriesFuture {
    _$fetchCountriesFutureAtom.reportRead();
    return super.fetchCountriesFuture;
  }

  @override
  set fetchCountriesFuture(ObservableFuture<List<CountryData>?> value) {
    _$fetchCountriesFutureAtom.reportWrite(value, super.fetchCountriesFuture, () {
      super.fetchCountriesFuture = value;
    });
  }

  final _$_customerAtom = Atom(name: '_AddressStore._customer');

  @override
  Customer? get _customer {
    _$_customerAtom.reportRead();
    return super._customer;
  }

  @override
  set _customer(Customer? value) {
    _$_customerAtom.reportWrite(value, super._customer, () {
      super._customer = value;
    });
  }

  final _$_loadingAtom = Atom(name: '_AddressStore._loading');

  @override
  bool get _loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  final _$_dateExpiryAtom = Atom(name: '_AddressStore._dateExpiry');

  @override
  String? get _dateExpiry {
    _$_dateExpiryAtom.reportRead();
    return super._dateExpiry;
  }

  @override
  set _dateExpiry(String? value) {
    _$_dateExpiryAtom.reportWrite(value, super._dateExpiry, () {
      super._dateExpiry = value;
    });
  }

  final _$_countryAtom = Atom(name: '_AddressStore._country');

  @override
  ObservableList<CountryData> get _country {
    _$_countryAtom.reportRead();
    return super._country;
  }

  @override
  set _country(ObservableList<CountryData> value) {
    _$_countryAtom.reportWrite(value, super._country, () {
      super._country = value;
    });
  }

  final _$getCountryAsyncAction = AsyncAction('_AddressStore.getCountry');

  @override
  Future<void> getCountry({Map<String, dynamic>? queryParameters}) {
    return _$getCountryAsyncAction.run(() => super.getCountry(queryParameters: queryParameters));
  }

  final _$getAddressAsyncAction = AsyncAction('_AddressStore.getAddress');

  @override
  Future<void> getAddress({dynamic userId = String}) {
    return _$getAddressAsyncAction.run(() => super.getAddress(userId: userId));
  }

  final _$getAddressCountryAsyncAction = AsyncAction('_AddressStore.getAddressCountry');

  @override
  Future<void> getAddressCountry({dynamic userId = String}) {
    return _$getAddressCountryAsyncAction.run(() => super.getAddressCountry(userId: userId));
  }

  final _$postBillingAsyncAction = AsyncAction('_AddressStore.postBilling');

  @override
  Future<void> postBilling({dynamic userId = String, Map<String, dynamic>? data}) {
    return _$postBillingAsyncAction.run(() => super.postBilling(userId: userId, data: data));
  }

  final _$postShippingAsyncAction = AsyncAction('_AddressStore.postShipping');

  @override
  Future<void> postShipping({dynamic userId = String, Map<String, dynamic>? data}) {
    return _$postShippingAsyncAction.run(() => super.postShipping(userId: userId, data: data));
  }

  @override
  String toString() {
    return '''
fetchCountriesFuture: ${fetchCountriesFuture},
customer: ${customer},
country: ${country},
loading: ${loading}
    ''';
  }
}
