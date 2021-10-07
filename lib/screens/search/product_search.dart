import 'package:cirilla/mixins/product_mixin.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/app_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/store/product/products_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';
import 'package:cirilla/mixins/unescape_mixin.dart';

class ProductSearchDelegate extends SearchDelegate<String?> {
  ProductSearchDelegate(BuildContext context, TranslateType translate)
      : super(
          searchFieldLabel: translate('product_category_search'),
          searchFieldStyle: Theme.of(context).textTheme.bodyText2,
        );

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back_outlined),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _Search(search: query);
  }

  @override
  Widget buildResults(BuildContext context) {
    AppStore appStore = Provider.of<AppStore>(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    ProductsStore? postStore;
    TranslateType translate = AppLocalizations.of(context)!.translate;

    if (appStore.getStoreByKey('product_search_$query') == null) {
      postStore = ProductsStore(
        Provider.of<RequestHelper>(context),
        search: query,
        key: 'product_search_$query',
        language: settingStore.locale,
      );
    } else {
      postStore = appStore.getStoreByKey('product_search_$query');
      return ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          return ProductSearchItem(product: postStore!.products[index]);
        },
        itemCount: postStore!.products.length,
      );
    }

    return FutureBuilder<List<Product>>(
      future: postStore.refresh(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data!.isNotEmpty
              ? ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    return ProductSearchItem(product: snapshot.data![index]);
                  },
                  itemCount: snapshot.data!.length,
                )
              : NotificationScreen(
                  title: Text(translate('product_search_results')!, style: Theme.of(context).textTheme.headline6),
                  content: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        translate("product_no_products_were_found")!,
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      )),
                  iconData: FeatherIcons.search,
                  textButton: Text(
                    translate('product_clear')!,
                    style: TextStyle(color: Theme.of(context).textTheme.subtitle1!.color),
                  ),
                  styleBtn: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 61),
                      primary: Theme.of(context).colorScheme.surface,
                      shadowColor: Colors.transparent),
                  onPressed: () {
                    query = '';
                  },
                );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      if (query.isEmpty)
        IconButton(
          tooltip: 'Close',
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        )
      else
        IconButton(
          tooltip: 'Clear',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  void close(BuildContext context, String? result) {
    super.close(context, result);
  }
}

class _Search extends StatefulWidget {
  final String? search;

  const _Search({Key? key, this.search}) : super(key: key);

  @override
  __SearchState createState() => __SearchState();
}

class __SearchState extends State<_Search> {
  List<PostSearch> _data = [];
  CancelToken? _token;

  @override
  void dispose() {
    _token?.cancel('cancelled');
    super.dispose();
  }

  Future<void> search(CancelToken? token) async {
    try {
      SettingStore settingStore = Provider.of<SettingStore>(context);
      PostStore _postStore = PostStore(Provider.of<RequestHelper>(context));
      List<PostSearch>? data = await _postStore.search(queryParameters: {
        'search': widget.search,
        'type': 'post',
        'subtype': 'product',
        'lang': settingStore.locale,
        // 'app-builder-search': widget.search,
      }, cancelToken: token);
      setState(() {
        _data = List<PostSearch>.of(data!);
      });
    } catch (e) {
      print('Cancel fetch');
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (_token != null) {
      _token?.cancel('cancelled');
    }

    setState(() {
      _token = CancelToken();
    });

    search(_token);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            Navigator.pushNamed(context, ProductScreen.routeName, arguments: {'id': _data[index].id});
          },
          leading: Icon(FeatherIcons.search),
          title: Text(unescape(_data[index].title!), style: Theme.of(context).textTheme.subtitle2),
        ),
        itemCount: _data.length,
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}

class ProductSearchItem extends StatelessWidget with ProductMixin {
  final Product? product;

  const ProductSearchItem({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: buildImage(context, product: product!, width: 60, height: 60),
      title: buildName(context, product: product!),
      subtitle: buildPrice(context, product: product!),
      onTap: () {
        // close(context, snapshot.data[index].id);
        Navigator.pushNamed(context, ProductScreen.routeName, arguments: {'product': product});
      },
    );
  }
}
