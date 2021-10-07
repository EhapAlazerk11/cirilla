import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/post/blocks/core_paragraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../blocks/blocks.dart';

class PostContent extends StatelessWidget {
  final Post? post;

  PostContent({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (post!.blocks == null) {
      return Html(
        data: post?.content?.rendered ?? '',
        style: styleBlog(),
      );
    }

    return Column(
      children: List.generate(post!.blocks!.length, (index) {
        if (index == post!.blocks!.length - 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostBlock(block: post!.blocks![index]),
              SizedBox(height: 50),
              Divider(
                height: 1,
                thickness: 1,
              ),
            ],
          );
        }
        return PostBlock(block: post!.blocks![index]);
      }),
    );
  }
}
