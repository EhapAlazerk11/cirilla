import 'package:cirilla/constants/app.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/search/post_search.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';

import 'widgets/layout_default.dart';

class PostCategoryScreen extends StatefulWidget {
  static const routeName = '/post_category';

  @override
  _PostCategoryScreenState createState() => _PostCategoryScreenState();
}

class _PostCategoryScreenState extends State<PostCategoryScreen> with AppBarMixin, LoadingMixin {
  SettingStore? _settingStore;
  late PostCategoryStore _postCategoryStore;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);

    String language = _settingStore?.locale ?? defaultLanguage;

    _postCategoryStore = PostCategoryStore(_settingStore!.requestHelper, lang: language, perPage: 10);

    if (!_postCategoryStore.loading) {
      _postCategoryStore.getPostCategories();
    }

    super.didChangeDependencies();
  }

  void onPressed(BuildContext context) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    await showSearch<String?>(
      context: context,
      delegate: PostSearchDelegate(context, translate),
    );
  }

  Widget renderSearch(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return InkWell(
      onTap: () => onPressed(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: theme.dividerColor),
        ),
        child: Row(
          children: [
            Icon(FeatherIcons.search, size: 16),
            SizedBox(width: 16),
            Expanded(child: Text(translate('post_category_search')!, style: theme.textTheme.bodyText1)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String layout = 'default';

    return Scaffold(
      body: Observer(
        builder: (_) {
          List<PostCategory> emptyData = List.generate(10, (index) => PostCategory());
          switch (layout) {
            default:
              return LayoutDefault(
                loading: _postCategoryStore.loading,
                postCategories: !_postCategoryStore.loading && _postCategoryStore.postCategories.length > 0
                    ? _postCategoryStore.postCategories
                    : emptyData,
                refresh: _postCategoryStore.refresh,
                canLoadMore: _postCategoryStore.canLoadMore,
                search: renderSearch(context),
              );
          }
        },
      ),
    );
  }
}
