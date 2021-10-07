import 'package:cirilla/constants/app.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'widgets/layout_default.dart';
import 'widgets/layout_map.dart';

import 'widgets/sort.dart';
import 'widgets/refine.dart';

class VendorListScreen extends StatefulWidget {
  const VendorListScreen({Key? key}) : super(key: key);

  @override
  _VendorListScreenState createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> with ShapeMixin, Utility, AppBarMixin, HeaderListMixin {
  final ScrollController _controller = ScrollController();
  VendorStore? _vendorStore;
  SettingStore? _settingStore;
  int typeView = 0;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    WidgetConfig? widgetConfig = _settingStore!.data!.screens!['vendorList'] != null
        ? _settingStore!.data!.screens!['vendorList']!.widgets!['vendorListPage']
        : null;
    String lang = _settingStore?.locale ?? defaultLanguage;
    int itemPerPage =
        widgetConfig != null ? ConvertData.stringToInt(get(widgetConfig.fields, ['itemPerPage'], 10), 10) : 10;

    _vendorStore = VendorStore(_settingStore!.requestHelper, perPage: itemPerPage, lang: lang, sort: {
      'key': 'vendor_list_date_asc',
      'query': {
        'orderby': 'date',
        'order': 'asc',
      }
    });
    _vendorStore!.getVendors();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (!_controller.hasClients || _vendorStore!.loading || !_vendorStore!.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _vendorStore!.getVendors();
    }
  }

  void _onChange(int value) {
    setState(() {
      typeView = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetConfig? widgetConfig = _settingStore!.data!.screens!['vendorList'] != null
        ? _settingStore!.data!.screens!['vendorList']!.widgets!['vendorListPage']
        : null;
    Map<String, dynamic>? configs = _settingStore!.data!.screens!['vendorList'] != null
        ? _settingStore!.data!.screens!['vendorList']!.configs
        : null;
    String? layout = widgetConfig != null ? widgetConfig.layout : 'default';

    return Observer(builder: (_) {
      bool loading = _vendorStore!.loading;
      List<Vendor> vendors = _vendorStore!.vendors;
      List<Vendor> emptyVendor = List.generate(_vendorStore!.perPage, (index) => Vendor());
      bool isShimmer = _vendorStore!.vendors.length == 0 && loading;
      switch (layout) {
        case 'map':
          return LayoutMap(
            header: buildHeader(context, _vendorStore),
            typeView: typeView,
            loading: loading,
            vendors: loading ? emptyVendor : vendors,
            vendorStore: _vendorStore,
            controller: _controller,
          );
        default:
          return LayoutDefault(
            header: buildHeader(context, _vendorStore),
            typeView: typeView,
            loading: loading,
            vendors: isShimmer ? emptyVendor : vendors,
            vendorStore: _vendorStore,
            controller: _controller,
            configs: configs,
          );
      }
    });
  }

  Widget buildHeader(BuildContext context, VendorStore? vendorStore) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return buildBoxHeader(
      context,
      color: Colors.transparent,
      paddingHorizontal: 0,
      left: Row(
        children: [
          buildButtonIcon(
            context,
            icon: FeatherIcons.barChart2,
            title: translate('product_list_sort')!,
            onPressed: () async {
              Map<String, dynamic>? sort = await showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                builder: (context) {
                  // Using Wrap makes the bottom sheet height the height of the content.
                  // Otherwise, the height will be half the height of the screen.
                  return Sort(
                    sort: vendorStore!.sort,
                  );
                },
              );
              if (sort != null) {
                _vendorStore!.onChanged(sort: sort);
              }
            },
          ),
          SizedBox(width: 8),
          buildButtonIcon(
            context,
            icon: FeatherIcons.sliders,
            title: translate('product_list_refine')!,
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                builder: (context) {
                  // Using Wrap makes the bottom sheet height the height of the content.
                  // Otherwise, the height will be half the height of the screen.
                  return Refine(
                    search: vendorStore!.search,
                    rangeDistance: vendorStore.rangDistance,
                    category: vendorStore.category,
                    onSubmit: (String search, RangeValues? rangeDistance, ProductCategory? category) {
                      vendorStore.onChanged(
                        search: search,
                        rangeDistance: rangeDistance,
                        category: category,
                        enableEmptyCategory: true,
                      );
                      Navigator.pop(context);
                      vendorStore.refresh();
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      right: buildGroupButtonIcon(
        context,
        icons: [FeatherIcons.airplay, FeatherIcons.grid, FeatherIcons.square, FeatherIcons.list],
        visitSelect: typeView,
        onChange: _onChange,
      ),
    );
  }
}
