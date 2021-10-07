import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CirillaPaginationSwiper extends SwiperPlugin {
  /// AlignmentDirectional.bottomCenter by default when scrollDirection== Axis.horizontal
  /// AlignmentDirectional.centerRight by default when scrollDirection== Axis.vertical
  final AlignmentDirectional? alignment;

  /// Distance between pagination and the container
  final EdgeInsetsGeometry margin;

  /// Build the widet
  final SwiperPlugin builder;

  final Key? key;

  const CirillaPaginationSwiper({
    this.alignment,
    this.key,
    this.margin: const EdgeInsets.all(10.0),
    this.builder: const DotSwiperPaginationBuilder(),
  });

  Widget build(BuildContext context, SwiperPluginConfig config) {
    AlignmentDirectional alignment = this.alignment ??
        (config.scrollDirection == Axis.horizontal
            ? AlignmentDirectional.bottomCenter
            : AlignmentDirectional.centerEnd);
    Widget child = Container(
      margin: margin,
      child: this.builder.build(context, config),
    );
    if (!config.outer!) {
      child = new Align(
        key: key,
        alignment: alignment,
        child: child,
      );
    }
    return child;
  }
}
