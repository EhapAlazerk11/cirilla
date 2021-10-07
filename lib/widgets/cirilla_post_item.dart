import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/post_mixin.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/models/post/post.dart';
import 'package:cirilla/screens/post/post.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

List<BoxShadow> defaultShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.08),
    offset: Offset(0, 4),
    blurRadius: 24,
    spreadRadius: 0,
  ),
];

class CirillaPostItem extends StatelessWidget with PostMixin, Utility {
  // Type template item style
  final String? template;

  final Map<String, dynamic>? dataTemplate;

  final Post? post;

  // use for item number
  final int number;

  final double? width;

  final double? height;

  final double? maxHeight;

  final double? widthItem;

  final Color? background;

  final Color? textColor;

  final Color? subTextColor;

  final Color? labelColor;

  final Color? labelTextColor;

  final double? labelRadius;

  final BorderRadius? radius;

  final double? radiusImage;

  final List<BoxShadow>? boxShadow;

  final Border? border;

  final EdgeInsetsGeometry? paddingContent;

  // only use for template horizontal
  final bool isRightImage;

  const CirillaPostItem({
    Key? key,
    this.post,
    this.number = 1,
    this.width,
    this.height,
    this.widthItem,
    this.maxHeight,
    this.template = Strings.postItemDefault,
    this.dataTemplate = const {},
    this.background,
    this.textColor,
    this.subTextColor,
    this.labelColor,
    this.labelTextColor,
    this.labelRadius,
    this.boxShadow,
    this.border,
    this.radius,
    this.radiusImage,
    this.paddingContent,
    this.isRightImage = false,
  }) : super(key: key);

