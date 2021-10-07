import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/post_list/post_list.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

class CirillaPostCategoryItem extends StatelessWidget with Utility, CategoryMixin {
  // Template item style
  final Map<String, dynamic>? template;

  final PostCategory? category;

  final double? width;

  final double? height;

  final Color? background;

  final Color? textColor;

  final Color? labelColor;

  final Color? labelTextColor;

  final double? labelRadius;

  final double? radius;

  final double? radiusImage;

  CirillaPostCategoryItem({
    Key? key,
    this.template,
    this.category,
    this.width,
    this.height,
    this.background,
    this.textColor,
    this.labelColor,
    this.labelTextColor,
    this.labelRadius,
    this.radius,
    this.radiusImage,
  }) : super(key: key);

  void navigate(BuildContext context) {
    if (category!.id == null) {
      return;
    }
    Navigator.pushNamed(context, PostListScreen.routeName, arguments: {'category': category});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    String? temp = get(template, ['template'], Strings.postItemContained);
    bool? enableCount = get(template, ['data', 'enableCount'], true);

    switch (temp) {
      case Strings.postCategoryItemHorizontal:
        double widthItem = width ?? 335;
        double heightItem = height is double && height! > 0 ? height! : 102;
        return SizedBox(
          width: widthItem,
          height: heightItem,
          child: PostCategoryItemHorizontal(
            image: buildImagePostCategory(
              category: category!,
              width: heightItem < 70 ? heightItem : 70,
              height: heightItem < 70 ? heightItem : 70,
              radius: radiusImage ?? 35,
            ),
            title: buildNamePostCategory(category: category!, theme: theme, color: textColor),
            count: enableCount!
                ? buildCountPostCategory(
                    category: category!,
                    size: 26,
                    radius: labelRadius,
                    color: labelColor,
                    countStyle: theme.textTheme.caption!.copyWith(color: labelTextColor),
                  )
                : null,
            width: widthItem,
            color: background,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 8)),
            onClick: () => navigate(context),
          ),
        );
      case Strings.postCategoryItemGradient:
        // double widthItem = width ?? height is double && height! > 0 ? (height! * 245) / 109 : 245;
        double widthItem = width ?? 245;
        double? heightItem = height is double && height! > 0 ? height : (widthItem * 109) / 245;

        Color colorBegin =
            ConvertData.fromRGBA(get(template, ['data', 'colorBegin', themeModeKey], {}), Colors.transparent);
        Color colorEnd = ConvertData.fromRGBA(get(template, ['data', 'colorEnd', themeModeKey], {}), Colors.black);
        AlignmentDirectional begin = ConvertData.toAlignmentDirectional(get(template, ['data', 'begin'], 'top-center'));
        AlignmentDirectional end = ConvertData.toAlignmentDirectional(get(template, ['data', 'end'], 'bottom-center'));
        double opacity = ConvertData.stringToDouble(get(template, ['data', 'opacity'], 0.9));

        LinearGradient gradient = LinearGradient(
          begin: begin,
          end: end, // 10% of the width, so there are ten blinds.
          colors: <Color>[colorBegin, colorEnd], // red to yellowepeats the gradient over the canvas
        );

        return PostCategoryItemGradient(
          image: buildImagePostCategory(
            category: category!,
            width: widthItem,
            height: heightItem,
            radius: radiusImage ?? 0,
          ),
          title: buildNamePostCategory(category: category!, theme: theme, color: textColor),
          count: enableCount!
              ? buildCountPostCategory(
                  category: category!,
                  size: 26,
                  radius: labelRadius,
                  color: labelColor,
                  countStyle: theme.textTheme.caption!.copyWith(color: labelTextColor),
                )
              : null,
          gradient: gradient,
          opacity: opacity,
          width: widthItem,
          color: background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 8)),
          onClick: () => navigate(context),
        );
      case Strings.postCategoryItemParallax:
        Color colorBegin =
            ConvertData.fromRGBA(get(template, ['data', 'colorBegin', themeModeKey], {}), Colors.transparent);
        Color colorEnd =
            ConvertData.fromRGBA(get(template, ['data', 'colorEnd', themeModeKey], {}), Colors.black.withOpacity(0.7));

        double widthItem = width is double
            ? width!
            : height is double
                ? height! * 16 / 9
                : 335;
        double heightItem = height is double ? height! : widthItem * 9 / 16;

        return PostCategoryItemParallax(
          image: buildImagePostCategory(
            category: category!,
            width: widthItem,
            height: heightItem,
          ),
          title: buildNamePostCategory(
            category: category!,
            theme: theme,
            style: theme.textTheme.subtitle1!.copyWith(color: textColor ?? Colors.white),
          ),
          count: enableCount!
              ? buildTextCountPostCategory(
                  context,
                  category: category!,
                  countStyle: theme.textTheme.caption!.copyWith(color: labelTextColor ?? Colors.white),
                )
              : null,
          width: widthItem,
          ratio: widthItem / heightItem,
          colorsGradient: [colorBegin, colorEnd],
          borderRadius: BorderRadius.circular(radius ?? 8),
          onClick: () => navigate(context),
        );
      default:
        bool enableRoundImage = get(template, ['data', 'enableRoundImage'], true);

        double widthImage = width is double
            ? width!
            : height is double
                ? height!
                : 109;
        double? heightImage = height is double ? height : widthImage;

        return PostCategoryItemContained(
          image: buildImagePostCategory(
            category: category!,
            width: widthImage,
            height: heightImage,
            radius: radiusImage,
            enableRound: enableRoundImage,
          ),
          title: buildNamePostCategory(category: category!, theme: theme, color: textColor),
          count: enableCount!
              ? buildCountPostCategory(
                  category: category!,
                  size: 26,
                  radius: labelRadius,
                  color: labelColor,
                  countStyle: theme.textTheme.subtitle2!.copyWith(color: labelTextColor),
                )
              : null,
          width: widthImage,
          color: background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 0)),
          onClick: () => navigate(context),
        );
    }
  }
}
