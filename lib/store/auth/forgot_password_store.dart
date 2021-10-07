import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'forgot_password_store.g.dart';

class ForgotPasswordStore = _ForgotPasswordStore with _$ForgotPasswordStore;

abstract class _ForgotPasswordStore with Store {
  // Request helper instance
  late RequestHelper _requestHelper;

  // constructor:-------------------------------------------------------------------------------------------------------
  _ForgotPasswordStore(RequestHelper requestHelper) {
    _requestHelper = requestHelper;
  }

  // store variables:-----------------------------------------------------------
  @observable
  bool _loading = false;

  @computed
  bool get loading => _loading;

  // actions:-------------------------------------------------------------------
  @action
  Future<bool> forgotPassword(String? userLogin) async {
    _loading = true;
    try {
      await _requestHelper.forgotPassword(userLogin: userLogin);
      _loading = false;
      return true;
    } on DioError catch (e) {
      _loading = false;
      throw e;
    }
  }
}
