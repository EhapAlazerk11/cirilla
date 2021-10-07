// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductBrand _$ProductBrandFromJson(Map<String, dynamic> json) {
  return ProductBrand(
    id: json['id'] as int?,
    slug: json['slug'] as String?,
    name: json['name'] as String?,
  );
}

Map<String, dynamic> _$ProductBrandToJson(ProductBrand instance) => <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
    };