  void navigate(BuildContext context) {
    if (post!.id == null) {
      return;
    }

    Navigator.of(context).pushNamed(PostScreen.routeName, arguments: {'post': post});
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

  Widget buildItem(BuildContext context, {double? maxWidth}) {
    ThemeData theme = Theme.of(context);
    double widthScreen = MediaQuery.of(context).size.width;

    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    BoxFit fit = ConvertData.toBoxFit(get(dataTemplate, ['imageSize'], 'cover'));
    bool? enableCategory = get(dataTemplate, ['enableCategory'], true);
    bool? enableDate = get(dataTemplate, ['enableDate'], true);
    bool? enableAuthor = get(dataTemplate, ['enableAuthor'], true);
    bool? enableComments = get(dataTemplate, ['enableComments'], true);

    switch (template) {
      case Strings.postItemVertical:
        double widthDefaultItem =
            getWidthView(widthItem: widthItem, width: width, maxWidth: maxWidth, defaultWidth: widthScreen)!;

        double widthImage = widthDefaultItem;
        double? ratioImage = getRatioImage(
            width: width,
            height: height,
            defaultRatio: height is double && !(width is double) ? (widthImage / height!) : 247 / 192);
        double? heightImage =
            maxHeight is double && widthImage / ratioImage! > maxHeight! ? maxHeight : widthImage / ratioImage!;

        return PostVerticalItem(
          image: buildImage(post!, width: widthImage, height: heightImage, fit: fit, borderRadius: radiusImage ?? 0),
          name: buildName(theme, post!, textColor),
          category:
              enableCategory! ? buildCategory(theme, post!, false, labelColor, labelTextColor, labelRadius) : null,
          date: enableDate! ? buildDate(theme, post!, subTextColor) : null,
          author: enableAuthor! ? buildAuthor(context, theme, post!, subTextColor) : null,
          comment: enableComments! ? buildComment(theme, post!, subTextColor) : null,
          width: widthDefaultItem,
          paddingContent: paddingContent ?? EdgeInsets.all(16),
          color: background ?? theme.colorScheme.surface,
          border: border,
          borderRadius: radius,
          boxShadow: boxShadow ?? defaultShadow,
          onClick: () => navigate(context),
        );
      case Strings.postItemVerticalCenter:
        double widthDefaultItem =
            getWidthView(widthItem: widthItem, width: width, maxWidth: maxWidth, defaultWidth: 160)!;

        double widthImage = widthDefaultItem;
        double? ratioImage = getRatioImage(
            width: width,
            height: height,
            defaultRatio: height is double && !(width is double) ? (widthImage / height!) : 1);
        double? heightImage =
            maxHeight is double && widthImage / ratioImage! > maxHeight! ? maxHeight : widthImage / ratioImage!;
        return PostVerticalCenterItem(
          image: buildImage(post!, width: widthImage, height: heightImage, fit: fit, borderRadius: radiusImage ?? 0),
          name: buildName(theme, post!, textColor, TextAlign.center),
          category: enableCategory!
              ? buildCategory(theme, post!, true, labelColor, labelTextColor, labelRadius, 'center')
              : null,
          date: enableDate! ? buildDate(theme, post!, subTextColor) : null,
          author: enableAuthor! ? buildAuthor(context, theme, post!, subTextColor) : null,
          comment: enableComments! ? buildComment(theme, post!, subTextColor) : null,
          width: widthDefaultItem,
          paddingContent: paddingContent ?? EdgeInsets.all(16),
          color: background ?? theme.colorScheme.surface,
          border: border,
          borderRadius: radius ?? BorderRadius.circular(8),
          boxShadow: boxShadow ?? defaultShadow,
          onClick: () => navigate(context),
        );
      case Strings.postItemHorizontal:
        double widthDefaultItem =
            getWidthView(widthItem: widthItem, isFullImage: false, maxWidth: maxWidth, defaultWidth: 335)!;
        double widthImage = widthDefaultItem / 3 > 120 ? 120 : widthDefaultItem / 3;
        double? ratioImage = getRatioImage(width: width, height: height, defaultRatio: 1);
        double? heightImage =
            maxHeight is double && widthImage / ratioImage! > maxHeight! ? maxHeight : widthImage / ratioImage!;

        return Column(
          children: [
            PostHorizontalItem(
              image:
                  buildImage(post!, width: widthImage, height: heightImage, fit: fit, borderRadius: radiusImage ?? 8),
              name: buildName(theme, post!, textColor),
              category:
                  enableCategory! ? buildCategory(theme, post!, false, labelColor, labelTextColor, labelRadius) : null,
              date: enableDate! ? buildDate(theme, post!, subTextColor) : null,
              author: enableAuthor! ? buildAuthor(context, theme, post!, subTextColor) : null,
              comment: enableComments! ? buildComment(theme, post!, subTextColor) : null,
              isRightImage: isRightImage,
              width: widthDefaultItem,
              padding: paddingContent ?? EdgeInsetsDirectional.zero,
              color: background ?? Colors.transparent,
              border: border,
              borderRadius: radius ?? BorderRadius.zero,
              boxShadow: boxShadow,
              onClick: () => navigate(context),
            ),
          ],
        );
      case Strings.postItemNumber:
        double widthDefaultItem =
            getWidthView(widthItem: widthItem, isFullImage: false, maxWidth: maxWidth, defaultWidth: 335)!;
        String strNumber = number > 9 ? number.toString() : '0$number';
        return PostNumberItem(
          number: Text(
            strNumber,
            style: theme.textTheme.headline3!.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..color = theme.primaryColor,
            ),
          ),
          name: buildName(theme, post!, textColor),
          category:
              enableCategory! ? buildCategory(theme, post!, false, labelColor, labelTextColor, labelRadius) : null,
          date: enableDate! ? buildDate(theme, post!, subTextColor) : null,
          author: enableAuthor! ? buildAuthor(context, theme, post!, subTextColor) : null,
          comment: enableComments! ? buildComment(theme, post!, subTextColor) : null,
          color: background ?? Colors.transparent,
          border: border,
          borderRadius: radius,
          boxShadow: boxShadow,
          padding: paddingContent ?? EdgeInsetsDirectional.zero,
          width: widthDefaultItem,
          onClick: () => navigate(context),
        );
      case Strings.postItemEmerge:
        double widthDefaultItem =
            getWidthView(widthItem: widthItem, width: width, maxWidth: maxWidth, defaultWidth: 335)!;

        double widthImage = widthDefaultItem;
        double? ratioImage = getRatioImage(
            width: width,
            height: height,
            defaultRatio: height is double && !(width is double) ? (widthImage / height!) : 335 / 250);
        double heightImage =
            maxHeight is double && widthImage / ratioImage! > maxHeight! ? maxHeight! : widthImage / ratioImage!;
        return PostEmergeItem(
          image: buildImage(post!, width: widthImage, height: heightImage, fit: fit, borderRadius: radiusImage ?? 0),
          name: buildName(theme, post!, textColor, TextAlign.center),
          category: enableCategory!
              ? buildCategory(theme, post!, true, labelColor, labelTextColor, labelRadius, 'center')
              : null,
          date: enableDate! ? buildDate(theme, post!, subTextColor) : null,
          author: enableAuthor! ? buildAuthor(context, theme, post!, subTextColor) : null,
          comment: enableComments! ? buildComment(theme, post!, subTextColor) : null,
          width: widthDefaultItem,
          heightEmerge: heightImage / 43 > 4 ? heightImage - 43 : (heightImage * 3) / 4,
          padding: paddingContent ?? EdgeInsets.all(16),
          color: background ?? theme.colorScheme.surface,
          border: border,
          borderRadius: radius ?? BorderRadius.circular(8),
          boxShadow: boxShadow ?? defaultShadow,
          onClick: () => navigate(context),
        );
      case Strings.postItemOverlay:
        bool enableExcerpt = get(template, ['data', 'enableExcerpt'], true);
        Color colorLine = ConvertData.fromRGBA(get(dataTemplate, ['colorLine', themeModeKey], {}), theme.dividerColor);
        Color color = ConvertData.fromRGBA(get(dataTemplate, ['color', themeModeKey], {}), Colors.black);
        double opacity = ConvertData.stringToDouble(get(dataTemplate, ['opacity'], 0.5));

        double widthDefaultItem =
            getWidthView(widthItem: widthItem, width: width, maxWidth: maxWidth, defaultWidth: widthScreen)!;

        double widthImage = widthDefaultItem;
        double? ratioImage = getRatioImage(
            width: width,
            height: height,
            defaultRatio: height is double && !(width is double) ? (widthImage / height!) : 298 / 285);
        double? heightImage =
            maxHeight is double && widthImage / ratioImage! > maxHeight! ? maxHeight : widthImage / ratioImage!;
        return PostOverlayItem(
          image: buildImage(post!, width: widthImage, height: heightImage, fit: fit),
          name: buildName(theme, post!, textColor ?? Colors.white),
          category:
              enableCategory! ? buildCategory(theme, post!, false, labelColor, labelTextColor, labelRadius) : null,
          date: enableDate! ? buildDate(theme, post!, subTextColor ?? Colors.white) : null,
          author: enableAuthor! ? buildAuthor(context, theme, post!, subTextColor ?? Colors.white) : null,
          comment: enableComments! ? buildComment(theme, post!, subTextColor ?? Colors.white) : null,
          excerpt: enableExcerpt ? buildExcept(post!, theme: theme, color: subTextColor) : null,
          width: widthDefaultItem,
          background: color,
          colorLine: colorLine,
          opacity: opacity,
          padding: paddingContent ?? EdgeInsets.all(24),
          color: background,
          border: border,
          borderRadius: radius ?? BorderRadius.circular(8),
          boxShadow: boxShadow,
          onClick: () => navigate(context),
        );
      case Strings.postItemTopName:
        bool enableExcerpt = get(template, ['data', 'enableExcerpt'], true);
        EdgeInsetsDirectional paddingItem =
            paddingContent as EdgeInsetsDirectional? ?? EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16);
        double widthDefaultItem =
            getWidthView(widthItem: widthItem, width: width, maxWidth: maxWidth, defaultWidth: 375)!;

        double widthImage = widthDefaultItem - paddingItem.start - paddingItem.end;
        double? ratioImage = getRatioImage(
            width: width,
            height: height,
            defaultRatio: height is double && !(width is double) ? (widthImage / height!) : 343 / 180);
        double? heightImage =
            maxHeight is double && widthImage / ratioImage! > maxHeight! ? maxHeight : widthImage / ratioImage!;

        return PostTopNameItem(
          image: buildImage(post!, width: widthImage, height: heightImage, fit: fit, borderRadius: radiusImage ?? 8),
          name: buildName(theme, post!, textColor),
          category:
              enableCategory! ? buildCategory(theme, post!, false, labelColor, labelTextColor, labelRadius) : null,
          date: enableDate! ? buildDate(theme, post!, subTextColor) : null,
          author: enableAuthor! ? buildAuthor(context, theme, post!, subTextColor) : null,
          comment: enableComments! ? buildComment(theme, post!, subTextColor) : null,
          excerpt: enableExcerpt ? buildExcept(post!, theme: theme, color: subTextColor) : null,
          padding: paddingItem,
          color: background ?? theme.colorScheme.surface,
          border: border,
          borderRadius: radius ?? BorderRadius.circular(8),
          boxShadow: boxShadow ?? defaultShadow,
          width: widthDefaultItem,
          onClick: () => navigate(context),
        );
      case Strings.postItemTimeLine:
        bool enableImageAuthor = get(dataTemplate, ['enableImageAuthor'], true);
        // double widthImage = width - PostTimeLineItem.defaultWidthLeft - 32;
        // double heightImage = (widthImage * height) / width;

        EdgeInsetsDirectional paddingItem =
            paddingContent as EdgeInsetsDirectional? ?? EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16);

