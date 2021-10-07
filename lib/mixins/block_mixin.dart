import 'package:cirilla/utils/convert_data.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui/ui.dart';

mixin BlockMixin {
  Widget buildCircleNumber({
    dynamic number,
    Color? color,
    Color? textColor,
    double? size,
    required ThemeData theme,
  }) {
    double value = ConvertData.stringToDouble(number, 10);
    return Badge(
      text: Text(
        value.truncateToDouble() == value ? value.toStringAsFixed(0) : '$value',
        style: theme.textTheme.subtitle2!.copyWith(color: textColor ?? Colors.white),
      ),
      color: color ?? Color(0xFF21BA45),
      size: size ?? 40,
    );
  }

  Widget? buildPrice({
    String? currentPrice,
    String? oldPrice,
    Color? color,
    required ThemeData theme,
  }) {
    if (currentPrice == null || currentPrice.isEmpty) {
      return null;
    }
    TextStyle? style = theme.textTheme.subtitle1;
    if (oldPrice != null && oldPrice.isNotEmpty) {
      return Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            currentPrice,
            style: style!.copyWith(color: color ?? Color(0xFFF01F0E)),
          ),
          if (oldPrice.isNotEmpty)
            Text(
              oldPrice,
              style: style.copyWith(color: theme.textTheme.bodyText2!.color, decoration: TextDecoration.lineThrough),
            ),
        ],
      );
    }
    return Text(currentPrice, style: style!.copyWith(color: color));
  }

  Widget buildButtonCoupon({
    required String coupon,
    String? textButton,
    bool? maskCoupon,
    required bool checkExpire,
    String? maskCouponText,
    String? expireDate,
    Function? onButton,
    Function? onButtonCoupon,
    ThemeData? theme,
  }) {
    Widget button = !checkExpire || !maskCoupon!
        ? SizedBox(
            height: 34,
            width: double.infinity,
            child: ElevatedButton(
              child: Text(textButton!),
              onPressed: onButton as void Function()?,
            ),
          )
        : SizedBox(
            height: 34,
            width: double.infinity,
            child: ElevatedButton(
              child: Text(maskCouponText!),
              onPressed: onButtonCoupon as void Function()?,
            ),
          );

    Widget? couponWidget = coupon.isNotEmpty && (!checkExpire || !maskCoupon!)
        ? GestureDetector(
            onTap: checkExpire ? () => onButtonCoupon!() : null,
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(8),
              padding: EdgeInsets.symmetric(horizontal: 16),
              dashPattern: [4, 3],
              color: theme!.dividerColor,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Text(
                        coupon,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.subtitle2!.copyWith(
                          color: checkExpire ? Color(0xFF21BA45) : theme.dividerColor,
                          decoration: !checkExpire ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 0,
                    bottom: 0,
                    end: 0,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Icon(
                        FontAwesomeIcons.copy,
                        size: 16,
                        color: !checkExpire ? theme.dividerColor : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : null;

    String textDate = !checkExpire ? 'Expired' : 'date';
    Widget? date = coupon.isNotEmpty && expireDate != null && expireDate.isNotEmpty
        ? Text(textDate, style: theme!.textTheme.caption)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        button,
        if (couponWidget is Widget) ...[
          SizedBox(height: 16),
          couponWidget,
        ],
        if (date is Widget) ...[
          SizedBox(height: 4),
          date,
        ]
      ],
    );
  }
}
