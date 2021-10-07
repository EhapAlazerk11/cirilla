import 'package:json_annotation/json_annotation.dart';

part 'vendor.g.dart';

@JsonSerializable()
class Vendor {
  int? id;

  @JsonKey(name: 'store_name')
  String? storeName;

  String? phone;

  String? email;

  @JsonKey(name: 'vendor_address')
  String? vendorAddress;

  @JsonKey(name: 'show_email')
  bool? showEmail;

  dynamic social;

  @JsonKey(name: 'banner', fromJson: _imageFromJson, toJson: _imageToJson)
  String? banner;

  @JsonKey(name: 'gravatar', fromJson: _imageFromJson, toJson: _imageToJson)
  String? gravatar;

  RatingVendor? rating;

  bool? featured;

  static String _imageFromJson(dynamic value) => value is String ? value : '';

  static dynamic _imageToJson(String? data) {
    return data;
  }

  Vendor({
    this.id,
    this.storeName,
    this.phone,
    this.email,
    this.vendorAddress,
    this.showEmail,
    this.social,
    this.banner,
    this.gravatar,
    this.rating,
    this.featured,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);

  Map<String, dynamic> toJson() => _$VendorToJson(this);
}

@JsonSerializable()
class RatingVendor {
  double? rating;
  int? count;
  double? avg;

  RatingVendor({
    this.rating,
    this.count,
    this.avg,
  });

  factory RatingVendor.fromJson(Map<String, dynamic> json) => _$RatingVendorFromJson(json);

  Map<String, dynamic> toJson() => _$RatingVendorToJson(this);
}