        double widthDefaultItem =
            getWidthView(widthItem: widthItem, isFullImage: false, maxWidth: maxWidth, defaultWidth: 353)!;

        double widthImage = widthDefaultItem - paddingItem.end - paddingItem.start - PostTimeLineItem.defaultWidthLeft;
        double? ratioImage = getRatioImage(
            width: width,
            height: height,
            defaultRatio: height is double && !(width is double) ? (widthImage / height!) : 240 / 140);
        double? heightImage =
            maxHeight is double && widthImage / ratioImage! > maxHeight! ? maxHeight : widthImage / ratioImage!;

        return PostTimeLineItem(
          image: buildImage(post!, width: widthImage, height: heightImage, fit: fit, borderRadius: radiusImage ?? 8),
          name: buildName(theme, post!, textColor),
          category: enableCategory!
              ? buildCategory(theme, post!, false, labelColor, labelTextColor, labelRadius, 'right')
              : null,
          headingInfo: Row(
            children: [
              if (enableImageAuthor) ...[
                buildAuthorImage(context, post!),
                SizedBox(width: 8),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildAuthorName(context, theme, post!, textColor),
                    enableDate! ? buildDate(theme, post!, subTextColor) : Container(),
                  ],
                ),
              )
            ],
          ),
          left: Padding(
            padding: EdgeInsetsDirectional.only(start: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    enableComments! ? buildComment(theme, post!, null, 20) : Container(),
                    SizedBox(height: 24),
                    Icon(FeatherIcons.bookmark, size: 20),
                    SizedBox(height: 24),
                    Icon(FeatherIcons.upload, size: 20),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 102,
                  width: 1,
                  color: theme.dividerColor,
                  margin: EdgeInsetsDirectional.only(start: 10),
                ),
              ],
            ),
          ),
          width: widthDefaultItem,
          widthLeft: PostTimeLineItem.defaultWidthLeft,
          paddingContent: paddingItem,
          color: background ?? theme.colorScheme.surface,
          border: border,
          borderRadius: radius ??
              BorderRadius.only(
                  topLeft: Radius.circular(radius as double? ?? 8),
                  bottomLeft: Radius.circular(radius as double? ?? 8)),
          boxShadow: boxShadow ?? defaultShadow,
          onClick: () => navigate(context),
        );
      case Strings.postItemGradient:
        Color colorBegin =
            ConvertData.fromRGBA(get(dataTemplate, ['colorBegin', themeModeKey], {}), Colors.transparent);
        Color colorEnd = ConvertData.fromRGBA(get(dataTemplate, ['colorEnd', themeModeKey], {}), Colors.black);
        AlignmentDirectional begin = ConvertData.toAlignmentDirectional(get(dataTemplate, ['begin'], 'top-center'));
        AlignmentDirectional end = ConvertData.toAlignmentDirectional(get(dataTemplate, ['end'], 'bottom-center'));
        double opacity = ConvertData.stringToDouble(get(dataTemplate, ['opacity'], 0.9));

        LinearGradient gradient = LinearGradient(
          begin: begin,
          end: end, // 10% of the width, so there are ten blinds.
          colors: <Color>[colorBegin, colorEnd], // red to yellowepeats the gradient over the canvas
        );

        double widthDefaultItem =
            getWidthView(widthItem: widthItem, width: width, maxWidth: maxWidth, defaultWidth: 375)!;

        double widthImage = widthDefaultItem;
        double? ratioImage = getRatioImage(
            width: width,
            height: height,
            defaultRatio: height is double && !(width is double) ? (widthImage / height!) : 375 / 430);
        double? heightImage =
            maxHeight is double && widthImage / ratioImage! > maxHeight! ? maxHeight : widthImage / ratioImage!;

        return PostGradientItem(
          image: buildImage(post!, width: widthImage, height: heightImage, fit: fit),
          name: buildName(theme, post!, textColor ?? Colors.white),
          category:
              enableCategory! ? buildCategory(theme, post!, false, labelColor, labelTextColor, labelRadius) : null,
          date: enableDate! ? buildDate(theme, post!, subTextColor ?? Colors.white) : null,
          comment: enableComments! ? buildComment(theme, post!, subTextColor ?? Colors.white) : null,
          author: enableAuthor! ? buildAuthor(context, theme, post!, subTextColor ?? Colors.white) : null,
          gradient: gradient,
          opacity: opacity,
          width: widthDefaultItem,
          padding: paddingContent ?? EdgeInsetsDirectional.fromSTEB(20, 24, 24, 54),
          color: background ?? Colors.transparent,
          border: border,
          borderRadius: radius ?? BorderRadius.circular(0),
          boxShadow: boxShadow,
          onClick: () => navigate(context),
        );
      default:
        double widthDefaultItem =
            getWidthView(widthItem: widthItem, width: width, maxWidth: maxWidth, defaultWidth: widthScreen)!;

        double widthImage = widthDefaultItem;
        double? ratioImage = getRatioImage(
            width: width,
            height: height,
            defaultRatio: height is double && !(width is double) ? (widthImage / height!) : 335 / 260);
        double? heightImage =
            maxHeight is double && widthImage / ratioImage! > maxHeight! ? maxHeight : widthImage / ratioImage!;

        return PostContainedItem(
          image: buildImage(post!, width: widthImage, height: heightImage, fit: fit, borderRadius: radiusImage ?? 8),
          name: buildName(theme, post!, textColor),
          category:
              enableCategory! ? buildCategory(theme, post!, false, labelColor, labelTextColor, labelRadius) : null,
          date: enableDate! ? buildDate(theme, post!, subTextColor) : null,
          author: enableAuthor! ? buildAuthor(context, theme, post!, subTextColor) : null,
          comment: enableComments! ? buildComment(theme, post!, subTextColor) : null,
          width: widthDefaultItem,
          paddingContent: paddingContent ?? EdgeInsets.only(top: 8),
          color: background ?? Colors.transparent,
          boxShadow: boxShadow,
          border: border,
          borderRadius: radius,
          onClick: () => navigate(context),
        );
    }
  }

  double? getWidthView(
      {double? widthItem, double? width, double? maxWidth, double? defaultWidth, bool isFullImage = true}) {
    if (widthItem is double) return widthItem;
    if (isFullImage && width is double) return width;
    if (maxWidth is double && maxWidth != double.infinity) return maxWidth;
    return defaultWidth;
  }

  double? getRatioImage({double? width, double? height, double? defaultRatio}) {
    if (width is double && height is double) return width / height;

    return defaultRatio;
  }
}
