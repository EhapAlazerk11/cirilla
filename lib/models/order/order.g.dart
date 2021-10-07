// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderData _$OrderDataFromJson(Map<String, dynamic> json) {
  return OrderData(
    id: json['id'] as int?,
    parentId: json['parent_id'] as int?,
    status: json['status'] as String?,
    dateCreated: json['date_created'] as String?,
    shippingTotal: json['shipping_total'] as String?,
    shippingTax: json['shipping_tax'] as String?,
    discountTax: json['discount_tax'] as String?,
    discountTotal: json['discount_total'] as String?,
    total: json['total'] as String?,
    currencySymbol: json['currency_symbol'] as String?,
    currency: json['currency'] as String?,
    paymentMethodTitle: json['payment_method_title'] as String?,
  )
    ..lineItems =
        (json['line_items'] as List<dynamic>?)?.map((e) => LineItems.fromJson(e as Map<String, dynamic>)).toList()
    ..shippingLines = (json['shipping_lines'] as List<dynamic>?)
        ?.map((e) => ShippingLines.fromJson(e as Map<String, dynamic>))
        .toList()
    ..billing = json['billing'] as Map<String, dynamic>?
    ..shipping = json['shipping'] as Map<String, dynamic>?;
}

Map<String, dynamic> _$OrderDataToJson(OrderData instance) => <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'shipping_total': instance.shippingTotal,
      'shipping_tax': instance.shippingTax,
      'discount_total': instance.discountTotal,
      'discount_tax': instance.discountTax,
      'currency_symbol': instance.currencySymbol,
      'payment_method_title': instance.paymentMethodTitle,
      'date_created': instance.dateCreated,
      'line_items': instance.lineItems,
      'shipping_lines': instance.shippingLines,
      'billing': instance.billing,
      'shipping': instance.shipping,
      'total': instance.total,
      'status': instance.status,
      'currency': instance.currency,
    };

ShippingLines _$ShippingLinesFromJson(Map<String, dynamic> json) {
  return ShippingLines(
    methodTitle: json['method_title'] as String?,
    total: json['total'] as String?,
  );
}

Map<String, dynamic> _$ShippingLinesToJson(ShippingLines instance) => <String, dynamic>{
      'method_title': instance.methodTitle,
      'total': instance.total,
    };

LineItems _$LineItemsFromJson(Map<String, dynamic> json) {
  return LineItems(
    name: json['name'] as String?,
    quantity: json['quantity'] as int?,
    price: (json['price'] as num?)?.toDouble(),
    subtotal: json['subtotal'] as String?,
    metaData: (json['meta_data'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList(),
    sku: json['sku'] as String?,
    productId: json['product_id'] as int?,
  );
}

Map<String, dynamic> _$LineItemsToJson(LineItems instance) => <String, dynamic>{
      'meta_data': instance.metaData,
      'product_id': instance.productId,
      'name': instance.name,
      'quantity': instance.quantity,
      'price': LineItems.toDouble(instance.price),
      'subtotal': instance.subtotal,
      'sku': instance.sku,
    };
