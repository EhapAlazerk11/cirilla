import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

class CirillaVendorItem extends StatelessWidget with Utility, VendorMixin {
  final Vendor? vendor;
  final String? template;
  final Map? dataTemplate;
  final double? widthItem;
  final double? widthBanner;
  final double? heightBanner;
  final Widget? directionIcon;
  final bool enableDistance;
  final EdgeInsetsGeometry? padding;
  final Border? border;
  final BorderRadius borderRadius;
  final List<BoxShadow>? boxShadow;
  final Color? color;
  final Color? textColor;
  final Color? subTextColor;

  CirillaVendorItem({
    Key? key,
    this.vendor,
    this.template,
    this.dataTemplate,
    this.widthItem,
    this.widthBanner,
    this.heightBanner,
    this.padding,
    this.directionIcon,
    this.enableDistance = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.border,
    this.boxShadow,
    this.color,
    this.textColor,
    this.subTextColor,
  }) : super(key: key);

  void navigate(BuildContext context) {
    if (!(vendor is Vendor) || vendor!.id == null) return null;
    Navigator.of(context).pushNamed(VendorScreen.routeName, arguments: {
      'vendor': vendor,
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      double widthScreen = MediaQuery.of(context).size.width;
      double maxWidth = constraints.maxWidth;
      return buildItem(context, maxWidth: maxWidth, widthScreen: widthScreen);
    });
  }

