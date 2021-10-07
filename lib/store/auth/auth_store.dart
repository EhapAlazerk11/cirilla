import 'dart:io' show Platform;

import 'package:cirilla/models/auth/user.dart';
import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/auth/country_store.dart';
import 'package:cirilla/store/wishlist/wishlist_store.dart';
import 'package:cirilla/store/post_wishlist/post_wishlist_store.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as FB;
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';
import 'package:cirilla/constants/app.dart' show googleClientId;
import 'package:cirilla/constants/constants.dart' show isWeb;
import 'package:cirilla/service/messaging.dart';

import 'change_password_store.dart';
import 'forgot_password_store.dart';
import 'login_store.dart';
import 'register_store.dart';

part 'auth_store.g.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: isWeb || Platform.isAndroid ? googleClientId : null,
  scopes: <String>[
    'email',
    'profile',
  ],
);

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final PersistHelper _persistHelper;
  final RequestHelper _requestHelper;

  LoginStore? loginStore;

  late RegisterStore registerStore;

  late ForgotPasswordStore forgotPasswordStore;

  late ChangePasswordStore changePasswordStore;

  AddressStore? addressStore;

  WishListStore? wishListStore;

  PostWishListStore? postWishListStore;

  @observable
  bool _isLogin = false;

  @action
  void setLogin(bool value) {
    _isLogin = value;
  }

  @observable
  String? _token;

  @action
  Future<bool> setToken(String value) async {
    _token = value;
    return await _persistHelper.saveToken(value);
  }

  @observable
  User? _user;

  @observable
  bool? _loadingEditAccount;

  @computed
  bool get isLogin => _isLogin;

  @computed
  User? get user => _user;

  @computed
  String? get token => _token;

  @computed
  bool? get loadingEditAccount => _loadingEditAccount;

  // Action: -----------------------------------------------------------------------------------------------------------
  @action
  void setUser(value) {
    _user = value;
  }

  @action
  Future<void> loginSuccess(Map<String, dynamic> data) async {
    try {
      _isLogin = true;
      _user = User.fromJson(data['user']);
      await setToken(data['token']);

      // Update FCM token to database
      String? token = await getToken();
      await updateTokenToDatabase(_requestHelper, token);
    } catch (e) {
      print('Error in loginSuccess');
    }
  }

  @action
  Future<bool> logout() async {
    _isLogin = false;
    _token = null;

    // Remove FCM token in database
    String? token = await getToken();
    await removeTokenInDatabase(_requestHelper, token, _user!.id);

    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Logout google error or not logged!');
    }

    try {
      await Firebase.initializeApp();
      await FB.FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Logout Firebase error or not logged!');
    }

    return await _persistHelper.removeToken();
  }

  @action
  Future<bool> editAccount(Map<String, dynamic> data) async {
    _loadingEditAccount = true;
    try {
      await _requestHelper.postAccount(
        userId: _user!.id,
        data: data,
      );
      Map<String, dynamic> userCustomer = _user!.toJson();
      userCustomer.addAll({
        'first_name': data['first_name'] is String ? data['first_name'] : _user!.firstName,
        'last_name': data['last_name'] is String ? data['last_name'] : _user!.lastName,
        'display_name': data['name'] is String ? data['name'] : _user!.displayName,
        'user_email': data['email'] is String ? data['email'] : _user!.userEmail,
      });
      _user = User.fromJson(userCustomer);
      _loadingEditAccount = false;
      return true;
    } on DioError catch (e) {
      _loadingEditAccount = false;
      throw e;
    }
  }

  // Constructor: ------------------------------------------------------------------------------------------------------
  _AuthStore(this._persistHelper, this._requestHelper) {
    this.loginStore = LoginStore(_requestHelper, this as AuthStore);
    this.registerStore = RegisterStore(_requestHelper, this as AuthStore);
    this.forgotPasswordStore = ForgotPasswordStore(_requestHelper);
    this.changePasswordStore = ChangePasswordStore(_requestHelper);
    this.addressStore = AddressStore(_requestHelper);
    this.wishListStore = WishListStore(_persistHelper);
    this.postWishListStore = PostWishListStore(_persistHelper);
    init();
  }

  Future init() async {
    restore();
  }

  void restore() async {
    String? token = _persistHelper.getToken();
    if (token != null && token != '') {
      try {
        Map<String, dynamic> json = await _requestHelper.current();
        _user = User.fromJson(json);
        _token = token;
        _isLogin = true;
      } catch (e) {
        await _persistHelper.removeToken();
      }
    }
  }
}
