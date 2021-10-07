// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$VendorStore on _VendorStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading, name: '_VendorStore.loading')).value;
  Computed<ObservableList<Vendor>>? _$vendorsComputed;

  @override
  ObservableList<Vendor> get vendors =>
      (_$vendorsComputed ??= Computed<ObservableList<Vendor>>(() => super.vendors, name: '_VendorStore.vendors')).value;
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore, name: '_VendorStore.canLoadMore')).value;
  Computed<int>? _$perPageComputed;

  @override
  int get perPage => (_$perPageComputed ??= Computed<int>(() => super.perPage, name: '_VendorStore.perPage')).value;
  Computed<String>? _$langComputed;

  @override
  String get lang => (_$langComputed ??= Computed<String>(() => super.lang, name: '_VendorStore.lang')).value;
  Computed<String?>? _$searchComputed;

  @override
  String? get search => (_$searchComputed ??= Computed<String?>(() => super.search, name: '_VendorStore.search')).value;
  Computed<ProductCategory?>? _$categoryComputed;

  @override
  ProductCategory? get category =>
      (_$categoryComputed ??= Computed<ProductCategory?>(() => super.category, name: '_VendorStore.category')).value;
  Computed<Map<dynamic, dynamic>>? _$sortComputed;

  @override
  Map<dynamic, dynamic> get sort =>
      (_$sortComputed ??= Computed<Map<dynamic, dynamic>>(() => super.sort, name: '_VendorStore.sort')).value;
  Computed<RangeValues>? _$rangDistanceComputed;

  @override
  RangeValues get rangDistance =>
      (_$rangDistanceComputed ??= Computed<RangeValues>(() => super.rangDistance, name: '_VendorStore.rangDistance'))
          .value;

  final _$fetchVendorsFutureAtom = Atom(name: '_VendorStore.fetchVendorsFuture');

  @override
  ObservableFuture<List<Vendor>?> get fetchVendorsFuture {
    _$fetchVendorsFutureAtom.reportRead();
    return super.fetchVendorsFuture;
  }

  @override
  set fetchVendorsFuture(ObservableFuture<List<Vendor>?> value) {
    _$fetchVendorsFutureAtom.reportWrite(value, super.fetchVendorsFuture, () {
      super.fetchVendorsFuture = value;
    });
  }

  final _$_vendorsAtom = Atom(name: '_VendorStore._vendors');

  @override
  ObservableList<Vendor> get _vendors {
    _$_vendorsAtom.reportRead();
    return super._vendors;
  }

  @override
  set _vendors(ObservableList<Vendor> value) {
    _$_vendorsAtom.reportWrite(value, super._vendors, () {
      super._vendors = value;
    });
  }

  final _$successAtom = Atom(name: '_VendorStore.success');

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  final _$_nextPageAtom = Atom(name: '_VendorStore._nextPage');

  @override
  int get _nextPage {
    _$_nextPageAtom.reportRead();
    return super._nextPage;
  }

  @override
  set _nextPage(int value) {
    _$_nextPageAtom.reportWrite(value, super._nextPage, () {
      super._nextPage = value;
    });
  }

  final _$_perPageAtom = Atom(name: '_VendorStore._perPage');

  @override
  int get _perPage {
    _$_perPageAtom.reportRead();
    return super._perPage;
  }

  @override
  set _perPage(int value) {
    _$_perPageAtom.reportWrite(value, super._perPage, () {
      super._perPage = value;
    });
  }

  final _$_langAtom = Atom(name: '_VendorStore._lang');

  @override
  String get _lang {
    _$_langAtom.reportRead();
    return super._lang;
  }

  @override
  set _lang(String value) {
    _$_langAtom.reportWrite(value, super._lang, () {
      super._lang = value;
    });
  }

  final _$_searchAtom = Atom(name: '_VendorStore._search');

  @override
  String? get _search {
    _$_searchAtom.reportRead();
    return super._search;
  }

  @override
  set _search(String? value) {
    _$_searchAtom.reportWrite(value, super._search, () {
      super._search = value;
    });
  }

  final _$_sortAtom = Atom(name: '_VendorStore._sort');

  @override
  Map<String, dynamic> get _sort {
    _$_sortAtom.reportRead();
    return super._sort;
  }

  @override
  set _sort(Map<String, dynamic> value) {
    _$_sortAtom.reportWrite(value, super._sort, () {
      super._sort = value;
    });
  }

  final _$_rangeDistanceAtom = Atom(name: '_VendorStore._rangeDistance');

  @override
  RangeValues get _rangeDistance {
    _$_rangeDistanceAtom.reportRead();
    return super._rangeDistance;
  }

  @override
  set _rangeDistance(RangeValues value) {
    _$_rangeDistanceAtom.reportWrite(value, super._rangeDistance, () {
      super._rangeDistance = value;
    });
  }

  final _$_categoryAtom = Atom(name: '_VendorStore._category');

  @override
  ProductCategory? get _category {
    _$_categoryAtom.reportRead();
    return super._category;
  }

  @override
  set _category(ProductCategory? value) {
    _$_categoryAtom.reportWrite(value, super._category, () {
      super._category = value;
    });
  }

  final _$_loadingAtom = Atom(name: '_VendorStore._loading');

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

  final _$_canLoadMoreAtom = Atom(name: '_VendorStore._canLoadMore');

  @override
  bool get _canLoadMore {
    _$_canLoadMoreAtom.reportRead();
    return super._canLoadMore;
  }

  @override
  set _canLoadMore(bool value) {
    _$_canLoadMoreAtom.reportWrite(value, super._canLoadMore, () {
      super._canLoadMore = value;
    });
  }

  final _$getVendorsAsyncAction = AsyncAction('_VendorStore.getVendors');

  @override
  Future<void> getVendors() {
    return _$getVendorsAsyncAction.run(() => super.getVendors());
  }

  final _$_VendorStoreActionController = ActionController(name: '_VendorStore');

  @override
  Future<void> refresh() {
    final _$actionInfo = _$_VendorStoreActionController.startAction(name: '_VendorStore.refresh');
    try {
      return super.refresh();
    } finally {
      _$_VendorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChanged(
      {Map<dynamic, dynamic>? sort,
      String? search,
      int? perPage,
      RangeValues? rangeDistance,
      ProductCategory? category,
      bool enableEmptyCategory = false}) {
    final _$actionInfo = _$_VendorStoreActionController.startAction(name: '_VendorStore.onChanged');
    try {
      return super.onChanged(
          sort: sort,
          search: search,
          perPage: perPage,
          rangeDistance: rangeDistance,
          category: category,
          enableEmptyCategory: enableEmptyCategory);
    } finally {
      _$_VendorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchVendorsFuture: ${fetchVendorsFuture},
success: ${success},
loading: ${loading},
vendors: ${vendors},
canLoadMore: ${canLoadMore},
perPage: ${perPage},
lang: ${lang},
search: ${search},
category: ${category},
sort: ${sort},
rangDistance: ${rangDistance}
    ''';
  }
}
