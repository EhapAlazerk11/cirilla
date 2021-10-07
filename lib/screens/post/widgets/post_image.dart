import 'package:cirilla/models/models.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:flutter/material.dart';

class PostImage extends StatelessWidget {
  final Post? post;
  final double? width;
  final double? height;

  PostImage({Key? key, this.post, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CirillaCacheImage(
      post!.image,
      width: width,
      height: height,
    );
  }
}
