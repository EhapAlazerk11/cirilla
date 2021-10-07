import 'package:cached_network_image/cached_network_image.dart';
import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class CirillaCacheImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;

  final BoxFit fit;

  final Color color;

  const CirillaCacheImage(
    this.url, {
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isWeb) {
      return ImageLoading(url!, width: width!, height: height!, fit: fit, color: color);
    }

    return CachedNetworkImage(
      imageUrl: url != null && url!.isNotEmpty ? url! : Assets.noImageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        color: color,
        width: width,
        height: height,
      ),
      errorWidget: (context, url, error) => Image.network(
        Assets.noImageUrl,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
