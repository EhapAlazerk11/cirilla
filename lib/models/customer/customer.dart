import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  int? id;
  String? username;
  @JsonKey(name: 'first_name')
  String? firstName;
  @JsonKey(name: 'last_name')
  String? lastName;
  String? role;
  String? email;
  Map<String, dynamic>? billing;
  Map<String, dynamic>? shipping;
  @JsonKey(name: 'avatar_url')
  String? avatar;

  Customer({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.role,
    this.email,
    this.billing,
    this.shipping,
    this.avatar,
  });
  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
