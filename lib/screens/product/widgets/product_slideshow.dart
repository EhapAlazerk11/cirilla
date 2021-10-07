import 'dart:convert';
import 'dart:math';

import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/models/product/product_image.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/screens/product/widgets/product_image_popup.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'product_slideshow_pagination.dart';

class ProductSlideshow extends StatefulWidget {
  final List<ProductImage?>? images;
  final Product? product;
  final int scrollDirection;
  final double? width;
  final double? height;
  final String? productGalleryFit;

  final WidgetConfig? configs;

  const ProductSlideshow({
    Key? key,
    this.images,
    this.product,
    this.scrollDirection = 0,
    this.width,
    this.height,
    this.productGalleryFit,
    this.configs,
  }) : super(key: key);

  @override
  _ProductSlideshowState createState() => _ProductSlideshowState();
}

class _ProductSlideshowState extends State<ProductSlideshow> with ProductSlideshowPagination, Utility, LoadingMixin {
  SwiperController _controller = SwiperController();
  List<ProductImage?> _images = [];
  bool _loading = true;

  @override
  void didChangeDependencies() async {
    setState(() {
      _images = widget.product?.images ?? [];
    });
    await _getVideoLinkFromMetaData();
    setState(() {
      _loading = false;
    });
    super.didChangeDependencies();
  }

  /// Get video URL in product meta data
  Future<void> _getVideoLinkFromMetaData() async {
    if (widget.product != null && widget.product!.metaData != null && widget.product!.metaData!.length > 0) {
      // YITH WooCommerce Featured Video
      Map<String, dynamic> video = widget.product!.metaData!.firstWhere(
        (e) => get(e, ['key'], '') == '_video_url',
        orElse: () => {'value': null},
      );
      if (video['value'] != null && video['value'] != '') {
        await _parserVideoUrl(video['value'], featured: true);
      }

      // Rehub theme
      Map<String, dynamic> videosRehubTheme = widget.product!.metaData!.firstWhere(
        (e) => get(e, ['key'], '') == 'rh_product_video',
        orElse: () => {'value': null},
      );
      if (videosRehubTheme['value'] != null && videosRehubTheme['value'] != '') {
        List<String> videos = LineSplitter.split(videosRehubTheme['value']).toList();
        int i = 0;
        if (videos.length > 0) {
          await Future.doWhile(() async {
            await _parserVideoUrl(videos[i], featured: false);
            i++;
            return i < videos.length;
          });
        }
      }

      // Product Video for WooCommerce
      Map<String, dynamic> productVideoForWoo = widget.product!.metaData!.firstWhere(
        (e) => get(e, ['key'], '') == 'afpv_featured_video_type',
        orElse: () => {'value': ''},
      );

      Map<String, dynamic> productVideoForWooFeatured = widget.product!.metaData!.firstWhere(
        (e) => get(e, ['key'], '') == 'afpv_enable_featured_video_product_page',
        orElse: () => {'value': ''},
      );

      String productVideoForWooType = productVideoForWoo['value'];

      // Vimeo
      Map<String, dynamic> productVideoForWooVimeo = widget.product!.metaData!.firstWhere(
        (e) => get(e, ['key'], '') == 'afpv_vm_featured_video_id',
        orElse: () => {'value': ''},
      );

      if (productVideoForWooType == 'vimeo' && productVideoForWooVimeo['value'] != '') {
        await _parserVideoUrl(
          'http://vimeo.com/${productVideoForWooVimeo['value']}',
          featured: productVideoForWooFeatured['value'] == 'yes',
        );
      }

      // Youtube
      Map<String, dynamic> productVideoForWooYoutube = widget.product!.metaData!.firstWhere(
        (e) => get(e, ['key'], '') == 'afpv_yt_featured_video_id',
        orElse: () => {'value': ''},
      );

      if (productVideoForWooType == 'youtube' && productVideoForWooYoutube['value'] != '') {
        await _parserVideoUrl(
          'https://youtu.be/${productVideoForWooYoutube['value']}',
          featured: productVideoForWooFeatured['value'] == 'yes',
        );
      }
    }
  }

  /// Get Id video
  Future<void> _parserVideoUrl(String url, {bool featured = false}) async {
    List<ProductImage?> images = List<ProductImage?>.of(_images);
    // Parser Youtube video
    if (VideoParserUrl.isValidFullYoutubeUrl(url) || VideoParserUrl.isValidSortYoutubeUrl(url)) {
      String? videoId = VideoParserUrl.getYoutubeId(url);
      if (videoId != null) {
        ProductImage image = await _getYoutubeThumb(videoId);
        featured ? images.insert(0, image) : images.add(image);
      }
    } else if (VideoParserUrl.isValidVimeoUrl(url)) {
      String? videoId = VideoParserUrl.getVimeoId(url);
      if (videoId != null) {
        ProductImage? image = await _getVimeoThumb(videoId);
        featured && image != null ? images.insert(0, image) : images.add(image);
      }
    }
    setState(() {
      _images = images;
    });
  }

