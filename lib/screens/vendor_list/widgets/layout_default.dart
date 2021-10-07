import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_vendor_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui/tab/sticky_tab_bar_delegate.dart';

import 'view_list.dart';
import 'view_grid.dart';

class LayoutDefault extends StatelessWidget with AppBarMixin, LoadingMixin, Utility {
  final int? typeView;
  final Widget? header;
  final bool? loading;
  final List<Vendor>? vendors;
  final VendorStore? vendorStore;
  final ScrollController? controller;
  final Map<String, dynamic>? configs;

  LayoutDefault({
    Key? key,
    this.typeView,
    this.header,
    this.loading,
    this.vendorStore,
    this.vendors,
    this.controller,
    this.configs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);
    bool? enableCenterTitle = get(configs, ['enableCenterTitle'], true);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: controller,
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              title: Text(translate('vendor_list_txt')!, style: theme.appBarTheme.titleTextStyle),
              centerTitle: enableCenterTitle,
              elevation: 0,
              primary: false,
              floating: false,
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: StickyTabBarDelegate(
                child: Container(
                  color: theme.colorScheme.surface,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: header,
                ),
              ),
            ),
            CupertinoSliverRefreshControl(
              onRefresh: vendorStore!.refresh,
              builder: buildAppRefreshIndicator,
            ),
            SliverToBoxAdapter(
              child: buildView(vendors, theme, typeView),
            ),
            if (loading!)
              SliverToBoxAdapter(
                child: buildLoading(context, isLoading: vendorStore!.canLoadMore),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildView(List<Vendor>? vendors, ThemeData theme, int? viewType) {
    String layout = 'list';
    String templateItem = Strings.vendorItemGradient;
    double padItem = 16;
    Color colorItem = theme.colorScheme.surface;

    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 20, vertical: 24);

    switch (viewType) {
      case 1:
        templateItem = Strings.vendorItemContained;
        layout = 'grid';
        break;
      case 2:
        templateItem = Strings.vendorItemEmerge;
        padItem = 24;
        colorItem = theme.cardColor;
        break;
      case 3:
        templateItem = Strings.vendorItemHorizontal;
        break;
    }

    switch (layout) {
      case 'grid':
        return ViewGrid(
          length: vendors!.length,
          pad: padItem,
          padding: padding,
          buildItem: ({required int index, double? widthItem}) => buildItem(
            vendor: vendors.elementAt(index),
            widthItem: widthItem,
            template: templateItem,
            color: colorItem,
          ),
        );
      default:
        return ViewList(
          length: vendors!.length,
          pad: padItem,
          padding: padding,
          buildItem: ({required int index, double? widthItem}) => buildItem(
            vendor: vendors.elementAt(index),
            widthItem: widthItem,
            template: templateItem,
            color: colorItem,
          ),
        );
    }
  }

  Widget buildItem({Vendor? vendor, double? widthItem, String? template, Color? color}) {
    return CirillaVendorItem(
      vendor: vendor,
      template: template,
      widthItem: widthItem,
      color: color,
    );
  }
}
