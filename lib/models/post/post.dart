import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/models/models.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cirilla/mixins/unescape_mixin.dart' show unescape;

import 'post_category.dart';
import 'post_title.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  int? id;

  int? author;

  @JsonKey(name: 'post_title', fromJson: unescape)
  String? postTitle;

  PostTitle? title;

  PostTitle? excerpt;

  PostTitle? content;

  String? date;

  String? link;

  String? type;

  String? format;

  @JsonKey(fromJson: _imageFromJson)
  String? image;

  @JsonKey(fromJson: _imageFromJson)
  String? thumb;

  @JsonKey(name: 'thumb_medium', fromJson: _imageFromJson)
  String? thumbMedium;

  List<int>? tags;

  @JsonKey(name: 'post_categories', fromJson: _toList)
  List<PostCategory>? postCategories;

  @JsonKey(name: 'post_tags')
  List<PostTag>? postTags;

  @JsonKey(name: 'post_comment_count')
  int? postCommentCount;

  @JsonKey(name: 'post_author')
  String? postAuthor;

  @JsonKey(name: 'post_author_avatar_urls')
  AvatarAuthor? postAuthorImage;

  List<dynamic>? blocks;

  Post({
    this.id,
    this.author,
    this.title,
    this.excerpt,
    this.content,
    this.date,
    this.link,
    this.format,
    this.image,
    this.thumb,
    this.tags,
    this.postCategories,
    this.postTags,
    this.postCommentCount,
    this.postAuthor,
    this.postAuthorImage,
    this.blocks,
  });

  static String _imageFromJson(dynamic value) =>
      value == null || value == false || value == "" ? Assets.noImageUrl : value as String;

  static List<PostCategory> _toList(List<dynamic>? data) {
    List<PostCategory> _categories = <PostCategory>[];

    if (data == null) return _categories;

    _categories = data.map((d) => PostCategory.fromJson(d)).toList().cast<PostCategory>();

    return _categories;
  }

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

@JsonSerializable()
class AvatarAuthor {
  @JsonKey(name: '24')
  String? small;
  @JsonKey(name: '48')
  String? medium;
  @JsonKey(name: '96')
  String? large;

  AvatarAuthor({
    this.small,
    this.medium,
    this.large,
  });

  factory AvatarAuthor.fromJson(Map<String, dynamic> json) => _$AvatarAuthorFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarAuthorToJson(this);
}

class PostBlocks {
  PostBlocks._();

  static const String Category = 'Category';
  static const String Name = 'Name';
  static const String Date = 'Date';
  static const String Author = 'Author';
  static const String CountComment = 'CountComment';
  static const String NavigateComment = 'NavigateComment';
  static const String Wishlist = 'Wishlist';
  static const String Share = 'Share';
  static const String FeatureImage = 'FeatureImage';
  static const String Content = 'Content';
  static const String Tag = 'Tag';
  static const String Comments = 'Comments';
}
