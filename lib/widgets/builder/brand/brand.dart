import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_brand_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'layout/layout_list.dart';
import 'layout/layout_carousel.dart';
import 'layout/layout_grid.dart';
import 'layout/layout_big_first.dart';
import 'layout/layout_masonry.dart';
import 'layout/layout_slideshow.dart';

class BrandWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  BrandWidget({
    Key? key,
    this.widgetConfig,
  }) : super(key: key);

  @override
  _BrandWidgetState createState() => _BrandWidgetState();
}

class _BrandWidgetState extends State<BrandWidget> with CategoryMixin, Utility {
  late AppStore _appStore;
  SettingStore? _settingStore;
  BrandStore? _brandStore;

  @override
  void didChangeDependencies() {
    _appStore = Provider.of<AppStore>(context);
    _settingStore = Provider.of<SettingStore>(context);

    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};

    // Filter
    int limit = ConvertData.stringToInt(get(fields, ['limit'], '4'));

    String? key = StringGenerate.getBrandKeyStore(
      widget.widgetConfig?.id,
      limit: limit,
    );

    // Add store to list store
    if (widget.widgetConfig != null && _appStore.getStoreByKey(key) == null) {
      BrandStore store = BrandStore(
        _settingStore!.requestHelper,
        key: key,
        perPage: limit,
      )..getBrands();
      _appStore.addStore(store);
      _brandStore ??= store;
    } else {
      _brandStore = _appStore.getStoreByKey(key);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String themeModeKey = _settingStore?.themeModeKey ?? 'value';

    // Layout
    String layout = widget.widgetConfig?.layout ?? Strings.brandLayoutList;

    // Styles
    Map<String, dynamic> styles = widget.widgetConfig?.styles ?? {};
    Map margin = get(styles, ['margin'], {});
    Map padding = get(styles, ['padding'], {});
    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);
    double pad = ConvertData.stringToDouble(get(styles, ['pad'], 16));
    double dividerWidth = ConvertData.stringToDouble(get(styles, ['dividerWidth'], 1));
    Color dividerColor = ConvertData.fromRGBA(get(styles, ['dividerColor', themeModeKey], {}), theme.dividerColor);
    double height = ConvertData.stringToDouble(get(styles, ['height'], 200));

    // Fields
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    Map<String, dynamic> template = get(fields, ['template'], {});
    int limit = ConvertData.stringToInt(get(fields, ['limit'], 4));

