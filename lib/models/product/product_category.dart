import 'package:cirilla/mixins/unescape_mixin.dart' show unescape;
import 'package:json_annotation/json_annotation.dart';

part 'product_category.g.dart';

@JsonSerializable()
class ProductCategory {
  int? id;
  String? slug;
  @JsonKey(fromJson: unescape)
  String? name;

  ProductCategory({
    this.id,
    this.slug,
    this.name,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) => _$ProductCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);
}
