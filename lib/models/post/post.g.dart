// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    id: json['id'] as int?,
    author: json['author'] as int?,
    title: json['title'] == null ? null : PostTitle.fromJson(json['title'] as Map<String, dynamic>),
    excerpt: json['excerpt'] == null ? null : PostTitle.fromJson(json['excerpt'] as Map<String, dynamic>),
    content: json['content'] == null ? null : PostTitle.fromJson(json['content'] as Map<String, dynamic>),
    date: json['date'] as String?,
    link: json['link'] as String?,
    format: json['format'] as String?,
    image: Post._imageFromJson(json['image']),
    thumb: Post._imageFromJson(json['thumb']),
    tags: (json['tags'] as List<dynamic>?)?.map((e) => e as int).toList(),
    postCategories: Post._toList(json['post_categories'] as List?),
    postTags: (json['post_tags'] as List<dynamic>?)?.map((e) => PostTag.fromJson(e as Map<String, dynamic>)).toList(),
    postCommentCount: json['post_comment_count'] as int?,
    postAuthor: json['post_author'] as String?,
    postAuthorImage: json['post_author_avatar_urls'] == null
        ? null
        : AvatarAuthor.fromJson(json['post_author_avatar_urls'] as Map<String, dynamic>),
    blocks: json['blocks'] as List<dynamic>?,
  )
    ..postTitle = unescape(json['post_title'])
    ..type = json['type'] as String?
    ..thumbMedium = Post._imageFromJson(json['thumb_medium']);
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'post_title': instance.postTitle,
      'title': instance.title,
      'excerpt': instance.excerpt,
      'content': instance.content,
      'date': instance.date,
      'link': instance.link,
      'type': instance.type,
      'format': instance.format,
      'image': instance.image,
      'thumb': instance.thumb,
      'thumb_medium': instance.thumbMedium,
      'tags': instance.tags,
      'post_categories': instance.postCategories,
      'post_tags': instance.postTags,
      'post_comment_count': instance.postCommentCount,
      'post_author': instance.postAuthor,
      'post_author_avatar_urls': instance.postAuthorImage,
      'blocks': instance.blocks,
    };

AvatarAuthor _$AvatarAuthorFromJson(Map<String, dynamic> json) {
  return AvatarAuthor(
    small: json['24'] as String?,
    medium: json['48'] as String?,
    large: json['96'] as String?,
  );
}

Map<String, dynamic> _$AvatarAuthorToJson(AvatarAuthor instance) => <String, dynamic>{
      '24': instance.small,
      '48': instance.medium,
      '96': instance.large,
    };
