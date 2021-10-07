import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';

class LayoutSlideshow extends StatefulWidget {
  final List<Post>? posts;
  final BuildItemPostType? buildItem;
  final Color? indicatorColor;
  final Color? indicatorActiveColor;
  final EdgeInsetsDirectional padding;

  LayoutSlideshow({
    Key? key,
    this.posts,
    this.buildItem,
    this.indicatorColor,
    this.indicatorActiveColor,
    this.padding = EdgeInsetsDirectional.zero,
  }) : super(key: key);

  @override
  _LayoutSlideshowState createState() => _LayoutSlideshowState();
}

class _LayoutSlideshowState extends State<LayoutSlideshow> {
  int pagination = 0;

  void changePagination(int value) {
    setState(() {
      pagination = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.padding,
        child: LayoutBuilder(
          builder: (_, BoxConstraints constraints) {
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;
            return Swiper(
              itemWidth: width,
              itemHeight: height,
              containerWidth: width,
              containerHeight: height,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: width,
                  child: widget.buildItem!(
                    context,
                    post: widget.posts![index],
                    index: index,
                    widthView: width,
                  ),
                );
              },
              itemCount: widget.posts!.length,
              curve: Curves.linear,
              pagination: SwiperPagination(
                margin: EdgeInsets.all(14),
                builder: DotSwiperPaginationBuilder(
                  space: 4,
                  activeSize: 6,
                  size: 6,
                  color: widget.indicatorColor,
                  activeColor: widget.indicatorActiveColor,
                ),
              ),
              // onIndexChanged: (int value) => changePagination(value),
            );
          },
        ));
  }
}
