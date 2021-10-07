import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cirilla/extension/strings.dart';

class OfferListingFull extends StatelessWidget with Utility, BlockMixin {
  final Map<String, dynamic>? block;

  const OfferListingFull({Key? key, this.block}) : super(key: key);

  Widget buildBadge({
    required String text,
    Color? color,
    required Color background,
    required ThemeData theme,
  }) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                color: background,
                constraints: BoxConstraints(minHeight: 19),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 2, 5, 2),
                  child: Text(
                    text.toUpperCase(),
                    style: theme.textTheme.overline!.copyWith(color: color),
                  ),
                ),
              ),
            ),
            Container(
              height: 19,
              width: 11,
              decoration: BoxDecoration(
                // color: background,
                border: BorderDirectional(
                  bottom: BorderSide(width: 19, color: background),
                  end: BorderSide(width: 11, color: Colors.transparent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExpand(
    BuildContext context, {
    required String label,
    String? content,
    Color? color,
    Color? background,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: () async {
        showModalBottomSheet(
          // isScrollControlled: true,
          context: context,
          backgroundColor: Colors.transparent,
          useRootNavigator: true,
          isScrollControlled: true,
          enableDrag: false,
          // shape: borderRadiusTop(),
          builder: (_) {
            Size size = MediaQuery.of(context).size;
            double widthItem = size.width - 48;
            double minHeight = size.height / 2;
            double maxHeight = size.height - 150;

            return Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: widthItem,
                    constraints: BoxConstraints(
                      minHeight: minHeight,
                      maxHeight: maxHeight,
                    ),
                    decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: AlignmentDirectional.centerEnd,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 42,
                              height: 42,
                              alignment: Alignment.center,
                              child: Icon(
                                FeatherIcons.x,
                                color: color,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              content!,
                              style: theme.textTheme.subtitle1!.copyWith(color: color),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: 42),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Text(
        label,
        style: theme.textTheme.bodyText2!.copyWith(color: theme.primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    List offers = get(attrs, ['offers'], []);
    if (offers.isEmpty) {
      return Container();
    }

    // bool enableScore = get(attrs, ['enableScore'], true);
    // bool enableScoreIcon = get(attrs, ['enableScore'], false);
    // bool colorScore = get(attrs, ['colorScore'], false);
    bool? enableNumber = get(attrs, ['enableNumber'], false);
    bool? enableExpand = get(attrs, ['enableexpand'], false);

    String? expandlabel = get(attrs, ['expandlabel'], 'More info +');

    Color? numberbgcolor = ConvertData.fromHex(get(attrs, ['numberbgcolor'], ''), Color(0xFF21BA45));
    Color? numbercolor = ConvertData.fromHex(get(attrs, ['numbercolor'], ''), Colors.white);
    Color? highlightcolor = ConvertData.fromHex(get(attrs, ['highlightcolor'], ''), Color(0xFF334dfe));
    Color? disclaimerbg = ConvertData.fromHex(get(attrs, ['disclaimerbg'], ''), theme.colorScheme.surface);
    Color? disclaimercolor = ConvertData.fromHex(get(attrs, ['disclaimercolor'], ''), theme.textTheme.subtitle1!.color);
    Color? titleColor = ConvertData.fromHex(get(attrs, ['titleColor'], ''), theme.textTheme.subtitle1!.color);
    Color? priceColor = ConvertData.fromHex(get(attrs, ['priceColor'], ''), Color(0xFFcf2e2e));
    Color? expandColor = ConvertData.fromHex(get(attrs, ['expandcolor'], ''), theme.textTheme.subtitle1!.color);
    Color? expandBg = ConvertData.fromHex(get(attrs, ['expandbg'], ''), theme.cardColor);

    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        double screenWidth = MediaQuery.of(context).size.width;
        double width = maxWidth is double && maxWidth != double.infinity ? maxWidth : screenWidth;
        double widthImage = width - 32;
        double heightImage = (widthImage * 180) / 303;

        return ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (_, int index) {
            dynamic item = offers[index];
            String? image = get(item, ['thumbnail', 'url'], '');
            bool highlight = get(item, ['highlight'], false);

            bool enableBadge = get(item, ['enableBadge'], true);
            String? textBadge = get(item, ['customBadge', 'text'], '');
            Color? colorBadge = ConvertData.fromHex(get(attrs, ['customBadge', 'textColor'], ''), Colors.white);
            Color? backgroundBadge =
                ConvertData.fromHex(get(attrs, ['customBadge', 'backgroundColor'], ''), Color(0xFF334dfe));

            String title = get(item, ['title'], '');

            String url = get(item, ['button', 'url'], '');

            String? currentPrice = get(item, ['currentPrice'], '');
            String? oldPrice = get(item, ['oldPrice'], '');

            String copy = get(item, ['copy'], '');

            String disclaimer = get(item, ['disclaimer'], '');

            String? expandcontent = get(item, ['expandcontent'], '');

            String couponCode = get(item, ['couponCode'], '');

            String expirationDate = get(item, ['expirationDate'], '');
            String textButton = get(item, ['button', 'text'], 'buy now');

            bool checkExpire = expirationDate.isNotEmpty ? compareSpaceDate(date: expirationDate, space: 0) : true;

            String score = get(item, ['score'], '');

            Widget itemWidget = ListingBuilderItem(
              image: Stack(
                children: [
                  CirillaCacheImage(
                    image,
                    width: widthImage,
                    height: heightImage,
                  ),
                  enableBadge && textBadge!.isNotEmpty
                      ? buildBadge(
                          text: textBadge,
                          color: colorBadge,
                          background: backgroundBadge!,
                          theme: theme,
                        )
                      : Container(),
                ],
              ),
              title: title.isNotEmpty
                  ? InkWell(
                      onTap: () => launch(url),
                      child: Text(
                        title,
                        style: theme.textTheme.subtitle1!.copyWith(color: titleColor),
                      ),
                    )
                  : null,
              score: score.isNotEmpty
                  ? Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.dividerColor,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            child: Text(
                              score,
                              style: theme.textTheme.subtitle1,
                            ),
                          ),
                        ),
                        Container(
                          color: Color(0xFF21BA45),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 3,
                          ),
                          child: Text(
                            translate('listing_excilent') ?? '',
                            style: theme.textTheme.overline,
                          ),
                        )
                      ],
                    )
                  : null,
              content: copy.isNotEmpty ? Text(copy, style: theme.textTheme.bodyText2) : null,
              price: buildPrice(currentPrice: currentPrice, oldPrice: oldPrice, color: priceColor, theme: theme),
              disclaimer: disclaimer.isNotEmpty
                  ? Text(disclaimer, style: theme.textTheme.caption!.copyWith(color: disclaimercolor))
                  : null,
              expand: enableExpand! && expandlabel!.isNotEmpty && expandcontent!.isNotEmpty
                  ? buildExpand(
                      context,
                      label: expandlabel,
                      content: expandcontent,
                      color: expandColor,
                      background: expandBg,
                      theme: theme,
                    )
                  : null,
              button: buildButtonCoupon(
                coupon: couponCode,
                textButton: textButton.capitalizeFirstofEach,
                maskCoupon: false,
                maskCouponText: '',
                checkExpire: checkExpire,
                expireDate: expirationDate,
                onButton: () => launch(url),
                onButtonCoupon: () {
                  Clipboard.setData(ClipboardData(text: couponCode));
                },
                theme: theme,
              ),
              width: width,
              border: Border.all(width: 2, color: highlight ? highlightcolor! : Colors.transparent),
              background: theme.scaffoldBackgroundColor,
              colorDisclaimer: disclaimerbg!,
            );

            if (enableNumber!) {
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: itemWidget,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: buildCircleNumber(
                      number: index + 1,
                      color: numberbgcolor,
                      textColor: numbercolor,
                      theme: theme,
                      size: 32,
                    ),
                  )
                ],
              );
            }
            return itemWidget;
          },
          separatorBuilder: (_, int index) {
            return SizedBox(height: 24);
          },
          itemCount: offers.length,
        );
      },
    );
  }
}
