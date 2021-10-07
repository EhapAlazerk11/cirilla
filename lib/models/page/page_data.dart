import 'package:json_annotation/json_annotation.dart';
part 'page_data.g.dart';

@JsonSerializable()
class PageData {
  int? id;

  String? date;

  String? modified;

  String? slug;

  String? status;

  String? type;

  int? author;

  int? parent;

  List<dynamic>? blocks;

  PageData({
    this.id,
    this.date,
    this.modified,
    this.slug,
    this.status,
    this.type,
    this.author,
    this.parent,
    this.blocks,
  });

  factory PageData.fromJson(Map<String, dynamic> json) => _$PageDataFromJson(json);

  Map<String, dynamic> toJson() => _$PageDataToJson(this);
}
