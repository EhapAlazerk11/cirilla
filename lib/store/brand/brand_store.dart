import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'brand_store.g.dart';

class BrandStore = _BrandStore with _$BrandStore;

abstract class _BrandStore with Store {
  final String? key;

  // Request helper instance
  RequestHelper _requestHelper;

  // constructor:---------------------------------------------------------------
  _BrandStore(
    this._requestHelper, {
    this.key,
    int? perPage,
  }) {
    if (perPage != null) _perPage = perPage;

    _reaction();
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<Brand>> emptyBrandResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<Brand>?> fetchBrandsFuture = emptyBrandResponse;

  @observable
  ObservableList<Brand> _brands = ObservableList<Brand>.of([]);

  @observable
  int _perPage = 10;

  @observable
  int _nextPage = 1;

  @observable
  bool _canLoadMore = true;

  // computed:-------------------------------------------------------------------

  @computed
  bool get loading => fetchBrandsFuture.status == FutureStatus.pending;

  @computed
  int get nextPage => _nextPage;

  @computed
  ObservableList<Brand> get brands => _brands;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  int get perPage => _perPage;

  // actions:-------------------------------------------------------------------
  @action
  Future<List<Brand>> getBrands({CancelToken? token}) async {
    final qs = {
      "page": _nextPage,
      "per_page": _perPage,
    };

    final future = _requestHelper.getBrands(queryParameters: qs, cancelToken: token);

    fetchBrandsFuture = ObservableFuture(future);

    return future.then((data) {
      // Replace state in the first time or refresh
      if (_nextPage <= 1) {
        _brands = ObservableList<Brand>.of(data!);
      } else {
        // Add posts when load more page
        _brands.addAll(ObservableList<Brand>.of(data!));
      }

      // Check if can load more item
      if (data.length >= _perPage) {
        _nextPage++;
      } else {
        _canLoadMore = false;
      }
      return _brands;
    }).catchError((error) {
      print(error);
    });
  }

  @action
  Future<Brand> getBrand({required int id, CancelToken? token}) async {
    final future = _requestHelper.getBrand(id: id, cancelToken: token);

    return future.then((data) {
      return data;
    }).catchError((error) {
      print(error);
    });
  }

  @action
  Future<void> refresh() {
    _canLoadMore = true;
    _nextPage = 1;
    _brands.clear();
    return getBrands();
  }

  // disposers:-----------------------------------------------------------------
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
