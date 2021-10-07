import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'vendor_store.g.dart';

class VendorStore = _VendorStore with _$VendorStore;

abstract class _VendorStore with Store {
  final String? key;

  // Request helper instance
  RequestHelper _requestHelper;

  // store for handling errors
  // final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _VendorStore(
    this._requestHelper, {
    int? perPage,
    String? lang,
    String? search,
    Map<String, dynamic>? sort,
    ProductCategory? category,
    this.key,
  }) {
    if (perPage != null) _perPage = perPage;
    if (lang != null) _lang = lang;
    if (search != null) _search = lang;
    if (sort != null) _sort = sort;
    if (category != null) _category = category;
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<Vendor>> emptyVendorsResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<Vendor>?> fetchVendorsFuture = emptyVendorsResponse;

  @observable
  ObservableList<Vendor> _vendors = ObservableList<Vendor>.of([]);

  @observable
  bool success = false;

  @observable
  int _nextPage = 1;

  @observable
  int _perPage = 10;

  @observable
  String _lang = '';

  @observable
  String? _search = '';

  @observable
  Map<String, dynamic> _sort = {
    'key': 'vendor_list_date_desc',
    'query': {
      'orderby': 'date',
      'order': 'desc',
    }
  };
  @observable
  RangeValues _rangeDistance = RangeValues(0.0, 50.0);

  @observable
  ProductCategory? _category;

  @observable
  bool _loading = true;

  @observable
  bool _canLoadMore = true;

  // computed:-------------------------------------------------------------------
  @computed
  bool get loading => fetchVendorsFuture.status == FutureStatus.pending;

  @computed
  ObservableList<Vendor> get vendors => _vendors;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  int get perPage => _perPage;

  @computed
  String get lang => _lang;

  @computed
  String? get search => _search;

  @computed
  ProductCategory? get category => _category;

  @computed
  Map get sort => _sort;

  @computed
  RangeValues get rangDistance => _rangeDistance;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getVendors() async {
    final future = _requestHelper.getVendors(queryParameters: {
      "per_page": _perPage,
      'page': _nextPage,
      'lang': _lang,
      'search': _search,
      "order": _sort['query']['order'],
      "orderby": _sort['query']['orderby'],
      "category": category != null ? category!.id : '',
    });
    fetchVendorsFuture = ObservableFuture(future);
    return future.then((data) {
      // Replace state in the first time or refresh
      if (_nextPage <= 1) {
        _vendors = ObservableList<Vendor>.of(data!);
      } else {
        // Add posts when load more page
        _vendors.addAll(ObservableList<Vendor>.of(data!));
      }

      // Check if can load more item
      if (data.length >= _perPage) {
        _nextPage++;
      } else {
        _canLoadMore = false;
      }
    }).catchError((error) {
      print(error);
      // errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future<void> refresh() {
    _canLoadMore = true;
    _nextPage = 1;
    _vendors.clear();
    return getVendors();
  }

  @action
  void onChanged({
    Map? sort,
    String? search,
    int? perPage,
    RangeValues? rangeDistance,
    ProductCategory? category,
    bool enableEmptyCategory = false,
  }) {
    if (sort != null) _sort = sort as Map<String, dynamic>;
    if (search != null) _search = search;
    if (perPage != null) _perPage = perPage;
    if (rangeDistance != null) _rangeDistance = rangeDistance;
    if (enableEmptyCategory || (!enableEmptyCategory && category != null)) _category = category;
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _sort, (dynamic key) => refresh()),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
