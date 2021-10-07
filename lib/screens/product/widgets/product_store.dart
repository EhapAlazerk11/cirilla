import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/widgets/cirilla_vendor_item.dart';
import 'package:flutter/material.dart';

class ProductStore extends StatelessWidget {
  final Product? product;

  const ProductStore({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Vendor vendor = product is Product && product!.store is Map && product!.store!.isNotEmpty
        ? Vendor.fromJson(product!.store!)
        : Vendor();
    if (vendor.id == null) {
      return Container();
    }
    return CirillaVendorItem(
      vendor: vendor,
      color: Theme.of(context).colorScheme.surface,
    );
  }
}
