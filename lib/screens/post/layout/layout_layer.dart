import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/post/post.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/screens/post/widgets/post_action.dart';
import 'package:cirilla/screens/post/widgets/post_image.dart';
import 'package:flutter/material.dart';

import '../widgets/post_block.dart';

class LayoutLayer extends StatelessWidget with AppBarMixin {
  final Post? post;
  final Map<String, dynamic>? styles;
  final Map<String, dynamic>? configs;
  final List<dynamic>? rows;

  LayoutLayer({
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

    Map<String, dynamic>? rowHeaderFirst = rowHeader.isNotEmpty ? rowHeader[0] : null;
    if (rowHeaderFirst != null) {
      rowHeader.removeAt(0);
    }

    return CustomScrollView(
      slivers: [
        buildAppbar(context, rowHeaderFirst),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: PostBlock(post: post, styles: styles, rows: rowHeader),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: PostBlock(post: post, styles: styles, rows: rowContent),
          ),
        ),
      ],
    );
  }

  Widget buildAppbar(BuildContext context, Map<String, dynamic>? item) {
    double width = MediaQuery.of(context).size.width;
    double paddingTop = MediaQuery.of(context).padding.top;
    double height = (width * 292) / 376;

    return SliverAppBar(
      expandedHeight: height - paddingTop,
      stretch: true,
      leadingWidth: 58,
      leading: Padding(
        padding: EdgeInsetsDirectional.only(start: layoutPadding),
        child: leadingPined(),
      ),
      actions: [PostAction(post: post, configs: configs)],
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
              child: item != null
                  ? Container(
                      width: width,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: PostBlock(post: post, styles: styles, rows: [item]),
                    )
                  : Container(
                      width: width,
                      height: 51,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
              bottom: -1,
              left: layoutPadding,
              right: layoutPadding,
            ),
          ],
        ),
      ),
    );
  }
}
