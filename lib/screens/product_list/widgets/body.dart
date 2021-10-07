import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/brand/brand.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/models/product_category/product_category.dart';
import 'package:cirilla/screens/product_list/widgets/product_list.dart';
import 'package:cirilla/screens/search/product_search.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/cirilla_cart_icon.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class Body extends StatefulWidget {
  final List<Product>? products;
  final bool? loading;
  final bool? canLoadMore;
  final Function? refresh;
  final Function? getProducts;

  final Widget? heading;
  final Widget? filter;

  final ProductCategory? category;
  final Brand? brand;

  final Map<String, dynamic>? configs;

  final Map<String, dynamic>? styles;
  final double heightHeading;
  final int typeView;

  const Body({
    Key? key,
    this.products,
    this.loading,
    this.refresh,
    this.getProducts,
    this.canLoadMore,
    this.heading,
    this.filter,
    this.category,
    this.brand,
    this.configs,
    this.styles,
    this.heightHeading = 58,
    this.typeView = 0,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with LoadingMixin, AppBarMixin, HeaderListMixin {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients || widget.loading! || !widget.canLoadMore!) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      widget.getProducts!();
    }
  }

  Widget buildAppbar(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    bool enableCart = get(widget.configs, ['enableAppbarCart'], true);
    bool enableCenterTitle = get(widget.configs, ['enableCenterTitle'], true);
    String? appBarType = get(widget.configs, ['appBarType'], Strings.appbarFloating);
    // bool extendBodyBehindAppBar = get(widget.configs, ['extendBodyBehindAppBar'], true);
    bool enableAppbarCountProduct = get(widget.configs, ['enableAppbarCountProduct'], true);
    bool? enableAppbarSearch = get(widget.configs, ['enableAppbarSearch'], false);

    int? countBrand = widget.brand?.count;
    int countCategory = widget.category?.count ?? -1;
    int countItems = countBrand ?? countCategory;
    String translateCount = countItems > 2 ? 'product_list_items' : 'product_list_item';

    String? nameBrand = widget.brand?.name;
    String nameCategory = widget.category?.name ?? translate('product_list_products')!;
    String name = nameBrand ?? nameCategory;

    Widget title = Column(
      crossAxisAlignment: enableCenterTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(name),
        if (enableAppbarCountProduct && countItems > -1)
          Text(
            translate(translateCount, {'count': '$countItems'})!,
            style: Theme.of(context).textTheme.caption,
          ),
      ],
    );

    List<Widget> actions = enableCart || enableAppbarSearch!
        ? [
            if (enableAppbarSearch!)
              InkResponse(
                onTap: () async {
                  await showSearch<String?>(
                    context: context,
                    delegate: ProductSearchDelegate(context, translate),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    FeatherIcons.search,
                    size: 22,
                  ),
                ),
              ),
            if (enableCart) CirillaCartIcon(),
            SizedBox(width: 12),
          ]
        : [Container()];
    return SliverAppBar(
      leading: leading(),
      title: title,
      floating: appBarType == Strings.appbarFloating,
      elevation: 0,
      primary: true,
      centerTitle: enableCenterTitle,
      actions: actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      controller: _controller,
      slivers: [
        buildAppbar(context),
        SliverPersistentHeader(
          pinned: false,
          floating: true,
          delegate: StickyTabBarDelegate(child: widget.heading!, height: widget.heightHeading),
        ),
        if (widget.filter is Widget) widget.filter ?? SliverToBoxAdapter(),
        CupertinoSliverRefreshControl(
          onRefresh: widget.refresh as Future<void> Function()?,
          builder: buildAppRefreshIndicator,
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
          sliver: ProductListLayout(
            products: widget.products,
            typeView: widget.typeView,
            styles: widget.styles,
          ),
        ),
        if (widget.loading!)
          SliverToBoxAdapter(
            child: buildLoading(context, isLoading: widget.canLoadMore!),
          ),
      ],
    );
  }
}
