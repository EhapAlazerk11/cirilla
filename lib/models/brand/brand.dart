import 'package:cirilla/mixins/utility_mixin.dart' show get;
import 'package:json_annotation/json_annotation.dart';

part 'brand.g.dart';

@JsonSerializable()
class Brand {
  int? id;

  String? name;

  String? slug;

  int? parent;

  String? description;

  int? count;

  @JsonKey(fromJson: _imageFromJson)
  String? image;

  Brand({
    this.id,
    this.name,
    this.count,
    this.image,
    this.description,
    this.parent,
    this.slug,
  });

  static String? _imageFromJson(dynamic value) => get(value, ['src'], '');

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

  Map<String, dynamic> toJson() => _$BrandToJson(this);
}
