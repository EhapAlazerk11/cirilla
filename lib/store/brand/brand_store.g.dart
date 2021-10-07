// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BrandStore on _BrandStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading, name: '_BrandStore.loading')).value;
  Computed<int>? _$nextPageComputed;

  @override
  int get nextPage => (_$nextPageComputed ??= Computed<int>(() => super.nextPage, name: '_BrandStore.nextPage')).value;
  Computed<ObservableList<Brand>>? _$brandsComputed;

  @override
  ObservableList<Brand> get brands =>
      (_$brandsComputed ??= Computed<ObservableList<Brand>>(() => super.brands, name: '_BrandStore.brands')).value;
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore, name: '_BrandStore.canLoadMore')).value;
  Computed<int>? _$perPageComputed;

  @override
  int get perPage => (_$perPageComputed ??= Computed<int>(() => super.perPage, name: '_BrandStore.perPage')).value;

  final _$fetchBrandsFutureAtom = Atom(name: '_BrandStore.fetchBrandsFuture');

  @override
  ObservableFuture<List<Brand>?> get fetchBrandsFuture {
    _$fetchBrandsFutureAtom.reportRead();
    return super.fetchBrandsFuture;
  }

  @override
  set fetchBrandsFuture(ObservableFuture<List<Brand>?> value) {
    _$fetchBrandsFutureAtom.reportWrite(value, super.fetchBrandsFuture, () {
      super.fetchBrandsFuture = value;
    });
  }

  final _$_brandsAtom = Atom(name: '_BrandStore._brands');

  @override
  ObservableList<Brand> get _brands {
    _$_brandsAtom.reportRead();
    return super._brands;
  }

  @override
  set _brands(ObservableList<Brand> value) {
    _$_brandsAtom.reportWrite(value, super._brands, () {
      super._brands = value;
    });
  }

  final _$_perPageAtom = Atom(name: '_BrandStore._perPage');

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

  final _$_nextPageAtom = Atom(name: '_BrandStore._nextPage');

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

  final _$_canLoadMoreAtom = Atom(name: '_BrandStore._canLoadMore');

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

  final _$getBrandsAsyncAction = AsyncAction('_BrandStore.getBrands');

  @override
  Future<List<Brand>> getBrands({CancelToken? token}) {
    return _$getBrandsAsyncAction.run(() => super.getBrands(token: token));
  }

  final _$getBrandAsyncAction = AsyncAction('_BrandStore.getBrand');

  @override
  Future<Brand> getBrand({required int id, CancelToken? token}) {
    return _$getBrandAsyncAction.run(() => super.getBrand(id: id, token: token));
  }

  final _$_BrandStoreActionController = ActionController(name: '_BrandStore');

  @override
  Future<void> refresh() {
    final _$actionInfo = _$_BrandStoreActionController.startAction(name: '_BrandStore.refresh');
    try {
      return super.refresh();
    } finally {
      _$_BrandStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchBrandsFuture: ${fetchBrandsFuture},
loading: ${loading},
nextPage: ${nextPage},
brands: ${brands},
canLoadMore: ${canLoadMore},
perPage: ${perPage}
    ''';
  }
}
