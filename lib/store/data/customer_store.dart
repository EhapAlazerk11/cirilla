import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'customer_store.g.dart';

class CustomerStore = _CustomerStore with _$CustomerStore;

abstract class _CustomerStore with Store {
  final RequestHelper _requestHelper;

  _CustomerStore(
    this._requestHelper,
  ) {
    _reaction();
  }

  @observable
  Customer? _customer;

  @observable
  bool _loading = false;

  @computed
  Customer? get customer => _customer;

  @computed
  bool get loading => _loading;

  @action
  Future<void> getCustomer({userId: String}) async {
    try {
      _loading = true;
      Customer data = await _requestHelper.getCustomer(userId: userId);
      _customer = data;
      _loading = false;
    } on DioError catch (e) {
      _loading = false;
      throw e;
    }
  }

  @action
  Future<void> updateCustomer({userId: String, Map<String, dynamic>? data}) async {
    try {
      Customer customer = await _requestHelper.postCustomer(
        userId: userId,
        data: data,
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
