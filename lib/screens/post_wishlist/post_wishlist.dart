import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/post_list/post_list.dart';
import 'package:cirilla/store/post_wishlist/post_wishlist_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/string_generate.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_post_item.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/dismissible/dismissible_item.dart';
import 'package:ui/notification/notification_screen.dart';

class PostWishlistScreen extends StatefulWidget {
  @override
  _PostWishlistScreenState createState() => _PostWishlistScreenState();
}

class _PostWishlistScreenState extends State<PostWishlistScreen> with NavigationMixin, LoadingMixin {
  late SettingStore _settingStore;
  PostStore? _postStore;
  late AppStore _appStore;
  PostWishListStore? _postWishListStore;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _postWishListStore = Provider.of<AuthStore>(context).postWishListStore;
    _appStore = Provider.of<AppStore>(context);

    List<Post> postWishList = _postWishListStore!.data.map((String id) => Post(id: int.parse(id))).toList();

    String? key = StringGenerate.getPostKeyStore(
      'wishlist_post',
      includePost: postWishList,
      language: _settingStore.locale,
    );

    if (_appStore.getStoreByKey(key) == null) {
      PostStore store = PostStore(
        _settingStore.requestHelper,
        include: postWishList,
        key: key,
        // language: _settingStore.locale,
        // currency: _settingStore.currency,
      )..getPosts();

      _appStore.addStore(store);
      _postStore ??= store;
    } else {
      _postStore = _appStore.getStoreByKey(key);
    }

    super.didChangeDependencies();
  }

  void refresh() {
    setState(() {});
  }

  void dismissItem(
    BuildContext context,
    int index,
    DismissDirection direction,
    Post post,
  ) {
    String id = _postWishListStore!.data[index];

    _postWishListStore!.addWishList(id);

    final snackBar = SnackBar(
      content: Text(
          AppLocalizations.of(context)!.translate('post_wishlist_notification_deleted', {'name': post.postTitle})!),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.translate('v')!,
        onPressed: () {
          _postWishListStore!.addWishList(id, position: index);
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Observer(builder: (_) {
      List<Post> posts = _postStore!.posts;
      String themeModeKey = _settingStore.themeModeKey;

      Data? data = _settingStore.data!.screens!['postWishlist'];
      WidgetConfig? widgetConfig = data != null ? data.widgets!['postWishlistPage'] : null;

      Map? styles = widgetConfig != null ? widgetConfig.styles : {};
      Color textColor =
          ConvertData.fromRGBA(get(styles, ['textColor', themeModeKey], {}), theme.textTheme.subtitle1!.color);
      Color subTextColor =
          ConvertData.fromRGBA(get(styles, ['subTextColor', themeModeKey], {}), theme.colorScheme.onSurface);
      Color labelColor = ConvertData.fromRGBA(get(styles, ['labelColor', themeModeKey], {}), Color(0xFF21BA45));
      Color labelTextColor = ConvertData.fromRGBA(get(styles, ['labelTextColor', themeModeKey], {}), Colors.white);
      double? labelRadius = ConvertData.stringToDouble(get(styles, ['labelRadius'], 19), 19);
      double? radiusImage = ConvertData.stringToDouble(get(styles, ['radiusImage'], 8), 8);

      return Scaffold(
        appBar: _buildAppbar(context) as PreferredSizeWidget?,
        body: _postWishListStore!.data.isEmpty
            ? _buildNoWishList(context)
            : ListView(
                children: List.generate(
                  _postWishListStore!.data.length,
                  (index) {
                    Post post = posts.firstWhere(
                      (p) => '${p.id}' == _postWishListStore!.data[index],
                      orElse: () => Post(),
                    );
                    return DismissibleItem(
                      item: post,
                      onDismissed: (direction) => dismissItem(context, index, direction, post),
                      confirmDismiss: (DismissDirection direction) => Future.value(true),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                            child: CirillaPostItem(
                              post: post,
                              template: Strings.postItemHorizontal,
                              width: 120,
                              height: 120,
                              textColor: textColor,
                              subTextColor: subTextColor,
                              labelColor: labelColor,
                              labelTextColor: labelTextColor,
                              labelRadius: labelRadius,
                              radiusImage: radiusImage,
                            ),
                          ),
                          Divider(height: 1, thickness: 1),
                        ],
                      ),
                    );
                  },
                ),
              ),
      );
    });
  }

  Widget _buildAppbar(BuildContext context, {bool centerTitle = true}) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    int count = _postWishListStore!.count;
    String textTranslate = count > 1 ? 'post_wishlist_items' : 'post_wishlist_item';

    return AppBar(
      title: Column(
        children: [
          Text(translate('post_wishlist_txt')!),
          Text(
            translate(
              textTranslate,
              {'count': count.toString()},
            )!,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
      centerTitle: centerTitle,
      elevation: 0,
      titleSpacing: 20,
    );
  }

  Widget _buildNoWishList(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return NotificationScreen(
      iconData: FeatherIcons.heart,
      title: Container(
        width: 147,
        child: Text(
          translate('post_wishlist_empty')!,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      content: Container(
        width: 220,
        child: Text(
          translate('post_wishlist_empty_description')!,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      textButton: Text(translate('post_wishlist_btn_post_list')!),
      onPressed: () => Navigator.of(context).pushNamed(PostListScreen.routeName),
    );
  }
}
