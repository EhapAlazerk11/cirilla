import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable()
class CartData {
  @JsonKey(name: 'items_count')
  int? itemsCount;

  @JsonKey(name: 'items_weight')
  double? itemsWeight;

  @JsonKey(name: 'needs_payment')
  bool? needsPayment;

  @JsonKey(name: 'needs_shipping')
  bool? needsShipping;

  @JsonKey(name: 'has_calculated_shipping')
  bool? hasCalculatedShipping;

  @JsonKey(fromJson: toList)
  List<CartItem>? items;

  @JsonKey(name: 'shipping_rates', fromJson: shippingRateToList)
  List<ShippingRate>? shippingRate;

  List? coupons;

  Map<String, dynamic>? totals;

  CartData({
    this.hasCalculatedShipping,
    this.itemsCount,
    this.itemsWeight,
    this.needsPayment,
    this.needsShipping,
  });

  factory CartData.fromJson(Map<String, dynamic> json) => _$CartDataFromJson(json);

  Map<String, dynamic> toJson() => _$CartDataToJson(this);

  static List<CartItem> toList(List<dynamic>? data) {
    List<CartItem> _items = <CartItem>[];

    if (data == null) return _items;

    _items = data.map((d) => CartItem.fromJson(d)).toList().cast<CartItem>();

    return _items;
  }

  static List<ShippingRate> shippingRateToList(List<dynamic>? data) {
    List<ShippingRate> _shippingRate = <ShippingRate>[];

    if (data == null) return _shippingRate;

    _shippingRate = data.map((d) => ShippingRate.fromJson(d)).toList().cast<ShippingRate>();

    return _shippingRate;
  }
}

@JsonSerializable()
class ShippingRate {
  @JsonKey(name: 'package_id')
  int? packageId;

  Map<String, dynamic>? destination;

  @JsonKey(name: 'shipping_rates', fromJson: toList)
  List<ShipItem>? shipItem;

  String? name;

  ShippingRate({this.packageId, this.name, this.destination});
  factory ShippingRate.fromJson(Map<String, dynamic> json) => _$ShippingRateFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingRateToJson(this);

  static List<ShipItem> toList(List<dynamic>? data) {
    List<ShipItem> _shipItems = <ShipItem>[];

    if (data == null) return _shipItems;

    _shipItems = data.map((d) => ShipItem.fromJson(d)).toList().cast<ShipItem>();

    return _shipItems;
  }
}

@JsonSerializable()
class CartItem {
  String? key;

  int? id;

  int? quantity;

  @JsonKey(name: 'quantity_limit')
  int? quantityLimit;

  String? name;

  List<Map<String, dynamic>>? images;

  List<Map<String, dynamic>>? variation;

  @JsonKey(name: 'item_data')
  List<Map<String, dynamic>>? itemData;

  Map<String, dynamic>? prices;

  CartItem({
    this.key,
    this.id,
    this.quantity,
    this.quantityLimit,
    this.name,
    this.images,
    this.prices,
    this.variation,
    this.itemData,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}

@JsonSerializable()
class ShipItem {
  @JsonKey(name: 'rate_id')
  String? rateId;
  String? name;
  String? description;
  @JsonKey(name: 'delivery_time')
  String? deliveryTime;
  String? price;
  @JsonKey(name: 'method_id')
  String? methodId;
  bool? selected;
  @JsonKey(name: 'currency_code')
  String? currencyCode;
  @JsonKey(name: 'currency_symbol')
  String? currencySymbol;
  ShipItem(
      {this.rateId,
      this.name,
      this.deliveryTime,
      this.currencyCode,
      this.currencySymbol,
      this.description,
      this.methodId,
      this.price,
      this.selected});
  factory ShipItem.fromJson(Map<String, dynamic> json) => _$ShipItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShipItemToJson(this);
}
