import 'package:cirilla/utils/convert_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class OrderData {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'parent_id')
  int? parentId;

  @JsonKey(name: 'shipping_total')
  String? shippingTotal;

  @JsonKey(name: 'shipping_tax')
  String? shippingTax;

  @JsonKey(name: 'discount_total')
  String? discountTotal;

  @JsonKey(name: 'discount_tax')
  String? discountTax;

  @JsonKey(name: 'currency_symbol')
  String? currencySymbol;

  @JsonKey(name: 'payment_method_title')
  String? paymentMethodTitle;

  @JsonKey(name: 'date_created')
  String? dateCreated;

  @JsonKey(name: 'line_items')
  List<LineItems>? lineItems;

  @JsonKey(name: 'shipping_lines')
  List<ShippingLines>? shippingLines;

  Map<String, dynamic>? billing;

  Map<String, dynamic>? shipping;

  String? total;

  String? status;

  String? currency;

  OrderData(
      {this.id,
      this.parentId,
      this.status,
      this.dateCreated,
      this.shippingTotal,
      this.shippingTax,
      this.discountTax,
      this.discountTotal,
      this.total,
      this.currencySymbol,
      this.currency,
      this.paymentMethodTitle});

  factory OrderData.fromJson(Map<String, dynamic> json) => _$OrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDataToJson(this);

  static List<LineItems> toList(List<dynamic>? data) {
    List<LineItems> _lineItems = <LineItems>[];

    if (data == null) return _lineItems;

    _lineItems = data.map((d) => LineItems.fromJson(d)).toList().cast<LineItems>();
    return _lineItems;
  }

  static List<ShippingLines> toShippingLines(List<dynamic>? data) {
    List<ShippingLines> _shippingLines = <ShippingLines>[];

    if (data == null) return _shippingLines;

    _shippingLines = data.map((d) => ShippingLines.fromJson(d)).toList().cast<ShippingLines>();
    return _shippingLines;
  }
}

@JsonSerializable()
class ShippingLines {
  @JsonKey(name: 'method_title')
  String? methodTitle;
  String? total;

  ShippingLines({this.methodTitle, this.total});

  factory ShippingLines.fromJson(Map<String, dynamic> json) => _$ShippingLinesFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingLinesToJson(this);

  static double? toDouble(dynamic json) {
    return ConvertData.stringToDouble(json);
  }
}

@JsonSerializable()
class LineItems {
  @JsonKey(name: 'meta_data')
  List<Map<String, dynamic>>? metaData;

  @JsonKey(name: 'product_id')
  int? productId;

  String? name;

  int? quantity;

  @JsonKey(toJson: toDouble)
  double? price;

  String? subtotal;

  String? sku;
  LineItems({this.name, this.quantity, this.price, this.subtotal, this.metaData, this.sku, this.productId});

  factory LineItems.fromJson(Map<String, dynamic> json) => _$LineItemsFromJson(json);

  Map<String, dynamic> toJson() => _$LineItemsToJson(this);

  static double? toDouble(dynamic json) {
    return ConvertData.stringToDouble(json);
  }
}
