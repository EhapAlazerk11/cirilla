import 'package:cirilla/store/cart/cart_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin CartMixin<T extends StatefulWidget> on State<T> {
  bool loading = false;

  late CartStore _cartStore;

  @override
  void didChangeDependencies() {
    _cartStore = Provider.of<CartStore>(context);
    super.didChangeDependencies();
  }

  Future<void> addToCart({int? productId, int? qty, List<dynamic>? variation}) async {
    setState(() {
      loading = true;
    });
    try {
      await _cartStore.addToCart({
        'id': productId,
        'quantity': qty,
        'variation': variation,
      });
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      throw e;
    }
  }
}
