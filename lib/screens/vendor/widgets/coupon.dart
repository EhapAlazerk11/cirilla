import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class CouponWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {'name': 'FREE Shipping Coupon', 'expire_date': 'April 30, 2021', 'coupon': 'FGDRT555444'},
      {'name': 'Percentage discount: 10', 'expire_date': 'April 30, 2021', 'coupon': 'Black Friday'},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(data.length, (index) {
        Map<String, dynamic> item = data.elementAt(index);
        return Column(
          children: [
            buildItem(context, name: item['name'], expireDate: item['expire_date'], coupon: item['coupon']),
            Divider(
              height: 48,
              thickness: 1,
            ),
          ],
        );
      }),
    );
  }

  Widget buildItem(BuildContext context, {required String name, String? expireDate, required String coupon}) {
    ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: theme.textTheme.caption!.copyWith(color: theme.textTheme.subtitle1!.color)),
              Text('Expiry Date: $expireDate', style: theme.textTheme.caption),
            ],
          ),
        ),
        SizedBox(
          height: 34,
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(8),
            padding: EdgeInsets.zero,
            color: theme.primaryColor,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(coupon),
              style: ElevatedButton.styleFrom(
                primary: theme.primaryColor.withOpacity(0.1),
                onPrimary: theme.primaryColor,
                elevation: 0,
                shadowColor: Colors.transparent,
                textStyle: theme.textTheme.caption,
              ),
            ),
          ),
        )
      ],
    );
  }
}
