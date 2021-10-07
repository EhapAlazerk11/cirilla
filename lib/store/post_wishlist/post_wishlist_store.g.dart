// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_wishlist_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PostWishListStore on _PostWishListStore, Store {
  Computed<ObservableList<String>>? _$dataComputed;

  @override
  ObservableList<String> get data =>
      (_$dataComputed ??= Computed<ObservableList<String>>(() => super.data, name: '_PostWishListStore.data')).value;
  Computed<int>? _$countComputed;

  @override
  int get count => (_$countComputed ??= Computed<int>(() => super.count, name: '_PostWishListStore.count')).value;

  final _$_dataAtom = Atom(name: '_PostWishListStore._data');

  @override
  ObservableList<String> get _data {
    _$_dataAtom.reportRead();
    return super._data;
  }

  @override
  set _data(ObservableList<String> value) {
    _$_dataAtom.reportWrite(value, super._data, () {
      super._data = value;
    });
  }

  final _$addWishListAsyncAction = AsyncAction('_PostWishListStore.addWishList');

  @override
  Future<bool> addWishList(String value, {int? position}) {
    return _$addWishListAsyncAction.run(() => super.addWishList(value, position: position));
  }

  final _$_PostWishListStoreActionController = ActionController(name: '_PostWishListStore');

  @override
  bool exist(String value) {
    final _$actionInfo = _$_PostWishListStoreActionController.startAction(name: '_PostWishListStore.exist');
    try {
      return super.exist(value);
    } finally {
      _$_PostWishListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
data: ${data},
count: ${count}
    ''';
  }
}
