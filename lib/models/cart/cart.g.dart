// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartData _$CartDataFromJson(Map<String, dynamic> json) {
  return CartData(
    hasCalculatedShipping: json['has_calculated_shipping'] as bool?,
    itemsCount: json['items_count'] as int?,
    itemsWeight: (json['items_weight'] as num?)?.toDouble(),
    needsPayment: json['needs_payment'] as bool?,
    needsShipping: json['needs_shipping'] as bool?,
  )
    ..items = CartData.toList(json['items'] as List?)
    ..shippingRate = CartData.shippingRateToList(json['shipping_rates'] as List?)
    ..coupons = json['coupons'] as List<dynamic>?
    ..totals = json['totals'] as Map<String, dynamic>?;
}

Map<String, dynamic> _$CartDataToJson(CartData instance) => <String, dynamic>{
      'items_count': instance.itemsCount,
      'items_weight': instance.itemsWeight,
      'needs_payment': instance.needsPayment,
      'needs_shipping': instance.needsShipping,
      'has_calculated_shipping': instance.hasCalculatedShipping,
      'items': instance.items,
      'shipping_rates': instance.shippingRate,
      'coupons': instance.coupons,
      'totals': instance.totals,
    };

ShippingRate _$ShippingRateFromJson(Map<String, dynamic> json) {
  return ShippingRate(
    packageId: json['package_id'] as int?,
    name: json['name'] as String?,
    destination: json['destination'] as Map<String, dynamic>?,
  )..shipItem = ShippingRate.toList(json['shipping_rates'] as List?);
}

Map<String, dynamic> _$ShippingRateToJson(ShippingRate instance) => <String, dynamic>{
      'package_id': instance.packageId,
      'destination': instance.destination,
      'shipping_rates': instance.shipItem,
      'name': instance.name,
    };

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return CartItem(
    key: json['key'] as String?,
    id: json['id'] as int?,
    quantity: json['quantity'] as int?,
    quantityLimit: json['quantity_limit'] as int?,
    name: json['name'] as String?,
    images: (json['images'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList(),
    prices: json['prices'] as Map<String, dynamic>?,
    variation: (json['variation'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList(),
    itemData: (json['item_data'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList(),
  );
}

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'key': instance.key,
      'id': instance.id,
      'quantity': instance.quantity,
      'quantity_limit': instance.quantityLimit,
      'name': instance.name,
      'images': instance.images,
      'variation': instance.variation,
      'item_data': instance.itemData,
      'prices': instance.prices,
    };

ShipItem _$ShipItemFromJson(Map<String, dynamic> json) {
  return ShipItem(
    rateId: json['rate_id'] as String?,
    name: json['name'] as String?,
    deliveryTime: json['delivery_time'] as String?,
    currencyCode: json['currency_code'] as String?,
    currencySymbol: json['currency_symbol'] as String?,
    description: json['description'] as String?,
    methodId: json['method_id'] as String?,
    price: json['price'] as String?,
    selected: json['selected'] as bool?,
  );
}

Map<String, dynamic> _$ShipItemToJson(ShipItem instance) => <String, dynamic>{
      'rate_id': instance.rateId,
      'name': instance.name,
      'description': instance.description,
      'delivery_time': instance.deliveryTime,
      'price': instance.price,
      'method_id': instance.methodId,
      'selected': instance.selected,
      'currency_code': instance.currencyCode,
      'currency_symbol': instance.currencySymbol,
    };
