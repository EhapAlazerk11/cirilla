import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/post_wishlist/post_wishlist_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin PostWishListMixin<T extends StatefulWidget> on State<T> {
  bool loading = false;

  PostWishListStore? _postWishListStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _postWishListStore = Provider.of<AuthStore>(context).postWishListStore;
  }

  Future<void> addWishList({int? postId}) async {
    setState(() {
      loading = true;
    });
    try {
      await _postWishListStore!.addWishList(postId.toString());
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

  bool existWishList({int? postId}) {
    return _postWishListStore!.exist(postId.toString());
  }
}
