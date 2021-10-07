import 'package:cirilla/models/address/country.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/order/order.dart';
import 'package:cirilla/models/order_note/order_node.dart';
import 'package:cirilla/models/post/post.dart';
import 'package:cirilla/models/post/post_category.dart';
import 'package:cirilla/models/post/post_comment.dart';
import 'package:cirilla/models/post_tag/post_tag.dart';
import 'package:cirilla/models/post_author/post_author.dart';
import 'package:cirilla/models/product/attributes.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/models/product/product_prices.dart';
import 'package:cirilla/models/product/product_variable.dart';
import 'package:cirilla/models/product_category/product_category.dart';
import 'package:cirilla/models/product_review/product_review.dart';
import 'package:cirilla/service/constants/endpoints.dart';
import 'package:cirilla/service/modules/network_module.dart';
import 'package:dio/dio.dart';

/// The RequestHelper contain all API for app request and serialize data
class RequestHelper {
  final DioClient _dioClient;

  RequestHelper(this._dioClient);

  Future<Map<String, dynamic>> getSettings() async {
    try {
      final res = await _dioClient.get(Endpoints.getSettings);
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  // ---------------------------------------------- Product ------------------------------------------------------------

  /// Returns list of product in response
  Future<List<Product>?> getProducts({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getProducts,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Product>? products = <Product>[];
      products = data.map((product) => Product.fromJson(product)).toList().cast<Product>();
      return products;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Retrieve a product in response
  Future<Product> getProduct({int? id, Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getProducts + "/$id",
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return Product.fromJson(data);
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Returns list of product in response
  Future<List<Brand>?> getBrands({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getBrands,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Brand>? brands = <Brand>[];
      brands = data.map((value) => Brand.fromJson(value)).toList().cast<Brand>();
      return brands;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Returns list of product in response
  Future<Brand> getBrand({required int id, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getBrands + "/$id",
        cancelToken: cancelToken,
      );
      return Brand.fromJson(data);
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Returns list of product category in response
  Future<List<ProductCategory>?> getProductCategories(
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getCategories,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<ProductCategory>? categories = <ProductCategory>[];
      categories = data.map((category) => ProductCategory.fromJson(category)).toList().cast<ProductCategory>();
      return categories;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Returns list of post in response
  Future<List<PostCategory>?> getPostCategories(
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getPostCategories,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<PostCategory>? postCategories = <PostCategory>[];
      postCategories = data.map((post) => PostCategory.fromJson(post)).toList().cast<PostCategory>();
      return postCategories;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Returns product variable data
  Future<ProductVariable> getProductVariations({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final json = await _dioClient.get(
        Endpoints.getProductVariable,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return ProductVariable.fromJson(json);
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Get attributes by terms
  Future<Attributes> getAttributes({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final json = await _dioClient.get(
        Endpoints.getAttributes,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return Attributes.fromJson(json);
    } on DioError catch (e) {
      throw e;
    }
  }

  // Get Min - Max prices
  Future<ProductPrices> getMinMaxPrices({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final json = await _dioClient.get(
        Endpoints.getMinMaxPrices,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return ProductPrices.fromJson(json);
    } on DioError catch (e) {
      throw e;
    }
  }

  // ---------------------------------------------- Post ---------------------------------------------------------------

  /// Returns list of post in response
  Future<List<Post>?> getPosts({
    String postType = 'posts',
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final data = await _dioClient.get(
        '/wp/v2/$postType',
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Post>? posts = <Post>[];
      posts = data.map((post) => Post.fromJson(post)).toList().cast<Post>();
      return posts;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Retrieve a post in response
  Future<Post> getPost({String postType = 'posts', int? id, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        '/wp/v2/$postType/$id',
        cancelToken: cancelToken,
      );
      return Post.fromJson(data);
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Returns list of comment in response
  Future<List<PostComment>?> getPostComments({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getPostComments,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<PostComment>? comments = <PostComment>[];
      comments = data.map((comment) => PostComment.fromJson(comment)).toList().cast<PostComment>();
      return comments;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Write a comment
  Future<PostComment> writeComments({required Map<String, dynamic> queryParameters, CancelToken? cancelToken}) async {
    try {
      final json = await _dioClient.post(
        Endpoints.getPostComments,
        queryParameters: {
          ...queryParameters,
          'app-builder-decode': true,
        },
        cancelToken: cancelToken,
      );
      return PostComment.fromJson(json);
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Returns list of tags in response
  Future<List<PostTag>?> getPostTags({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getPostTags,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<PostTag>? tags = <PostTag>[];
      tags = data.map((comment) => PostTag.fromJson(comment)).toList().cast<PostTag>();
      return tags;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Returns list of tags in response
  Future<List<PostAuthor>?> getPostAuthors({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getPostAuthor,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<PostAuthor>? users = <PostAuthor>[];
      users = data.map((comment) => PostAuthor.fromJson(comment)).toList().cast<PostAuthor>();
      return users;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Retrieve a post in response
  Future<PostAuthor> getPostAuthor({int? id, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getPostAuthor + "/$id",
        cancelToken: cancelToken,
      );
      return PostAuthor.fromJson(data);
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Returns list of tags in response
  Future<List<PostArchive>?> getPostArchives({CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.archives,
        cancelToken: cancelToken,
      );
      List<PostArchive>? archives = <PostArchive>[];
      archives = data.map((value) => PostArchive.fromJson(value)).toList().cast<PostArchive>();
      return archives;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Search post
  Future<List<PostSearch>?> searchPost({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.search,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<PostSearch>? search = <PostSearch>[];
      search = data.map((value) => PostSearch.fromJson(value)).toList().cast<PostSearch>();
      return search;
    } on DioError catch (e) {
      throw e;
    }
  }

  // ---------------------------------------------- Auth ---------------------------------------------------------------

  /// Login with Email or Username
  Future<Map<String, dynamic>> login({Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post(Endpoints.login, queryParameters: queryParameters);
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Register user
  Future<Map<String, dynamic>> register(Map<String, dynamic> queryParameters) async {
    try {
      final res = await _dioClient.post(Endpoints.register, queryParameters: queryParameters);
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Forgot password
  Future<dynamic> forgotPassword({String? userLogin}) async {
    try {
      final res = await _dioClient.post(Endpoints.forgotPassword, queryParameters: {'user_login': userLogin});
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Change password
  Future<dynamic> changePassword({Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post('${Endpoints.changePassword}?app-builder-decode=true',
          queryParameters: queryParameters);

      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Current user
  Future<Map<String, dynamic>> current() async {
    try {
      final res = await _dioClient.get(Endpoints.current, queryParameters: {'app-builder-decode': true});
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Update user token
  Future<Map<String, dynamic>?> updateUserToken(String? token) async {
    try {
      final res = await _dioClient.post(
        Endpoints.updateUserToken,
        data: {'token': token},
        queryParameters: {'app-builder-decode': true},
      );
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Update user token
  Future<Map<String, dynamic>?> removeUserToken(String? token, String? userId) async {
    try {
      final res = await _dioClient.post(
        Endpoints.removeUserToken,
        data: {'token': token, 'userId': userId},
      );
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  // ---------------------------------------------- Cart ---------------------------------------------------------------
  /// Get list cart
  Future<Map<String, dynamic>> getCart({Map<String, dynamic>? queryParameters}) async {
    try {
      String url = Endpoints.getCart + "?" + Uri(queryParameters: queryParameters).query;
      final res = await _dioClient.get(url);
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Add to cart
  Future<Map<String, dynamic>> addToCart({String? cartKey, Map<String, dynamic>? data}) async {
    print(data);
    try {
      Map<String, String?> queryParams = {
        'cart_key': cartKey,
        'app-builder-decode': 'true',
      };
      String url = Endpoints.addToCart + "?" + Uri(queryParameters: queryParams).query;

      final res = await _dioClient.post(url,
          data: data,
          options: Options(
            headers: {
              Headers.contentTypeHeader: 'application/x-www-form-urlencoded',
            },
          ));
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Update quantity
  Future<Map<String, dynamic>> updateQuantity({String? cartKey, Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post('${Endpoints.updateCart}?cart_key=$cartKey&app-builder-decode=true',
          queryParameters: queryParameters);
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Select shipping cart
  Future<Map<String, dynamic>> selectShipping({String? cartKey, Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post('${Endpoints.shippingCart}?cart_key=$cartKey&app-builder-decode=true',
          queryParameters: queryParameters);
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> updateCustomerCart(
      {String? cartKey, Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) async {
    try {
      final res = await _dioClient.post('${Endpoints.updateCustomerCart}?cart_key=$cartKey&app-builder-decode=true',
          queryParameters: queryParameters, data: data);
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Apply Coupon
  Future<Map<String, dynamic>> applyCoupon({String? cartKey, Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post('${Endpoints.applyCoupon}?cart_key=$cartKey&app-builder-decode=true',
          queryParameters: queryParameters);
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Remove Coupon
  Future<Map<String, dynamic>> removeCoupon({String? cartKey, Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post('${Endpoints.removeCoupon}?cart_key=$cartKey&app-builder-decode=true',
          queryParameters: queryParameters);
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Remove cart
  Future<Map<String, dynamic>> removeCart({String? cartKey, Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post('${Endpoints.removeCart}?cart_key=$cartKey&app-builder-decode=true',
          data: queryParameters);
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Clean cart
  Future<Map<String, dynamic>> cleanCart({String? cartKey}) async {
    try {
      final res = await _dioClient.post('${Endpoints.cleanCart}?cart_key=$cartKey');
      return res;
    } on DioError catch (e) {
      throw e;
    }
  }

  // ---------------------------------------------- Order --------------------------------------------------------------
  /// Get list orders
  Future<List<OrderData>?> getOrders({Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getOrders,
        queryParameters: queryParameters,
      );
      List<OrderData>? orders = <OrderData>[];
      orders = data.map((order) => OrderData.fromJson(order)).toList().cast<OrderData>();
      return orders;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Get list orders node
  Future<List<OrderNode>?> getOrderNodes({Map<String, dynamic>? queryParameters, int? orderId}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getOrders}/$orderId/notes',
        queryParameters: queryParameters,
      );
      List<OrderNode>? orders = <OrderNode>[];
      orders = data.map((order) => OrderNode.fromJson(order)).toList().cast<OrderNode>();
      return orders;
    } on DioError catch (e) {
      throw e;
    }
  }

  // ---------------------------------------------- Contact ------------------------------------------------------------
  /// Send contact or Subscription
  Future<Map<String, dynamic>> sendContact({Map<String, dynamic>? queryParameters, String? formId}) async {
    try {
      final data = await _dioClient.post('${Endpoints.contactForm7}/$formId/feedback',
          data: queryParameters,
          options: Options(
            headers: {
              Headers.contentTypeHeader: 'application/x-www-form-urlencoded', // set content-length
            },
          ));
      return data;
    } on DioError catch (e) {
      throw e;
    }
  }

  // ---------------------------------------------- My Account ---------------------------------------------------------
  /// Address book
  Future<List<CountryData>> getCountry({Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getCountries,
        queryParameters: queryParameters,
      );
      List<CountryData> countries = <CountryData>[];
      countries = data.map((country) => CountryData.fromJson(country)).toList().cast<CountryData>();
      return countries;
    } on DioError catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> getCountryLocale({Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getCountryLocale,
        queryParameters: queryParameters,
      );
      if (data is Map<String, dynamic>) {
        return data;
      }
      return {};
    } on DioError catch (e) {
      throw e;
    }
  }

  Future<Customer> postCustomer(
      {String? userId, Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) async {
    try {
      Map<String, dynamic> query = queryParameters != null
          ? {
              ...queryParameters,
              'app-builder-decode': true,
            }
          : {
              'app-builder-decode': true,
            };

      final res = await _dioClient.post(
        '${Endpoints.postCustomer}/$userId',
        queryParameters: query,
        data: data,
      );
      return Customer.fromJson(res);
    } on DioError catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Map<String, dynamic>?> postAccount(
      {String? userId, Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) async {
    try {
      Map<String, dynamic> query = queryParameters != null
          ? {
              ...queryParameters,
              'app-builder-decode': true,
            }
          : {
              'app-builder-decode': true,
            };

      final res = await _dioClient.post(
        '${Endpoints.postAccount}/$userId',
        queryParameters: query,
        data: data,
      );
      return res;
    } on DioError catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Customer> getCustomer({
    String? userId,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final res = await _dioClient.get(
        '${Endpoints.getCustomer}/$userId',
        queryParameters: queryParameters,
      );
      return Customer.fromJson(res);
    } on DioError catch (e) {
      throw e;
    }
  }

  // ------------------------------------------------ Reviews ----------------------------------------------------------
  /// Get list review
  Future<List<ProductReview>?> getReviews({Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(Endpoints.getReviews, queryParameters: queryParameters);

      List<ProductReview>? reviews = <ProductReview>[];
      reviews = data.map((review) => ProductReview.fromJson(review)).toList().cast<ProductReview>();
      return reviews;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Add review
  Future<ProductReview> writeReviews({Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post(Endpoints.writeReview, queryParameters: queryParameters);
      return ProductReview.fromJson(res);
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Rating count
  Future<RatingCount> getRatingCount({Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.get(Endpoints.ratingCount, queryParameters: queryParameters);
      return RatingCount.fromJson(res);
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Returns list of vendor in response
  Future<List<Vendor>?> getVendors({Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getVendor,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Vendor>? vendors = <Vendor>[];
      vendors = data.map((comment) => Vendor.fromJson(comment)).toList().cast<Vendor>();
      return vendors;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// Returns data of page in response
  Future<PageData> getPageDetail({int? idPage, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get('${Endpoints.getPage}/$idPage', cancelToken: cancelToken);
      return PageData.fromJson(data);
    } on DioError catch (e) {
      throw e;
    }
  }
}
