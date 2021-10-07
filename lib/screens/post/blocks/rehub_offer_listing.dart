import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';
import 'package:ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cirilla/extension/strings.dart';

class OfferListing extends StatelessWidget with Utility, BlockMixin {
  final Map<String, dynamic>? block;

  const OfferListing({Key? key, this.block}) : super(key: key);

  void share(String? url) {
    if (url is String && url != '') {
      launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    List offers = get(attrs, [
      'offers'
    ], [
      {
        "score": 10,
        "enableBadge": true,
        "enableScore": true,
        "thumbnail": {
          "url": "",
        },
        "title": "Post name",
        "copy": "Content",
        "customBadge": {"text": "Best Values", "textColor": "#fff", "backgroundColor": "#77B21D"},
        "currentPrice": "",
        "oldPrice": "",
        "button": {"text": translate('post_detail_offerbox_button'), "url": "", "newTab": false, "noFollow": false},
        "coupon": "",
        "maskCoupon": false,
        "maskCouponText": translate('post_detail_offerbox_reveal'),
        "expirationDate": "",
        "readMore": "Read full review",
        "readMoreUrl": "",
        "disclaimer": "Disclaimer text...."
      }
    ]);

    if (offers.length < 1) return Container();

    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        double screenWidth = MediaQuery.of(context).size.width;
        double itemWidth = maxWidth == double.infinity ? screenWidth : maxWidth;
        double widthImage = itemWidth - 32;
        double heightImage = (widthImage * 180) / 303;

        return ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (_, int index) {
            dynamic item = offers[index];
            bool enableScore = get(item, ['enableScore'], true);
            bool enableBadge = get(item, ['enableBadge'], true);
            double? score = ConvertData.stringToDouble(get(item, ['score'], 0));
            String? image = get(item, ['thumbnail', 'url'], '');
            String title = get(item, ['title'], '');
            String copy = get(item, ['copy'], '');
            String disclaimer = get(item, ['disclaimer'], '');
            String? currentPrice = get(item, ['currentPrice'], '');
            String? oldPrice = get(item, ['oldPrice'], '');
            String? textBadge = get(item, ['customBadge', 'text'], '');
            Color? backgroundBadge =
                ConvertData.fromHex(get(item, ['customBadge', 'backgroundColor'], '#77b21d'), Color(0xFF77b21d));
            Color? colorBadge = ConvertData.fromHex(get(item, ['customBadge', 'textColor'], '#fff'), Colors.white);
            String coupon = get(attrs, ['coupon'], '');
            bool? maskCoupon = get(attrs, ['maskCoupon'], false);
            String? textButton = get(item, ['button', 'text'], translate('post_detail_offerbox_button'));
            String? urlButton = get(attrs, ['button', 'url'], '');
            String? maskCouponText = get(attrs, ['maskCouponText'], translate('post_detail_offerbox_reveal'));
            String expirationDate = get(attrs, ['expirationDate'], '');

            bool checkExpire = expirationDate.isNotEmpty ? compareSpaceDate(date: expirationDate, space: 0) : true;

            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: OfferListingItem(
                image: Stack(
                  children: [
                    CirillaCacheImage(
                      image,
                      width: widthImage,
                      height: heightImage,
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: enableScore && score > 0
                          ? Padding(
                              padding: EdgeInsets.all(8),
                              child: buildCircleNumber(number: score, theme: theme),
                            )
                          : Container(),
                    ),
                  ],
                ),
                name: title.isNotEmpty ? Text(title, style: theme.textTheme.subtitle1) : null,
                description: copy.isNotEmpty ? Text(copy, style: theme.textTheme.bodyText2) : null,
                price: buildPrice(currentPrice: currentPrice, oldPrice: oldPrice, theme: theme),
                badge: enableBadge && textBadge!.isNotEmpty
                    ? Badge(
                        text: Text(
                          textBadge,
                          style: theme.textTheme.overline!.copyWith(color: colorBadge),
                        ),
                        color: backgroundBadge,
                      )
                    : null,
                disclaimer: disclaimer.isNotEmpty
                    ? Text(
                        disclaimer,
                        style: theme.textTheme.caption!.copyWith(color: theme.textTheme.subtitle1!.color),
                      )
                    : null,
                button: buildButtonCoupon(
                  coupon: coupon,
                  textButton: textButton!.capitalizeFirstofEach,
                  maskCoupon: maskCoupon,
                  checkExpire: checkExpire,
                  maskCouponText: maskCouponText,
                  expireDate: expirationDate,
                  onButton: () => share(urlButton),
                  onButtonCoupon: () => print('coupon'),
                  theme: theme,
                ),
                color: theme.scaffoldBackgroundColor,
                disclaimerColor: theme.colorScheme.surface,
                width: itemWidth,
                padding: EdgeInsets.all(16),
              ),
            );
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
