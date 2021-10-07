import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/widgets/cirilla_vendor_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'layout/layout_list.dart';
import 'layout/layout_carousel.dart';
import 'layout/layout_grid.dart';

class VendorWidget extends StatelessWidget with Utility {
  final WidgetConfig? widgetConfig;
  final List<Vendor> vendors;

  VendorWidget({
    Key? key,
    this.widgetConfig,
    this.vendors = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    String layout = widgetConfig?.layout ?? Strings.vendorLayoutList;

    // styles
    Map styles = widgetConfig?.styles ?? {};
    EdgeInsetsDirectional margin = ConvertData.space(get(styles, ['margin'], {}), 'margin');
    EdgeInsetsDirectional padding = ConvertData.space(get(styles, ['padding'], {}), 'padding');
    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);
    double? pad = ConvertData.stringToDouble(get(styles, ['pad'], 12), 12);
    double? height = ConvertData.stringToDouble(get(styles, ['height'], 300), 300);
    double? widthItem = ConvertData.stringToDouble(get(styles, ['widthItem'], 250), 250);
    Color backgroundItem =
        ConvertData.fromRGBA(get(styles, ['backgroundColorItem', themeModeKey], {}), theme.colorScheme.surface);
    Color textColor =
        ConvertData.fromRGBA(get(styles, ['textColor', themeModeKey], {}), theme.textTheme.subtitle1!.color);
    Color subTextColor =
        ConvertData.fromRGBA(get(styles, ['subTextColor', themeModeKey], {}), theme.textTheme.overline!.color);
    double? radius = ConvertData.stringToDouble(get(styles, ['radius'], 8), 8);
    Color shadowColor = ConvertData.fromRGBA(get(styles, ['shadowColor', themeModeKey], {}), Colors.black);
    double offsetX = ConvertData.stringToDouble(get(styles, ['offsetX'], 0));
    double offsetY = ConvertData.stringToDouble(get(styles, ['offsetY'], 4));
    double blurRadius = ConvertData.stringToDouble(get(styles, ['blurRadius'], 24));
    double spreadRadius = ConvertData.stringToDouble(get(styles, ['spreadRadius'], 0));

    // config general
    Map fields = widgetConfig?.fields ?? {};
    String? template = get(fields, ['template', 'template'], Strings.vendorItemContained);
    Map? dataTemplate = get(fields, ['template', 'data'], {});

    BoxShadow shadow = BoxShadow(
      color: shadowColor,
      offset: Offset(offsetX, offsetY),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
    );

    return Container(
      margin: margin,
      color: background,
      height: layout == Strings.vendorLayoutCarousel ? height : null,
      child: buildLayout(
        layout,
        length: vendors.length,
        pad: pad,
        padding: padding,
        styles: styles,
        widthItem: widthItem,
        buildItem: (_, {int? index, double? widthItem}) {
          Vendor vendor = vendors.elementAt(index!);
          return CirillaVendorItem(
            vendor: vendor,
            template: template,
            dataTemplate: dataTemplate,
            widthItem: widthItem,
            color: backgroundItem,
            textColor: textColor,
            subTextColor: subTextColor,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [shadow],
          );
        },
      ),
    );
  }

  Widget buildLayout(
    String layout, {
    int? length,
    double? pad,
    double? widthItem,
    EdgeInsetsDirectional? padding,
    Map styles = const {},
    required Widget Function(BuildContext context, {int? index, double? widthItem}) buildItem,
  }) {
    switch (layout) {
      case Strings.vendorLayoutCarousel:
        return LayoutCarousel(
          padding: padding,
          length: length,
          pad: pad,
          widthItem: widthItem,
          buildItem: buildItem,
        );
      case Strings.vendorLayoutGrid:
        int col = ConvertData.stringToInt(get(styles, ['col'], 2), 2);
        double? ratio = ConvertData.stringToDouble(get(styles, ['ratio'], 1), 1);
        return LayoutGrid(
          padding: padding,
          length: length,
          pad: pad,
          col: col,
          ratio: ratio,
          buildItem: buildItem,
        );
      default:
        return LayoutList(
          padding: padding,
          length: length,
          pad: pad,
          buildItem: buildItem,
        );
    }
  }
}
