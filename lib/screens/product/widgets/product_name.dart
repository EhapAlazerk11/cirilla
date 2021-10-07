import 'package:cirilla/models/product/product.dart';
import 'package:flutter/material.dart';

class ProductName extends StatelessWidget {
  final Product? product;
  final String? align;

  const ProductName({
    Key? key,
    this.product,
    this.align = 'left',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _productName(context, product: product!);
  }

  Widget _productName(BuildContext context, {required Product product}) {
    TextAlign textAlign = align == 'center'
        ? TextAlign.center
        : align == 'right'
            ? TextAlign.end
            : TextAlign.start;
    return Text(
      product.name!,
      style: Theme.of(context).textTheme.headline6,
      textAlign: textAlign,
    );
  }
}
