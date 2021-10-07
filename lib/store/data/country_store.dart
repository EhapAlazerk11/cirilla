import 'package:cirilla/models/address/country.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:mobx/mobx.dart';

part 'country_store.g.dart';

class CountryStore = _CountryStore with _$CountryStore;

abstract class _CountryStore with Store {
  final String? key;
  RequestHelper _requestHelper;

  _CountryStore(this._requestHelper, {this.key}) {
    _reaction();
  }
  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<CountryData>> emptyCountriesResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<CountryData>?> fetchCountriesFuture = emptyCountriesResponse;

  @observable
  ObservableList<CountryData> _country = ObservableList<CountryData>.of([]);

  @computed
  ObservableList<CountryData> get country => _country;

  @computed
  bool get loading => fetchCountriesFuture.status == FutureStatus.pending;

  @action
  Future<void> getCountry({Map<String, dynamic>? queryParameters}) async {
    final futureCountry = _requestHelper.getCountry(queryParameters: queryParameters);
    fetchCountriesFuture = ObservableFuture(futureCountry);
    return futureCountry.then((country) {
      _country = ObservableList<CountryData>.of(country);
    }).catchError((error) {});
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