  Widget buildItem(BuildContext context, {double? maxWidth, double? widthScreen}) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    switch (template) {
      case Strings.vendorItemEmerge:
        double width = ConvertData.stringToDouble(get(dataTemplate, ['sizeBanner', 'width'], 334), 334);
        double height = ConvertData.stringToDouble(get(dataTemplate, ['sizeBanner', 'height'], 174), 174);
        double? widthView = widthItem is double
            ? widthItem
            : widthBanner is double
                ? widthBanner
                : maxWidth != null && maxWidth != double.infinity
                    ? maxWidth
                    : widthScreen;
        double? widthSizeBanner = widthView;
        double heightSizeBanner = getHeightBanner(widthSizeBanner, widthBanner, heightBanner, width / height);
        return VendorEmergeItem(
          banner: buildImage(context,
              vendor: vendor,
              type: 'banner',
              width: widthSizeBanner,
              height: heightSizeBanner,
              borderRadius: 0,
              fit: BoxFit.cover),
          image: buildImage(context, vendor: vendor, width: 60, height: 60, borderRadius: 30, fit: BoxFit.cover),
          name: buildName(context, vendor: vendor, theme: theme, color: textColor),
          directionIcon: directionIcon,
          distance: enableDistance ? buildDistance(context, vendor: vendor, theme: theme) : null,
          rating: buildRating(context, vendor: vendor, theme: theme, color: subTextColor),
          heightEmerge: heightSizeBanner - 11,
          width: widthView,
          padding: padding as EdgeInsets? ?? EdgeInsets.all(24),
          borderRadius: borderRadius,
          border: border,
          boxShadow: boxShadow ?? initBoxShadow,
          color: color ?? theme.scaffoldBackgroundColor,
          onClick: () => navigate(context),
        );

      case Strings.vendorItemContained:
        double? widthView = widthItem is double
            ? widthItem
            : maxWidth != null && maxWidth != double.infinity
                ? maxWidth
                : 184;
        return VendorContainedItem(
          image: buildImage(context, vendor: vendor, width: 60, height: 60, borderRadius: 30, fit: BoxFit.cover),
          name: buildName(context, vendor: vendor, theme: theme, textAlign: TextAlign.center, color: textColor),
          distance: enableDistance ? buildDistance(context, vendor: vendor, theme: theme, isCenter: true) : null,
          rating: buildRating(context,
              vendor: vendor, theme: theme, color: subTextColor, centerHorizontal: true, enableBasic: true),
          width: widthView,
          padding: padding as EdgeInsets? ?? EdgeInsets.all(24),
          borderRadius: borderRadius,
          border: border,
          boxShadow: boxShadow,
          color: color ?? theme.colorScheme.surface,
          onClick: () => navigate(context),
        );
      case Strings.vendorItemGradient:
        double width = ConvertData.stringToDouble(get(dataTemplate, ['sizeBanner', 'width'], 334), 334);
        double height = ConvertData.stringToDouble(get(dataTemplate, ['sizeBanner', 'height'], 180), 180);
        Color colorBegin =
            ConvertData.fromRGBA(get(dataTemplate, ['colorBegin', themeModeKey], {}), Colors.transparent);
        Color colorEnd = ConvertData.fromRGBA(get(dataTemplate, ['colorEnd', themeModeKey], {}), Colors.black);
        AlignmentDirectional begin = ConvertData.toAlignmentDirectional(get(dataTemplate, ['begin'], 'top-center'));
        AlignmentDirectional end = ConvertData.toAlignmentDirectional(get(dataTemplate, ['end'], 'bottom-center'));

        double? widthView = widthItem is double
            ? widthItem
            : widthBanner is double
                ? widthBanner
                : maxWidth != null && maxWidth != double.infinity
                    ? maxWidth
                    : widthScreen;
        double? widthSizeBanner = widthView;
        double heightSizeBanner = getHeightBanner(widthSizeBanner, widthBanner, heightBanner, width / height);

        LinearGradient gradient = LinearGradient(
          begin: begin,
          end: end, // 10% of the width, so there are ten blinds.
          colors: <Color>[colorBegin, colorEnd], // red to yellowepeats the gradient over the canvas
        );

        return VendorGradientItem(
          image: buildImage(
            context,
            vendor: vendor,
            width: 60,
            height: 60,
            borderRadius: 30,
            fit: BoxFit.cover,
            border: Border.all(width: 1, color: theme.dividerColor),
          ),
          banner: buildImage(context,
              vendor: vendor,
              type: 'banner',
              width: widthSizeBanner,
              height: heightSizeBanner,
              borderRadius: 0,
              fit: BoxFit.cover),
          name: buildName(context, vendor: vendor, theme: theme, color: textColor ?? Colors.white),
          distance: enableDistance ? buildDistance(context, vendor: vendor, theme: theme, color: Colors.white) : null,
          rating: buildRating(context, vendor: vendor, theme: theme, color: subTextColor),
          directionIcon: directionIcon,
          gradient: gradient,
          width: widthView,
          padding: padding as EdgeInsets? ?? EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          borderRadius: borderRadius,
          border: border,
          boxShadow: boxShadow ?? initBoxShadow,
          color: color ?? theme.colorScheme.surface,
          onClick: () => navigate(context),
        );
      default:
        double? widthView = widthItem is double
            ? widthItem
            : maxWidth != null && maxWidth != double.infinity
                ? maxWidth
                : widthScreen;
        return VendorHorizontalItem(
          image: buildImage(context, vendor: vendor, width: 60, height: 60, borderRadius: 30, fit: BoxFit.cover),
          name: buildName(context, vendor: vendor, theme: theme, color: textColor),
          distance: enableDistance ? buildDistance(context, vendor: vendor, theme: theme) : null,
          rating: buildRating(context, vendor: vendor, theme: theme, color: subTextColor),
          width: widthView,
          padding: padding as EdgeInsets? ?? EdgeInsets.all(24),
          borderRadius: borderRadius,
          border: border,
          boxShadow: boxShadow,
          color: color ?? theme.scaffoldBackgroundColor,
          onClick: () => navigate(context),
        );
    }
  }

  double getHeightBanner(double? widthBannerSize, double? width, double? height, double ratio) {
    if (width is double && height is double) {
      return (widthBannerSize! * height) / width;
    }
    if (!(width is double) && height is double) {
      return height;
    }

    return widthBannerSize! / ratio;
  }
}
