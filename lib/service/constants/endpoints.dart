import 'package:cirilla/constants/app.dart';

class Endpoints {
  Endpoints._();

  // base url
  static const String restUrl = String.fromEnvironment('BASE_URL', defaultValue: "$URL$REST_PREFIX");
  static const String consumer_key = String.fromEnvironment('CONSUMER_KEY', defaultValue: CONSUMER_KEY);
  static const String consumer_secret = String.fromEnvironment('CONSUMER_SECRET', defaultValue: CONSUMER_SECRET);

  // receiveTimeout
  static const int receiveTimeout = 9999;

  // connectTimeout
  static const int connectionTimeout = 9999;

  // Woocommerce API: ==================================================================================================

  // orders endpoints
  static const String getOrders = "/wc/v3/orders";

  // products endpoints
  static const String getProducts = "/wc/v3/products";

  // product categories endpoints
  static const String getProductCategories = "/wc/v3/products/categories";

  // attributes endpoints
  static const String getAttributes = "/wc/v3/products/attributes";

  // Min - max price in category
  static const String getMinMaxPrices = "/wc/v3/min-max-prices";

  // Get Term Product Count
  static const String getTermProductCount = "/wc/v3/term-product-counts";

  // Get brand
  static const String getBrands = "/wc/v2/products/brands";

  // App Builder API: ==================================================================================================

  // categories endpoints
  static const String getCategories = "/app-builder/v1/categories";

  // Settings endpoints
  static const String getSettings = "/app-builder/v1/settings";

  static const String getTemplates = "/app-builder/v1/template-mobile";

  // Login with Email and Username
  static const String login = "/app-builder/v1/login";

  // Login with Facebook
  static const String loginFacebook = "/app-builder/v1/facebook";

  // Login with Google
  static const String loginGoogle = "/app-builder/v1/google";

  // Login with Apple
  static const String loginApple = "/app-builder/v1/apple";

  // Login with Facebook
  static const String loginWidthFacebook = "/app-builder/v1/facebook";

  // Login with Google
  static const String loginWithGoogle = "/app-builder/v1/google";

  // Login with Apple
  static const String loginWithApple = "/app-builder/v1/apple";

  // Login with OTP
  static const String loginWithOtp = "/app-builder/v1/login-otp";

  // Register
  static const String register = "/app-builder/v1/register";

  // Change Email
  static const String changeEmail = "/app-builder/v1/change-email";

  // Forgot password
  static const String forgotPassword = "/app-builder/v1/lost-password";

  // Forgot password
  static const String loginToken = "/app-builder/v1/login-token";

  // Change password
  static const String changePassword = "/app-builder/v1/change-password";

  // Variable endpoints
  static const String getProductVariable = "/app-builder/v1/product-variations";

  // Cart endpoints
  static const String current = "/app-builder/v1/current";

  // Update user token endpoints
  static const String updateUserToken = "/push-notify/v1/update-user-token";

  // Remove user token endpoints
  static const String removeUserToken = "/push-notify/v1/remove-user-token";

  // archives post
  static const String archives = "/app-builder/v1/archives";

  // vendor
  static const String getVendor = "/app-builder/v1/vendors";

  // vendor
  static const String getCountryLocale = "/app-builder/v1/get-country-locale";

  // Wordpress API: ====================================================================================================

  // Search
  static const String search = "/wp/v2/search";

  // Get posts
  static const String getPosts = "/wp/v2/posts";

  // Get post comments
  static const String getPostComments = "/wp/v2/comments";

  // Get post categories
  static const String getPostCategories = "/wp/v2/categories";

  // Get post categories
  static const String getPostAuthor = "/wp/v2/users";

  // Get post tags
  static const String getPostTags = "/wp/v2/tags";

  static const String getPage = "/wp/v2/pages";

  // Dokan API: ========================================================================================================

  static const String getDokanVendor = "/dokan/v1/stores";

  // Cart API: =========================================================================================================

  // Get cart list
  static const String getCart = "/wc/store/cart";

  // Add to cart
  static const String addToCart = "/wc/store/cart/add-item";

  // Apply coupon
  static const String applyCoupon = "/wc/store/cart/apply-coupon";

  // List coupon
  static const String coupons = "/wc/store/cart/coupons";

  // Remove coupon
  static const String removeCoupon = "/wc/store/cart/remove-coupon";

  // Remove cart
  static const String removeCart = "/wc/store/cart/remove-item";

  // Clean cart
  static const String cleanCart = "/app-builder/v1/clean-cart";

  // Update cart
  static const String updateCart = "/wc/store/cart/update-item";

  /// shipping cart
  static const String shippingCart = '/wc/store/cart/select-shipping-rate';

  /// Update-customer cart
  static const String updateCustomerCart = '/wc/store/cart/update-customer';

  // Contact API: ======================================================================================================

  // orders endpoints
  static const String contactForm7 = "/contact-form-7/v1/contact-forms";

  // country
  static const String getCountries = "/wc/v3/data/countries";

  // update user account
  static const String postAccount = "/wp/v2/users";

  // update customer
  static const String postCustomer = "/app-builder/v1/customers";

  // update customer
  static const String getCustomer = "/wc/v3/customers";

  // Review API: =======================================================================================================

  // write review
  static const String writeReview = "/app-builder/v1/reviews";

  // get reviews
  static const String getReviews = "/wc/v3/products/reviews";

  // get rating count
  static const String ratingCount = "/app-builder/v1/rating-count";
}
