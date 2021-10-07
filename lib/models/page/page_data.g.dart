// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageData _$PageDataFromJson(Map<String, dynamic> json) {
  return PageData(
    id: json['id'] as int?,
    date: json['date'] as String?,
    modified: json['modified'] as String?,
    slug: json['slug'] as String?,
    status: json['status'] as String?,
    type: json['type'] as String?,
    author: json['author'] as int?,
    parent: json['parent'] as int?,
    blocks: json['blocks'] as List<dynamic>?,
  );
}

Map<String, dynamic> _$PageDataToJson(PageData instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'modified': instance.modified,
      'slug': instance.slug,
      'status': instance.status,
      'type': instance.type,
      'author': instance.author,
      'parent': instance.parent,
      'blocks': instance.blocks,
    };
