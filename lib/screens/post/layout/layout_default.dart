import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/post/post.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:flutter/material.dart';

import '../widgets/post_block.dart';
import '../widgets/post_action.dart';

class LayoutDefault extends StatelessWidget with AppBarMixin, Utility {
  final Post? post;
  final Map<String, dynamic>? styles;
  final Map<String, dynamic>? configs;
  final List<dynamic>? rows;

  LayoutDefault({
    Key? key,
    this.post,
    this.styles,
    this.configs,
    this.rows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          primary: true,
          pinned: true,
          elevation: 0,
          leading: leading(),
          titleSpacing: 20,
          actions: [PostAction(post: post, configs: configs), SizedBox(width: layoutPadding)],
        ),
        SliverToBoxAdapter(
          child: PostBlock(
            post: post,
            rows: rows,
            styles: styles,
          ),
        ),
      ],
    );
  }
}
