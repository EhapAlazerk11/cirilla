import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'address_field_store.g.dart';

class AddressFieldStore = _AddressFieldStore with _$AddressFieldStore;

abstract class _AddressFieldStore with Store {
  final String? key;
  RequestHelper _requestHelper;

  _AddressFieldStore(this._requestHelper, {this.key}) {
    _reaction();
  }

  @observable
  ObservableMap<String, dynamic> _addressFields = ObservableMap<String, dynamic>.of({});

  @observable
  bool _loading = false;

  @computed
  ObservableMap<String, dynamic> get addressFields => _addressFields;

  @computed
  bool get loading => _loading;

  @action
  Future<void> getAddressField({Map<String, dynamic>? queryParameters}) async {
    try {
      _loading = true;
      Map<String, dynamic> data = await _requestHelper.getCountryLocale(queryParameters: queryParameters);
      _addressFields = ObservableMap<String, dynamic>.of(data);
      _loading = false;
    } on DioError catch (e) {
      _loading = false;
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
