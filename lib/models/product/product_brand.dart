import 'package:json_annotation/json_annotation.dart';

part 'product_brand.g.dart';

@JsonSerializable()
class ProductBrand {
  int? id;

  String? slug;

  String? name;

  ProductBrand({
    this.id,
    this.slug,
    this.name,
  });

  factory ProductBrand.fromJson(Map<String, dynamic> json) => _$ProductBrandFromJson(json);

  Map<String, dynamic> toJson() => _$ProductBrandToJson(this);
}
