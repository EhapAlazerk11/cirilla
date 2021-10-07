// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
    id: json['id'] as int?,
    username: json['username'] as String?,
    firstName: json['first_name'] as String?,
    lastName: json['last_name'] as String?,
    role: json['role'] as String?,
    email: json['email'] as String?,
    billing: json['billing'] as Map<String, dynamic>?,
    shipping: json['shipping'] as Map<String, dynamic>?,
    avatar: json['avatar_url'] as String?,
  );
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'role': instance.role,
      'email': instance.email,
      'billing': instance.billing,
      'shipping': instance.shipping,
      'avatar_url': instance.avatar,
    };
