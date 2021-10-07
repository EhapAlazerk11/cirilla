// import 'dart:async';

import 'package:cirilla/models/address/country.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'country_store.g.dart';

class AddressStore = _AddressStore with _$AddressStore;

abstract class _AddressStore with Store {
  final RequestHelper _requestHelper;

  _AddressStore(
    this._requestHelper,
  ) {
    _reaction();
  }
  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<CountryData>> emptyCountriesResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<CountryData>?> fetchCountriesFuture = emptyCountriesResponse;

  @observable
  Customer? _customer;

  @observable
  bool _loading = false;

  @observable
  String? _dateExpiry;

  @observable
  ObservableList<CountryData> _country = ObservableList<CountryData>.of([]);

  @computed
  Customer? get customer => _customer;

  @computed
  ObservableList<CountryData> get country => _country;

  @computed
  bool get loading => _loading;

  @action
  Future<void> getCountry({Map<String, dynamic>? queryParameters}) async {
    final futureCountry = _requestHelper.getCountry(queryParameters: queryParameters);
    fetchCountriesFuture = ObservableFuture(futureCountry);
    return futureCountry.then((country) {
      _country = ObservableList<CountryData>.of(country);
    }).catchError((error) {});
  }

  @action
  Future<void> getAddress({userId: String}) async {
    try {
      Customer data = await _requestHelper.getCustomer(userId: userId);

      _customer = data;
    } on DioError catch (e) {
      throw e;
    }
  }

  @action
  Future<void> getAddressCountry({userId: String}) async {
    try {
      _loading = true;
      Customer data = await _requestHelper.getCustomer(userId: userId);

      if (_dateExpiry == null || !compareSpaceDate(date: _dateExpiry!, space: 0)) {
        List<CountryData> dataCountry = await _requestHelper.getCountry(queryParameters: {});

        _country = ObservableList<CountryData>.of(dataCountry);
        _dateExpiry = DateTime.now().add(Duration(days: 15)).toString();
      }

      _customer = data;
      _loading = false;
    } on DioError catch (e) {
      _loading = false;
      throw e;
    }
  }

  @action
  Future<void> postBilling({userId: String, Map<String, dynamic>? data}) async {
    try {
      Customer customer = await _requestHelper.postCustomer(
        userId: userId,
        data: {"billing": data},
      );

      _customer = customer;
    } on DioError catch (e) {
      throw e;
    }
  }

  @action
  Future<void> postShipping({userId: String, Map<String, dynamic>? data}) async {
    try {
      Customer customer = await _requestHelper.postCustomer(
        userId: userId,
        data: {"shipping": data},
      );

      _customer = customer;
    } on DioError catch (e) {
      throw e;
    }
  }

  // disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;
  void _reaction() {
    _disposers = [];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
