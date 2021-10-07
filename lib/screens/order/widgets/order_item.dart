import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/models/order/order.dart';
import 'package:cirilla/utils/currency_format.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class OrderItem extends StatefulWidget {
  final int? quantity;
  final String? name;
  final int? price;
  final Function? onClick;
  final String? currencySymbol;
  final String? currency;
  final String? sku;
  final LineItems? productData;
  OrderItem({
    this.name,
    this.price,
    this.onClick,
    this.currencySymbol,
    this.currency,
    this.sku,
    this.productData,
    this.quantity,
  });
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> with Utility {
  @override
  Widget build(BuildContext context) {
    String name = get(widget.productData!.name, [], '');

    int? quantity = get(widget.productData!.quantity, [], 0);

    String? price = get(widget.productData!.subtotal, [], '');

    String? sku = get(widget.productData!.sku, [], '');

    TextTheme theme = Theme.of(context).textTheme;
    return Column(
      children: [
        ProductCartItem(
          name: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  child: Text(
                name,
                style: theme.bodyText2!.copyWith(color: Theme.of(context).textTheme.subtitle1!.color),
              )),
              Text(' x ${quantity.toString()}', style: theme.bodyText2)
            ],
          ),
          price: Text(
            '${formatCurrency(context, price: price, symbol: widget.currencySymbol, currency: widget.currency)}',
            style: theme.subtitle2,
          ),
          attribute: Table(
            columnWidths: const <int, TableColumnWidth>{
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(),
            },
            children: [
              ...List.generate(widget.productData!.metaData!.length, (index) {
                Map<String, dynamic> metaData = widget.productData!.metaData!.elementAt(index);
                var displayKey = get(metaData, ['display_key'], '');
                var value = get(metaData, ['display_value'], '');
                return TableRow(children: [
                  !displayKey.startsWith('_')
                      ? Text("$displayKey : ", style: Theme.of(context).textTheme.caption)
                      : Container(),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: itemPaddingMedium),
                    child: !displayKey.startsWith('_')
                        ? Text(value,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Theme.of(context).textTheme.subtitle1!.color))
                        : Container(),
                  )
                ]);
              }),
              if (sku != '')
                TableRow(children: [
                  Text('sku : ', style: Theme.of(context).textTheme.caption),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: itemPaddingMedium),
                    child: Text(sku!,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Theme.of(context).textTheme.subtitle1!.color)),
                  )
                ])
            ],
          ),
          onClick: () => widget.onClick!(),
          padding: EdgeInsets.symmetric(vertical: itemPaddingLarge),
        ),
        Divider(
          height: 0,
          thickness: 1,
        ),
      ],
    );
  }
}
