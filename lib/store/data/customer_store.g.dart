// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CustomerStore on _CustomerStore, Store {
  Computed<Customer?>? _$customerComputed;

  @override
  Customer? get customer =>
      (_$customerComputed ??= Computed<Customer?>(() => super.customer, name: '_CustomerStore.customer')).value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading, name: '_CustomerStore.loading')).value;

  final _$_customerAtom = Atom(name: '_CustomerStore._customer');

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

  final _$_loadingAtom = Atom(name: '_CustomerStore._loading');

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

  final _$getCustomerAsyncAction = AsyncAction('_CustomerStore.getCustomer');

  @override
  Future<void> getCustomer({dynamic userId = String}) {
    return _$getCustomerAsyncAction.run(() => super.getCustomer(userId: userId));
  }

  final _$updateCustomerAsyncAction = AsyncAction('_CustomerStore.updateCustomer');

  @override
  Future<void> updateCustomer({dynamic userId = String, Map<String, dynamic>? data}) {
    return _$updateCustomerAsyncAction.run(() => super.updateCustomer(userId: userId, data: data));
  }

  @override
  String toString() {
    return '''
customer: ${customer},
loading: ${loading}
    ''';
  }
}
