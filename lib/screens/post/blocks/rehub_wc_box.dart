import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:ui/ui.dart';
import 'package:cirilla/extension/strings.dart';

class RehubWcBox extends StatefulWidget {
  final Map<String, dynamic>? block;

  RehubWcBox({
    Key? key,
    this.block,
  }) : super(key: key);

  @override
  _RehubWcBoxState createState() => _RehubWcBoxState();
}

class _RehubWcBoxState extends State<RehubWcBox> with Utility, SingleTickerProviderStateMixin, WishListMixin {
  TabController? _tabController;
  final List<String> data = ['product', 'specifiction', 'photo', 'videos'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: data.length);
  }

  void goDetail(BuildContext context, int productId) {
    Navigator.of(context).pushNamed(ProductScreen.routeName, arguments: {
      'id': productId,
    });
  }

  ///
  /// Handle wishlist
  void _wishlist(BuildContext context, int productId) {
    addWishList(productId: productId);
  }

  Widget buildViewInfo(BuildContext context, {Map? attrs, String? type, double? width}) {
    ThemeData theme = Theme.of(context);

    List<Widget> children = [];

    switch (type) {
      case 'product':
        String? imageUrl = get(attrs, ['imageUrl'], '');
        String productName = get(attrs, ['productName'], '');
        String description = get(attrs, ['description'], '');
        double? regularPrice = ConvertData.stringToDouble(get(attrs, ['regularPrice'], 0), 0);
        double? salePrice = ConvertData.stringToDouble(get(attrs, ['salePrice'], 0), 0);
        String? currencySymbol = get(attrs, ['currencySymbol'], '&#36;');
        String priceLabel = get(attrs, ['priceLabel'], '');
        String addToCartText = get(attrs, ['addToCartText'], 'Buy product');
        String brandList = get(attrs, ['brandList'], '');

        HtmlUnescape unescape = new HtmlUnescape();
        int productId = ConvertData.stringToInt(get(attrs, ['productId'], 0));
        bool selectWishlist = existWishList(productId: productId);

        Widget priceWidget = Wrap(
          spacing: 10,
          runSpacing: 4,
          children: [
            Text(
              unescape.convert('$currencySymbol $salePrice'),
              style: theme.textTheme.subtitle2!.copyWith(color: Color(0xFFF01F0E)),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(end: 8),
              child: Text(
                unescape.convert('$currencySymbol $regularPrice'),
                style: theme.textTheme.subtitle2!.copyWith(
                  color: theme.textTheme.bodyText2!.color,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
            Badge(
              text: Text(
                priceLabel,
                style: theme.textTheme.overline!.copyWith(fontWeight: FontWeight.w500),
              ),
              color: Color(0xFFF01F0E),
            )
          ],
        );
        // description.
        children.add(
          WoocommerceBoxProductItem(
            image: GestureDetector(
              onTap: () => goDetail(context, productId),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CirillaCacheImage(
                  imageUrl,
                  width: 86,
                  height: 102,
                ),
              ),
            ),
            name: GestureDetector(
              onTap: () => goDetail(context, productId),
              child: Text(productName, style: theme.textTheme.subtitle1),
            ),
            price: priceWidget,
            description: Text(description.replaceAll(new RegExp(r"\s+\b|\b\s"), " "), style: theme.textTheme.caption),
            button: SizedBox(
              height: 34,
              width: double.infinity,
              child: ElevatedButton(
                child: Text(addToCartText.capitalizeFirstofEach),
                onPressed: () => goDetail(context, productId),
              ),
            ),
            band: Row(
              children: [
                Expanded(child: Text(brandList, style: theme.textTheme.caption)),
                InkWell(
                  child: Icon(FeatherIcons.shuffle, size: 16),
                ),
                SizedBox(
                  height: 18,
                  child: VerticalDivider(
                    width: 64,
                    color: theme.dividerColor,
                  ),
                ),
                InkWell(
                    onTap: () => _wishlist(context, productId),
                    child: Icon(selectWishlist ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, size: 16)),
              ],
            ),
            color: theme.colorScheme.surface,
            width: width,
          ),
        );
        break;
      case 'specifiction':
        dynamic productAttributes = get(attrs, ['productAttributes'], '');

        if (productAttributes is String && productAttributes.isNotEmpty) {
          double? fontSize = theme.textTheme.bodyText2!.fontSize;

          Style styleTag = Style(
            lineHeight: LineHeight(1.8),
            fontSize: FontSize(fontSize),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            color: theme.colorScheme.onSurface,
          );
          children.add(ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Html(
              data: productAttributes,
              style: {
                'html': styleTag.copyWith(backgroundColor: theme.colorScheme.surface),
                'body': styleTag,
                'p': styleTag.copyWith(margin: EdgeInsets.only(left: 10)),
                'div': styleTag,
                // 'img': styleTag,
                'table': Style(
                  padding: EdgeInsets.all(16),
                ),
                'th': Style(
                  alignment: Alignment.topRight,
                  fontWeight: FontWeight.w900,
                  color: theme.textTheme.subtitle1!.color,
                ),
                'td': Style(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                ),
              },
            ),
          ));
        } else {
          children.add(Container());
        }
        break;
      case 'photo':
        List galleryImages = get(attrs, ['galleryImages'], []);
        double widthImage = (width! - 2 * 16 - 2 * 16) / 3;
        double heightImage = (widthImage * 55) / 100;

        children.add(
          buildBox(
            theme: theme,
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                galleryImages.length,
                (index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, _a1, _a2) => ProductPhotoPopup(
                          images: galleryImages,
                          visit: index,
                        ),
                      ),
                    );
                  },
                  child: CirillaCacheImage(
                    galleryImages[index] is String ? galleryImages[index] : '',
                    width: widthImage,
                    height: heightImage,
                  ),
                ),
              ),
            ),
          ),
        );
        break;
      default:
        children.add(Container());
        break;
    }
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: children,
    );
  }

  Widget buildBox({
    Widget? child,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Map? attrs = get(widget.block, ['attrs'], {}) is Map ? get(widget.block, ['attrs'], {}) : {};

    int productId = ConvertData.stringToInt(get(attrs, ['productId'], -1), -1);
    if (productId == -1) {
      return Container();
    }
    return Theme(
      data: theme.copyWith(splashColor: Colors.transparent),
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          double maxWidth = constraints.maxWidth;
          double screenWidth = MediaQuery.of(context).size.width;
          double itemWidth = maxWidth is double && maxWidth != double.infinity ? maxWidth : screenWidth;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                labelPadding: EdgeInsetsDirectional.only(end: 32),
                isScrollable: true,
                labelColor: theme.primaryColor,
                controller: _tabController,
                labelStyle: theme.textTheme.subtitle2,
                unselectedLabelColor: theme.textTheme.subtitle2!.color,
                indicatorWeight: 2,
                indicatorColor: theme.primaryColor,
                indicatorPadding: EdgeInsetsDirectional.only(end: 32),
                tabs: List.generate(
                  data.length,
                  (inx) => Container(
                    height: 33,
                    alignment: Alignment.center,
                    child: Text(
                      data[inx].toUpperCase(),
                    ),
                  ),
                ).toList(),
              ),
              SizedBox(height: 24),
              SizedBox(
                height: 275,
                child: TabBarView(
                  controller: _tabController,
                  children: List.generate(
                    data.length,
                    (index) => buildViewInfo(context, attrs: attrs, type: data[index], width: itemWidth),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProductPhotoPopup extends StatefulWidget {
  final List? images;
  final int? visit;

  ProductPhotoPopup({
    Key? key,
    this.images,
    this.visit,
  }) : super(key: key);

  @override
  _ProductPhotoPopup createState() => _ProductPhotoPopup();
}

class _ProductPhotoPopup extends State<ProductPhotoPopup> {
  int _current = 0;
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    int visit = widget.visit ?? 0;
    setState(() {
      _current = visit;
    });
    pageController = PageController(initialPage: visit);
  }

  void onPageChanged(int index) {
    setState(() {
      _current = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double top = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.images!.length,
              onPageChanged: onPageChanged,
              pageController: pageController,
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                  ),
                ),
              ),
            ),
            Positioned(
              top: top - 18 > 0 ? top - 18 : top,
              right: 10,
              left: 10,
              child: Row(
                children: [
                  Container(
                    width: 48,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${_current + 1}/${widget.images!.length}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        FeatherIcons.x,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    dynamic image = widget.images![index];
    String url = image is String ? image : Assets.noImageUrl;

    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(url),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
    );
  }
}
