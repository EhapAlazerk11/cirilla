import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product/product_image.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FeaturedImage extends StatefulWidget {
  final List<ProductImage?>? images;
  final double? width;
  final double? height;

  const FeaturedImage({
    Key? key,
    this.images,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  _FeaturedImageState createState() => _FeaturedImageState();
}

class _FeaturedImageState extends State<FeaturedImage> with Utility {
  @override
  Widget build(BuildContext context) {
    List<ProductImage?> images = widget.images!;
    return CirillaCacheImage(
      images.length > 0 ? images[0]!.shopCatalog : Assets.noImageUrl,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }
}
