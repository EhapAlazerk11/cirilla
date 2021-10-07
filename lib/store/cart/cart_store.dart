import 'package:cirilla/constants/app.dart';
import 'package:cirilla/models/cart/cart.dart';
import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/utils/string_generate.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'cart_store.g.dart';

class CartStore = _CartStore with _$CartStore;

abstract class _CartStore with Store {
  final PersistHelper _persistHelper;
  final RequestHelper _requestHelper;
  final AuthStore _authStore;

  @observable
  bool _loading = false;

  @observable
  bool _loadingShipping = false;

  @observable
  String? _cartKey;

  @observable
  CartData? _cartData;

  @observable
  bool _canLoadMore = true;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  bool get loading => _loading;

  @computed
  bool get loadingShipping => _loadingShipping;

  @computed
  CartData? get cartData => _cartData;

  @computed
  int? get count => _cartData != null ? _cartData!.itemsCount : 0;

  @computed
  String? get cartKey => _cartKey;

  // Action: -----------------------------------------------------------------------------------------------------------
  @action
  Future<bool> setCartKey(String value) async {
    _cartKey = value;
    return await _persistHelper.saveCartKey(value);
  }

  @action
  Future<void> mergeCart({bool? isLogin}) async {
    if (isLogin == true && _authStore.user != null) {
      await setCartKey(_authStore.user!.id);
    } else {
      String id = StringGenerate.uuid();
      await setCartKey(id);
    }
  }

  @action
  Future<void> getCart() async {
    _loading = true;
    try {
      String lang = await _persistHelper.getLanguage();

      Map<String, String?> queryParameters = {
        'cart_key': _cartKey,
        'wpml_language': lang,
      };

      Map<String, dynamic> json = await _requestHelper.getCart(queryParameters: queryParameters);
      _cartData = CartData.fromJson(json);
      _loading = false;
      _canLoadMore = false;
    } on DioError catch (e) {
      _loading = false;
      _canLoadMore = false;
      throw e;
    }
  }

  @action
  Future<void> refresh() async {
    _canLoadMore = true;
    return getCart();
  }

  @action
  Future<void> updateQuantity({key: String, quantity: int}) async {
    try {
      String lang = await _persistHelper.getLanguage();
      Map<String, dynamic> json = await _requestHelper.updateQuantity(
        cartKey: _cartKey,
        queryParameters: {
          'key': key,
          'quantity': quantity,
          'wpml_language': lang,
        },
      );
      _cartData = CartData.fromJson(json);
    } on DioError catch (e) {
      throw e;
    }
  }

  @action
  Future<void> selectShipping({packageId: int, rateId: String}) async {
    _loadingShipping = true;
    try {
      Map<String, dynamic> json = await _requestHelper.selectShipping(
        cartKey: _cartKey,
        queryParameters: {'package_id': packageId, 'rate_id': rateId},
      );
      _cartData = CartData.fromJson(json);
      _loadingShipping = false;
    } on DioError catch (e) {
      _loadingShipping = false;
      throw e;
    }
  }

  @action
  Future<void> updateCustomerCart({Map<String, dynamic>? data}) async {
    try {
      Map<String, dynamic> json = await _requestHelper.updateCustomerCart(
        cartKey: _cartKey,
        data: data,
      );
      _cartData = CartData.fromJson(json);
    } on DioError catch (e) {
      throw e;
    }
  }

  @action
  Future<void> applyCoupon({code: String}) async {
    _loading = true;
    try {
      String lang = await _persistHelper.getLanguage();
      Map<String, dynamic> json = await _requestHelper.applyCoupon(
        cartKey: _cartKey,
        queryParameters: {
          'code': code,
          'wpml_language': lang,
        },
      );
      _cartData = CartData.fromJson(json);
      _loading = false;
    } on DioError catch (e) {
      _loading = false;
      throw e;
    }
  }

  @action
  Future<void> removeCoupon({code: String}) async {
    _loading = true;
    try {
      String lang = await _persistHelper.getLanguage();
      Map<String, dynamic> json = await _requestHelper.removeCoupon(
        cartKey: _cartKey,
        queryParameters: {
          'code': code,
          'wpml_language': lang,
        },
      );
      _cartData = CartData.fromJson(json);
      _loading = false;
    } on DioError catch (e) {
      _loading = false;
      throw e;
    }
  }

  @action
  Future<void> removeCart({key: String}) async {
    _loading = true;
    try {
      String lang = await _persistHelper.getLanguage();
      Map<String, String?> queryParameters = {
        'key': key,
        'wpml_language': lang,
      };
      if (lang != defaultLanguage) {
        queryParameters.putIfAbsent('lang', () => lang);
      }
      Map<String, dynamic> json = await _requestHelper.removeCart(cartKey: _cartKey, queryParameters: queryParameters);
      _cartData = CartData.fromJson(json);
      _loading = false;
    } on DioError catch (e) {
      _loading = false;
      throw e;
    }
  }

  ///
  /// clean cart contents when language change
  ///
  /// https://wpml.org/documentation/related-projects/woocommerce-multilingual/clearing-cart-contents-when-language-or-currency-change/
  ///
  @action
  Future<void> cleanCart() async {
    try {
      Map<String, dynamic> result = await _requestHelper.cleanCart(cartKey: _cartKey);
      print(result);
      _cartData = null;
    } on DioError catch (e) {
      throw e;
    }
  }

  @action
  Future<void> addToCart(Map<String, dynamic> data) async {
    try {
      String lang = await _persistHelper.getLanguage();

      Map<String, dynamic> cartData = Map<String, dynamic>.of(data);

      cartData.putIfAbsent('wpml_language', () => lang);

      Map<String, dynamic> json = await _requestHelper.addToCart(
        cartKey: _cartKey,
        data: cartData,
      );
      _cartData = CartData.fromJson(json);
    } on DioError catch (e) {
      throw e;
    }
  }

  // Constructor: ------------------------------------------------------------------------------------------------------
  _CartStore(this._persistHelper, this._requestHelper, this._authStore) {
    init();
    _reaction();
  }

  Future init() async {
    await restore();
    if (_cartKey != null) getCart();
  }

  Future<void> restore() async {
    String? cartKey = _persistHelper.getCartKey();
    if (cartKey != null && cartKey != "") {
      _cartKey = cartKey;
      await setCartKey(cartKey);
    } else {
      String id = StringGenerate.uuid();
      await setCartKey(id);
    }
  }

  // disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _authStore.isLogin, (dynamic isLogin) => mergeCart(isLogin: isLogin)),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
