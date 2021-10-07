import 'dart:math' as math;
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/post/post.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/screens/post/widgets/post_action.dart';
import 'package:cirilla/screens/post/widgets/post_image.dart';
import 'package:flutter/material.dart';
import 'package:ui/paths/curve_convex.dart';

import '../widgets/post_block.dart';

class LayoutCurveTop extends StatelessWidget with AppBarMixin {
  final Post? post;
  final Map<String, dynamic>? styles;
  final Map<String, dynamic>? configs;
  final List<dynamic>? rows;

  LayoutCurveTop({
    Key? key,
    this.post,
    this.styles,
    this.configs,
    this.rows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        buildAppbar(context),
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

  Widget buildAppbar(BuildContext context) {
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
      actions: [PostAction(post: post, configs: configs), SizedBox(width: layoutPadding)],
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
              child: Transform.rotate(
                angle: -math.pi,
                child: ClipPath(
                  clipper: CurveInConvex(),
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
              bottom: -1,
              left: 0,
              right: 0,
            ),
          ],
        ),
      ),
    );
  }
}
