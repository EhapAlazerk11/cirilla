import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/app_bar_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
// import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class AppbarVendor extends StatelessWidget with AppBarMixin, VendorMixin {
  final TranslateType? translate;
  final String? viewAppbar;
  final Vendor? vendor;
  final bool? enableCenterTitle;
  AppbarVendor({Key? key, this.translate, this.viewAppbar, this.vendor, this.enableCenterTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = (width * 219) / 375;

    double heightPlus = 32;

    BoxDecoration decorationBoxImage = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter, // 10% of the width, so there are ten blinds.
        colors: <Color>[
          Colors.black,
          Colors.transparent,
        ], // red to yellowepeats the gradient over the canvas
      ),
    );
    Widget positionInfo = Positioned(
      bottom: 0,
      left: 20,
      right: 20,
      child: buildItem(
        context,
        vendor: vendor,
        color: theme.cardColor,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        radius: 8,
        boxShadow: initBoxShadow,
      ),
    );

    if (viewAppbar == 'opacity') {
      heightPlus = 0;
      decorationBoxImage = BoxDecoration(
        color: Colors.black.withOpacity(0.7),
      );
      positionInfo = Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: buildItem(
          context,
          vendor: vendor,
          colorName: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          radius: 8,
          boxShadow: initBoxShadow,
        ),
      );
    }

    double heightView = height + heightPlus;

    return SliverPersistentHeader(
      pinned: false,
      floating: false,
      delegate: StickyTabBarDelegate(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      vendor?.banner != null && vendor!.banner!.isNotEmpty ? vendor!.banner! : Assets.noImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              margin: EdgeInsets.only(bottom: heightPlus),
            ),
            Container(
              decoration: decorationBoxImage,
              margin: EdgeInsets.only(bottom: heightPlus),
            ),
            positionInfo,
            Positioned(
              child: Column(
                children: [
                  AppBar(
                    title: Text(
                      translate!('vendor_detail_txt')!,
                      style: theme.appBarTheme.titleTextStyle!.copyWith(color: Colors.white),
                    ),
                    centerTitle: enableCenterTitle,
                    leading: leading(color: Colors.white),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    actions: [Container()],
                  ),
                ],
              ),
            ),
          ],
        ),
        height: heightView,
      ),
    );
  }

  Widget buildItem(
    BuildContext context, {
    Vendor? vendor,
    EdgeInsetsGeometry? padding,
    Color? color,
    Color? colorName,
    List<BoxShadow>? boxShadow,
    double? radius,
  }) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: color, boxShadow: boxShadow, borderRadius: BorderRadius.circular(radius ?? 0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildName(context, vendor: vendor, theme: theme, color: colorName),
                SizedBox(height: 11),
                buildRating(context, vendor: vendor, theme: theme),
              ],
            ),
          ),
          SizedBox(width: 16),
          buildImage(context, vendor: vendor),
        ],
      ),
    );
  }
}