    return Observer(
      builder: (_) {
        List<Brand> brands = _brandStore!.brands;
        bool loading = _brandStore!.loading;

        List<Brand> emptyBrands = List.generate(limit, (index) => Brand()).toList();
        bool isShimmer = brands.length == 0 && loading;

        return Container(
          margin: ConvertData.space(margin, 'margin'),
          color: background,
          height: layout == Strings.brandLayoutCarousel || layout == Strings.brandLayoutSlideshow ? height : null,
          child: LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              double widthView = constraints.maxWidth;
              return buildLayout(
                layout,
                brands: isShimmer ? emptyBrands : brands,
                heightView: height,
                widthView: widthView,
                pad: pad,
                dividerWidth: dividerWidth,
                dividerColor: dividerColor,
                styles: styles,
                template: template,
                themeModeKey: themeModeKey,
                padding: ConvertData.space(padding, 'padding'),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildLayout(
    String layout, {
    required List<Brand> brands,
    required double heightView,
    required double widthView,
    required double pad,
    required double dividerWidth,
    required Color dividerColor,
    required Map<String, dynamic> styles,
    required Map<String, dynamic> template,
    required String themeModeKey,
    required EdgeInsetsDirectional padding,
  }) {
    switch (layout) {
      case Strings.brandLayoutCarousel:
        double widthView = ConvertData.stringToDouble(get(styles, ['width'], 300), 300);
        return LayoutCarousel(
          brands: brands,
          buildItem: (_, {required Brand brand, required double width, double? height}) {
            return buildItem(
              brand: brand,
              styles: styles,
              width: width,
              height: height,
              template: template,
            );
          },
          pad: pad,
          padding: padding,
          height: heightView,
          width: widthView,
          dividerWidth: dividerWidth,
          dividerColor: dividerColor,
        );
      case Strings.brandLayoutGrid:
        int column = ConvertData.stringToInt(get(styles, ['col'], 2), 2);
        double ratio = ConvertData.stringToDouble(get(styles, ['ratio'], 1), 1);
        return LayoutGrid(
          brands: brands,
          buildItem: (_, {required Brand brand, required double width, double? height}) {
            return buildItem(brand: brand, styles: styles, width: width, height: height, template: template);
          },
          column: column,
          ratio: ratio,
          pad: pad,
          padding: padding,
          widthView: widthView,
          dividerWidth: dividerWidth,
          dividerColor: dividerColor,
        );
      case Strings.brandLayoutBigFirst:
        return LayoutBigFirst(
          brands: brands,
          buildItem: (_, {required Brand brand, required double width, double? height}) {
            return buildItem(brand: brand, styles: styles, width: width, height: height, template: template);
          },
          pad: pad,
          padding: padding,
          widthView: widthView,
          dividerWidth: dividerWidth,
          dividerColor: dividerColor,
        );
      case Strings.brandLayoutMasonry:
        return LayoutMasonry(
          brands: brands,
          buildItem: (_, {required Brand brand, required double width, double? height}) {
            return buildItem(brand: brand, styles: styles, width: width, height: height, template: template);
          },
          pad: pad,
          padding: padding,
          widthView: widthView,
          dividerWidth: dividerWidth,
          dividerColor: dividerColor,
        );
      case Strings.brandLayoutSlideshow:
        Color indicatorColor = ConvertData.fromRGBA(
          get(styles, ['indicatorColor', themeModeKey], {}),
          Theme.of(context).dividerColor,
        );
        Color indicatorActiveColor = ConvertData.fromRGBA(
          get(styles, ['indicatorActiveColor', themeModeKey], {}),
          Theme.of(context).primaryColor,
        );

        return LayoutSlideshow(
          brands: brands,
          buildItem: (_, {required Brand brand, required double width, double? height}) {
            return buildItem(brand: brand, styles: styles, width: width, height: height, template: template);
          },
          indicatorColor: indicatorColor,
          indicatorActiveColor: indicatorActiveColor,
          padding: padding,
          widthView: widthView,
          heightView: heightView,
        );
      default:
        return LayoutList(
          brands: brands,
          buildItem: (_, {required Brand brand, required double width, double? height}) {
            return buildItem(
              brand: brand,
              styles: styles,
              width: width,
              height: height,
              template: template,
            );
          },
          pad: pad,
          padding: padding,
          widthView: widthView,
          dividerWidth: dividerWidth,
          dividerColor: dividerColor,
        );
    }
  }

  Widget buildItem({
    required Brand brand,
    required Map<String, dynamic> styles,
    required double width,
    double? height,
    required Map<String, dynamic> template,
  }) {
    ThemeData theme = Theme.of(context);
    String themeModeKey = _settingStore?.themeModeKey ?? 'value';
    String templateType = get(template, ['template'], Strings.brandItemDefault);
    Map<String, dynamic> templateData = get(template, ['data'], {});
    Color background =
        ConvertData.fromRGBA(get(styles, ['backgroundItem', themeModeKey], {}), theme.colorScheme.surface);
    Color textColor =
        ConvertData.fromRGBA(get(styles, ['textItem', themeModeKey], {}), theme.textTheme.headline6?.color);
    EdgeInsetsDirectional padding = ConvertData.space(get(styles, ['paddingContent'], {}), 'paddingContent');
    double radius = ConvertData.stringToDouble(get(styles, ['radius'], 0));
    Color shadowColor = ConvertData.fromRGBA(get(styles, ['shadowColor', themeModeKey], {}), Colors.transparent);
    double offsetX = ConvertData.stringToDouble(get(styles, ['offsetX'], 0));
    double offsetY = ConvertData.stringToDouble(get(styles, ['offsetY'], 4));
    double blurRadius = ConvertData.stringToDouble(get(styles, ['blurRadius'], 24));
    double spreadRadius = ConvertData.stringToDouble(get(styles, ['spreadRadius'], 0));

    BoxShadow shadow = BoxShadow(
      color: shadowColor,
      offset: Offset(offsetX, offsetY),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
    );

    return CirillaBrandItem(
      brand: brand,
      width: width,
      height: height,
      templateType: templateType,
      templateData: templateData,
      background: background,
      textColor: textColor,
      padding: padding,
      radius: radius,
      boxShadow: [shadow],
    );
  }
}
