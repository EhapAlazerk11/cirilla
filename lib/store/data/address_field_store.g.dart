// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_field_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AddressFieldStore on _AddressFieldStore, Store {
  Computed<ObservableMap<String, dynamic>>? _$addressFieldsComputed;

  @override
  ObservableMap<String, dynamic> get addressFields => (_$addressFieldsComputed ??=
          Computed<ObservableMap<String, dynamic>>(() => super.addressFields, name: '_AddressFieldStore.addressFields'))
      .value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading =>
      (_$loadingComputed ??= Computed<bool>(() => super.loading, name: '_AddressFieldStore.loading')).value;

  final _$_addressFieldsAtom = Atom(name: '_AddressFieldStore._addressFields');

  @override
  ObservableMap<String, dynamic> get _addressFields {
    _$_addressFieldsAtom.reportRead();
    return super._addressFields;
  }

  @override
  set _addressFields(ObservableMap<String, dynamic> value) {
    _$_addressFieldsAtom.reportWrite(value, super._addressFields, () {
      super._addressFields = value;
    });
  }

  final _$_loadingAtom = Atom(name: '_AddressFieldStore._loading');

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

  final _$getAddressFieldAsyncAction = AsyncAction('_AddressFieldStore.getAddressField');

  @override
  Future<void> getAddressField({Map<String, dynamic>? queryParameters}) {
    return _$getAddressFieldAsyncAction.run(() => super.getAddressField(queryParameters: queryParameters));
  }

  @override
  String toString() {
    return '''
addressFields: ${addressFields},
loading: ${loading}
    ''';
  }
}
