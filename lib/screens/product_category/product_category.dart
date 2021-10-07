import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product_category/product_category.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/store/product_category/product_category_store.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'widgets/body_horizontal.dart';
import 'widgets/body_vertical.dart';
import 'widgets/body_default.dart';

class ProductCategoryScreen extends StatefulWidget {
  static const routeName = '/product_category';

  @override
  _ProductCategoryScreenState createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> with LoadingMixin, Utility {
  late ProductCategoryStore _productCategoryStore;
  SettingStore? _settingStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productCategoryStore = Provider.of<ProductCategoryStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
  }

  List<ProductCategory> excludeData(List<ProductCategory> categories, List exclude) {
    if (exclude.length < 1) {
      return categories;
    }
    return categories
        .where((category) =>
            exclude.where((element) => ConvertData.stringToInt(element['key']) == category.id).toList().length < 1)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final String languageKey = _settingStore?.languageKey ?? 'text';
        final String themeModeKey = _settingStore?.themeModeKey ?? 'value';

        final WidgetConfig widgetConfig = _settingStore!.data!.screens!['category']!.widgets!['categoryPage']!;
        final Map<String, dynamic>? configs = _settingStore!.data!.screens!['category']!.configs;

        final List excludeCategory = get(widgetConfig.fields, ['excludeCategory'], []);

        String layout = widgetConfig.layout ?? 'vertical';

        List<ProductCategory> categories = excludeData(_productCategoryStore.categories, excludeCategory);

        if (_productCategoryStore.loading) {
          return buildLoading(context, isLoading: true);
        }
        EdgeInsetsDirectional padding = ConvertData.space(get(widgetConfig.styles, ['padding'], {}), 'padding');
        EdgeInsetsDirectional margin = ConvertData.space(get(widgetConfig.styles, ['margin'], {}), 'margin');

        Widget child;
        switch (layout) {
          case 'horizontal':
            child = HorizontalCategory(
              categories: categories,
              configs: configs,
              widgetConfig: widgetConfig,
              languageKey: languageKey,
              themeModeKey: themeModeKey,
            );
            break;
          case 'vertical':
            child = VerticalCategory(
              categories: categories,
              configs: configs,
              widgetConfig: widgetConfig,
              languageKey: languageKey,
              themeModeKey: themeModeKey,
            );
            break;
          default:
            child = DefaultCategory(
              categories: categories,
              configs: configs,
              widgetConfig: widgetConfig,
              languageKey: languageKey,
              themeModeKey: themeModeKey,
            );
        }
        return Container(
          padding: padding,
          margin: margin,
          child: child,
        );
      },
    );
  }
}