  Future<ProductImage?> _getVimeoThumb(String videoId) async {
    try {
      final dio = Dio();
      Response response = await dio.get('https://player.vimeo.com/video/$videoId/config');
      Map<String, dynamic> data = response.data;

      String linkBasic = get(data, ['video', 'thumbs', 'base'], Assets.noImageUrl);
      String linkSmall = get(data, ['video', 'thumbs', '960'], Assets.noImageUrl);
      String linkTiny = get(data, ['video', 'thumbs', '640'], Assets.noImageUrl);

      dynamic video = get(data, ['request', 'files', 'progressive'], null);

      return ProductImage(
        id: Random().nextInt(100000),
        src: linkBasic,
        type: 'vimeo',
        video: video[0]['url'],
        name: videoId,
        woocommerceThumbnail: linkSmall,
        woocommerceSingle: linkBasic,
        woocommerceGalleryThumbnail: linkTiny,
        shopCatalog: linkSmall,
        shopSingle: linkBasic,
        shopThumbnail: linkTiny,
      );
    } catch (e) {
      return null;
    }
  }

  Future<ProductImage> _getYoutubeThumb(String videoId) async {
    String linkBasic = 'https://img.youtube.com/vi/$videoId/sddefault.jpg';
    String linkSmall = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    String linkTiny = 'https://img.youtube.com/vi/$videoId/default.jpg';
    return ProductImage(
      id: Random().nextInt(100000),
      src: linkBasic,
      type: 'youtube',
      video: videoId,
      name: videoId,
      woocommerceThumbnail: linkSmall,
      woocommerceSingle: linkBasic,
      woocommerceGalleryThumbnail: linkTiny,
      shopCatalog: linkSmall,
      shopSingle: linkBasic,
      shopThumbnail: linkTiny,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ProductImage?> images = widget.images != null && widget.images!.length > 0 ? widget.images! : _images;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = widget.height == 0 ? screenHeight : (screenWidth * widget.height!) / widget.width!;

    // Indicator
    Map<String, dynamic>? styles = widget.configs!.styles;
    AlignmentDirectional indicatorAlignment =
        ConvertData.toAlignmentDirectional(get(styles, ['indicatorAlignment'], 'bottom-start'));
    Map<String, dynamic>? indicatorMargin = get(styles, ['indicatorMargin'], null);

    if (_loading) {
      return Container(
        height: containerHeight,
        width: screenWidth,
        child: entryLoading(context, size: 24),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: containerHeight, width: screenWidth),
      child: Swiper(
        controller: _controller,
        scrollDirection: Axis.values[widget.scrollDirection],
        itemBuilder: (BuildContext context, int index) {
          ProductImage? image = images[index];
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, _a1, _a2) => ProductImagesPopup(
                          images: images,
                          arguments: ProductImagesPopupArguments(
                            index,
                            _controller,
                          )),
                    ),
                  );
                },
                child: Hero(
                  tag: "product_images_${image!.id}",
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CirillaCacheImage(
                        image.shopSingle,
                        fit: ConvertData.toBoxFit(widget.productGalleryFit),
                        width: screenWidth,
                        height: containerHeight,
                      ),
                      if (image.type == 'youtube' || image.type == 'vimeo') _buildIconPlay(context),
                    ],
                  ),
                ),
              );
            },
          );
        },
        itemCount: images.length,
        pagination: CirillaPaginationSwiper(
          alignment: indicatorAlignment,
          margin: ConvertData.space(indicatorMargin, 'indicatorMargin', EdgeInsetsDirectional.zero),
          builder: _buildPagination(context),
        ),
      ),
    );
  }

  Widget _buildIconPlay(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          // shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white),
        ),
        child: Icon(
          FontAwesomeIcons.play,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  SwiperPlugin _buildPagination(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    // Indicator
    Map<String, dynamic>? styles = widget.configs!.styles;

    String? productGalleryIndicator = get(styles, ['productGalleryIndicator'], 'dot');

    Map<String, dynamic>? indicatorColor = get(styles, ['indicatorColor', themeModeKey], null);
    Map<String, dynamic>? indicatorActiveColor = get(styles, ['indicatorActiveColor', themeModeKey], null);
    double? indicatorSize = ConvertData.stringToDouble(get(styles, ['indicatorSize'], 6));
    double? indicatorActiveSize = ConvertData.stringToDouble(get(styles, ['indicatorActiveSize'], 10));
    double? indicatorSpace = ConvertData.stringToDouble(get(styles, ['indicatorSpace'], 4));

    Color colorIndicator = ConvertData.fromRGBA(indicatorColor, theme.indicatorColor);
    Color colorIndicatorActive = ConvertData.fromRGBA(indicatorActiveColor, theme.indicatorColor);
    double? indicatorBorderRadius = ConvertData.stringToDouble(get(styles, ['indicatorBorderRadius'], 8));

    if (productGalleryIndicator == 'image') {
      return imagePagination(
        images: widget.images!.length > 0 ? widget.images : _images,
        controller: _controller,
        activeColor: colorIndicatorActive,
        size: indicatorSize,
        space: indicatorSpace,
        borderRadius: indicatorBorderRadius,
      );
    }
    if (productGalleryIndicator!.toLowerCase() == 'number') {
      return numberPagination(
        textStyle: theme.textTheme.overline!.apply(color: colorIndicatorActive),
        background: colorIndicator,
        size: indicatorSize,
        space: indicatorSpace,
        borderRadius: indicatorBorderRadius,
      );
    }

    return DotSwiperPaginationBuilder(
      color: colorIndicator,
      activeColor: colorIndicatorActive,
      size: indicatorSize,
      activeSize: indicatorActiveSize,
      space: indicatorSpace,
    );
  }
}
