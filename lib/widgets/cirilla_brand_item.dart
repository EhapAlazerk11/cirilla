import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

class CirillaBrandItem extends StatelessWidget with BrandMixin, Utility {
  final Brand? brand;

  final double? width;

  final double? height;

  final Color? background;

  final Color? textColor;

  final EdgeInsetsGeometry? padding;

  final double? radius;

  final String templateType;

  final Map<String, dynamic> templateData;

  final List<BoxShadow>? boxShadow;

  const CirillaBrandItem({
    Key? key,
    this.brand,
    this.width,
    this.height,
    this.templateType = Strings.brandItemDefault,
    this.templateData = const {},
    this.background,
    this.textColor,
    this.padding,
    this.radius,
    this.boxShadow,
  }) : super(key: key);

  void navigate(BuildContext context) {
    if (brand?.id == null) {
      return;
    }

    Navigator.of(context).pushNamed(ProductListScreen.routeName, arguments: {
      'brand': brand,
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        return buildItem(context, maxWidth: maxWidth);
      },
    );
  }

  Widget buildItem(BuildContext context, {required double maxWidth}) {
    SettingStore settingStore = Provider.of<SettingStore>(context);
    ThemeData theme = Theme.of(context);
    double widthScreen = MediaQuery.of(context).size.width;
    double max = maxWidth is double && maxWidth != double.infinity ? maxWidth : widthScreen;
    BoxFit fit = ConvertData.toBoxFit(get(templateData, ['imageSize'], 'cover'));
    String themeModeKey = settingStore.themeModeKey;

    switch (templateType) {
      case Strings.brandItemOverlay:
        EdgeInsetsGeometry defaultPadding = padding ?? EdgeInsets.all(11);

        double widthView = width ?? max;
        double heightView = height ?? widthView;
        TextAlign textAlign = ConvertData.toTextAlign(get(templateData, ['alignment'], 'left'));
        bool enableName = get(templateData, ['enableName'], true);
        double opacity = ConvertData.stringToDouble(get(templateData, ['opacity'], 0.6), 0.6);
        dynamic opacityColor = get(templateData, ['opacityColor'], Colors.black);
        Color colorOpacity = opacityColor is Color
            ? opacityColor
            : opacityColor is Map
                ? ConvertData.fromRGBA(get(opacityColor, [themeModeKey], {}), Colors.black)
                : Colors.black;

        return BrandOverlayItem(
          width: widthView,
          height: heightView,
          image: buildImage(
            context,
            brand: brand,
            width: widthView,
            height: heightView,
            fit: fit,
          ),
          name: enableName
              ? buildName(
                  brand: brand,
                  style: theme.textTheme.subtitle2?.copyWith(color: textColor ?? Colors.white),
                  theme: theme,
                  textAlign: textAlign,
                )
              : null,
          opacityColor: colorOpacity,
          opacity: opacity,
          paddingContent: defaultPadding,
          color: background,
          borderRadius: BorderRadius.circular(radius ?? 8),
          boxShadow: boxShadow,
          onClick: () => navigate(context),
        );
      case Strings.brandItemWrap:
        EdgeInsetsGeometry defaultPadding = padding ?? EdgeInsets.all(16);
        double widthDefaultItem = width ?? max;
        double? heightDefaultItem = height;

        double widthView = widthDefaultItem - defaultPadding.horizontal;
        double? heightView = heightDefaultItem != null ? heightDefaultItem - defaultPadding.vertical : null;
        double widthImage = heightView == null
            ? widthView < 60 && widthView > 0
                ? widthView
                : 60
            : heightView < widthView && heightView < 60 && heightView > 0
                ? heightView
                : 60;
        double heightImage = widthImage;
        bool enableImage = get(templateData, ['enableImage'], true);
        bool enableName = get(templateData, ['enableName'], true);

        return BrandWrapItem(
          width: widthDefaultItem,
          height: heightDefaultItem,
          image: enableImage
              ? buildImage(
                  context,
                  brand: brand,
                  width: widthImage,
                  height: heightImage,
                  radius: widthImage / 2,
                  fit: fit,
                )
              : null,
          name: enableName
              ? buildName(
                  brand: brand,
                  style: theme.textTheme.subtitle1?.copyWith(color: textColor),
                  theme: theme,
                )
              : null,
          paddingContent: defaultPadding,
          color: background ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(radius ?? 8),
          onClick: () => navigate(context),
          boxShadow: boxShadow,
        );
      case Strings.brandItemHorizontal:
        EdgeInsetsGeometry defaultPadding = padding ?? EdgeInsets.symmetric(horizontal: 16);
        double widthDefaultItem = width ?? max;
        double? heightDefaultItem = height;

        double widthImage = heightDefaultItem == null
            ? widthDefaultItem < 92 && widthDefaultItem > 0
                ? widthDefaultItem
                : 92
            : heightDefaultItem < widthDefaultItem && heightDefaultItem < 92 && heightDefaultItem > 0
                ? heightDefaultItem
                : 92;
        double heightImage = widthImage;

        return BrandHorizontalItem(
          width: widthDefaultItem,
          height: heightDefaultItem,
          image: buildImage(
            context,
            brand: brand,
            width: widthImage,
            height: heightImage,
            fit: fit,
          ),
          name: buildName(
            brand: brand,
            style: theme.textTheme.subtitle1?.copyWith(color: textColor),
            theme: theme,
          ),
          paddingContent: defaultPadding,
          color: background ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(radius ?? 8),
          onClick: () => navigate(context),
          boxShadow: boxShadow,
        );
      default:
        EdgeInsetsGeometry defaultPadding = padding ?? EdgeInsets.symmetric(horizontal: 7, vertical: 16);
        double widthDefaultItem = width is double
            ? width ?? max
            : height is double
                ? (height ?? max * 90) / 46
                : max;
        double? heightDefaultItem = height;

        double widthImage = widthDefaultItem - defaultPadding.horizontal > 0
            ? widthDefaultItem - defaultPadding.horizontal
            : widthDefaultItem;
        double heightImage = heightDefaultItem != null ? double.infinity : (widthImage * 46) / 90;

        TextAlign textAlign = ConvertData.toTextAlign(get(templateData, ['alignment'], 'left'));
        bool enableImage = get(templateData, ['enableImage'], true);
        bool enableName = get(templateData, ['enableName'], true);

        return BrandContainedItem(
          width: widthDefaultItem,
          height: heightDefaultItem,
          image: enableImage
              ? heightImage == double.infinity
                  ? Expanded(
                      child: buildImage(
                        context,
                        brand: brand,
                        width: widthImage,
                        height: double.infinity,
                        fit: fit,
                      ),
                    )
                  : buildImage(
                      context,
                      brand: brand,
                      width: widthImage,
                      height: heightImage,
                      fit: fit,
                    )
              : null,
          name: enableName
              ? buildName(
                  brand: brand,
                  style: theme.textTheme.subtitle2?.copyWith(color: textColor),
                  theme: theme,
                  textAlign: textAlign,
                )
              : null,
          paddingContent: defaultPadding,
          color: background,
          borderRadius: BorderRadius.circular(radius ?? 0),
          onClick: () => navigate(context),
          boxShadow: boxShadow,
        );
    }
  }
}
