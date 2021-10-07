import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/post/post.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/screens/post/widgets/post_action.dart';
import 'package:cirilla/screens/post/widgets/post_image.dart';
import 'package:flutter/material.dart';

import '../widgets/post_block.dart';

class LayoutOverlay extends StatelessWidget with AppBarMixin {
  final Post? post;
  final Map<String, dynamic>? styles;
  final Map<String, dynamic>? configs;
  final List<dynamic>? rows;

  LayoutOverlay({
    Key? key,
    this.post,
    this.styles,
    this.configs,
    this.rows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List rowHeader = rows != null ? rows!.where((e) => get(e, ['data', 'visit'], 'content') == 'header').toList() : [];
    List rowContent = rows != null ? rows!.where((e) => get(e, ['data', 'visit'], 'content') != 'header').toList() : [];

    return CustomScrollView(
      slivers: [
        buildAppbar(context, rowHeader),
        SliverToBoxAdapter(
          child: PostBlock(post: post, rows: rowContent, styles: styles),
        ),
      ],
    );
  }

  Widget buildAppbar(BuildContext context, List<dynamic> rowHeader) {
    double paddingTop = MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    double height = (width * 324) / 376;

    return SliverAppBar(
      expandedHeight: height - paddingTop,
      stretch: true,
      leadingWidth: 58,
      leading: Padding(
        padding: EdgeInsetsDirectional.only(start: layoutPadding),
        child: leadingPined(),
      ),
      actions: [PostAction(post: post, color: Colors.white, configs: configs), SizedBox(width: layoutPadding)],
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
        ],
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            PostImage(post: post, width: width, height: height),
            Positioned(
              child: Opacity(
                opacity: 0.7,
                child: Container(width: width, height: height, color: Colors.black),
              ),
            ),
            Positioned(
              child: PostBlock(post: post, rows: rowHeader, styles: styles, color: Colors.white),
              bottom: 0,
              left: 0,
              right: 0,
            ),
          ],
        ),
      ),
    );
  }
}
