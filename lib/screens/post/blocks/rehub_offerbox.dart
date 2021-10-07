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

class RehubOfferbox extends StatelessWidget with Utility, BlockMixin {
  final Map<String, dynamic>? block;

  const RehubOfferbox({Key? key, this.block}) : super(key: key);

  void share(String? url) {
    if (url is String && url != '') {
      launch(url);
    }
  }

  Widget buildButton({Map? attrs, ThemeData? theme, required TranslateType translate}) {
    String couponCode = get(attrs, ['coupon_code'], '');
    bool? maskCoupon = get(attrs, ['mask_coupon_code'], false);
    String? textButton = get(attrs, ['button', 'text'], translate('post_detail_offerbox_button'));
    String? urlButton = get(attrs, ['button', 'url'], '');
    String? maskText = get(attrs, ['mask_coupon_text'], translate('post_detail_offerbox_reveal'));
    String expireDate = get(attrs, ['expiration_date'], '');

    bool checkExpire = expireDate.isNotEmpty ? compareSpaceDate(date: expireDate, space: 0) : true;

    return buildButtonCoupon(
      coupon: couponCode,
      textButton: textButton!.capitalizeFirstofEach,
      maskCoupon: maskCoupon,
      checkExpire: checkExpire,
      maskCouponText: maskText,
      expireDate: expireDate,
      onButton: () => share(urlButton),
      onButtonCoupon: () => print('coupon'),
      theme: theme,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    Map? attrs = get(block, ['attrs'], {});

    String strBorderColor = get(attrs, ['borderColor'], '');
    Color? borderColor = strBorderColor.isNotEmpty ? ConvertData.fromHex(strBorderColor, Colors.transparent) : null;
    String? urlImage = get(attrs, ['thumbnail', 'url'], '');
    String? salePrice = get(attrs, ['sale_price'], '');
    String? oldPrice = get(attrs, ['old_price'], '');
    String? name = get(attrs, ['name'], '');
    String? disclaimer = get(attrs, ['disclaimer'], '');
    String? description = get(attrs, ['description'], '');
    int discount = ConvertData.stringToInt(get(attrs, ['discount_tag'], 0), 0);
    int rating = ConvertData.stringToInt(get(attrs, ['rating'], 0), 0);

    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        double screenWidth = MediaQuery.of(context).size.width;
        double itemWidth = maxWidth is double && maxWidth != double.infinity ? maxWidth : screenWidth;
        EdgeInsets padding = borderColor != null ? EdgeInsets.all(16) : EdgeInsets.zero;
        double widthImage = itemWidth - padding.right - padding.left;
        double heightImage = (widthImage * 200) / 335;

        return SizedBox(
          width: itemWidth,
          child: OfferBox(
            image: urlImage!.isNotEmpty || discount > 0
                ? Stack(
                    children: [
                      if (urlImage.isNotEmpty)
                        CirillaCacheImage(urlImage, width: widthImage, height: heightImage)
                      else
                        Container(),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Badge(
                          text: Text(
                            '-$discount%',
                            style: theme.textTheme.overline!.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                          color: Color(0xFFF01F0E),
                        ),
                      )
                    ],
                  )
                : null,
            title: name!.isNotEmpty ? Text(name, style: theme.textTheme.subtitle1) : null,
            disclaimer: disclaimer!.isNotEmpty
                ? Text(
                    disclaimer,
                    style: theme.textTheme.caption!.copyWith(color: Color(0xFF21BA45)),
                  )
                : null,
            rating: rating > 0 ? CirillaRating(initialValue: rating.toDouble()) : null,
            price: buildPrice(currentPrice: salePrice, oldPrice: oldPrice, theme: theme),
            buttonCoupon: buildButton(
              attrs: attrs,
              theme: theme,
              translate: translate,
            ),
            description: description!.isNotEmpty ? Text(description, style: theme.textTheme.bodyText2) : null,
            borderColor: borderColor,
            padding: padding,
          ),
        );
      },
    );
  }
}
