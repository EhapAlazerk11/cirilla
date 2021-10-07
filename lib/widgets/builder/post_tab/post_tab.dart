import 'package:cirilla/constants/app.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/mixins/post_mixin.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';

import '../post/post.dart';

class PostTabWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  PostTabWidget({
    Key? key,
    this.widgetConfig,
  }) : super(key: key);

  @override
  _PostTabWidgetState createState() => _PostTabWidgetState();
}

class _PostTabWidgetState extends State<PostTabWidget> with Utility, SingleTickerProviderStateMixin {
  SettingStore? _settingStore;
  TabController? _tabController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    List items = get(fields, ['items'], []);
    _tabController = TabController(vsync: this, length: items.length);
  }

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    super.didChangeDependencies();
  }

  void _onChanged(index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String themeModeKey = _settingStore?.themeModeKey ?? 'value';
    String lang = _settingStore?.locale ?? defaultLanguage;

    // Styles
    Map<String, dynamic> styles = widget.widgetConfig?.styles ?? {};
    Map? margin = get(styles, ['margin'], {});
    Map? padding = get(styles, ['padding'], {});
    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);

    // Config general
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    double? pad = ConvertData.stringToDouble(get(fields, ['pad'], '0'));
    bool? enableDrawer = get(fields, ['enableDrawer'], false);
    List items = get(fields, ['items'], []);

    if (items.length < 1) {
      return Container();
    }

    String idPosts = '${widget.widgetConfig!.id}_$_index';

    return Container(
      margin: ConvertData.space(margin, 'margin'),
      padding: ConvertData.space(padding, 'padding'),
      color: background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (enableDrawer!) ...[
                InkWell(
                  onTap: () => ZoomDrawer.of(context)!.toggle(),
                  child: Icon(
                    FeatherIcons.menu,
                    size: 20,
                    color: theme.textTheme.headline6!.color,
                  ),
                ),
                SizedBox(width: 32),
              ],
              Expanded(
                child: Theme(
                    data: theme.copyWith(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                    child: TabBar(
                      labelPadding: EdgeInsetsDirectional.only(end: 32),
                      onTap: _onChanged,
                      isScrollable: true,
                      labelColor: theme.primaryColor,
                      controller: _tabController,
                      labelStyle: theme.textTheme.subtitle2,
                      unselectedLabelColor: theme.textTheme.subtitle2!.color,
                      indicatorWeight: 2,
                      indicatorPadding: EdgeInsetsDirectional.only(end: 32),
                      indicatorColor: theme.primaryColor,
                      tabs: List.generate(
                        items.length,
                        (inx) {
                          Map<String, dynamic> item = items[inx];
                          String name = ConvertData.stringFromConfigs(get(item, ['data', 'name'], ''), lang)!;
                          return Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(name.toUpperCase()),
                          );
                        },
                      ).toList(),
                    )),
              ),
            ],
          ),
          if (items[_index]['data'] is Map<String, dynamic>) ...[
            SizedBox(height: pad),
            PostListWidget(
              id: idPosts,
              key: Key(idPosts),
              fields: items[_index]['data'],
              styles: styles,
            ),
          ],
        ],
      ),
    );
  }
}

class PostListWidget extends StatefulWidget {
  final String? id;
  final Map<String, dynamic>? fields;
  final Map<String, dynamic> styles;

  PostListWidget({
    Key? key,
    this.id,
    this.fields = const {},
    this.styles = const {},
  }) : super(key: key);

  @override
  _PostListWidgetState createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> with Utility, PostMixin {
  late AppStore _appStore;
  SettingStore? _settingStore;
  PostStore? _postStore;

  @override
  void didChangeDependencies() {
    _appStore = Provider.of<AppStore>(context);
    _settingStore = Provider.of<SettingStore>(context);

    String lang = _settingStore?.locale ?? defaultLanguage;

    int limit = ConvertData.stringToInt(get(widget.fields, ['limit'], '4'));

    String? search = get(widget.fields, ['search', _settingStore!.languageKey], '');
    List<dynamic> tags = get(widget.fields, ['tags'], []);
    List<dynamic> categories = get(widget.fields, ['categories'], []);
    List<dynamic> post = get(widget.fields, ['post'], []);

    // Gen key for store
    String keyTags = tags.map((e) => e['key']).join('_');
    String keyCategories = categories.map((e) => e['key']).join('_');
    String keyPosts = post.map((e) => e['key']).join('_');

    String key = '${widget.id}_${search}_${keyTags}_${keyCategories}_$keyPosts';

    // Add store to list store
    if (widget.id != null && _appStore.getStoreByKey(key) == null) {
      PostStore store = PostStore(
        _settingStore!.requestHelper,
        key: key,
        perPage: limit,
        search: search,
        tags: tags.map((t) => PostTag(id: ConvertData.stringToInt(t['key']))).toList(),
        categories: categories.map((t) => PostCategory(id: ConvertData.stringToInt(t['key']))).toList(),
        include: post.map((t) => Post(id: ConvertData.stringToInt(t['key']))).toList(),
        lang: lang,
      )..getPosts();
      _appStore.addStore(store);
      _postStore ??= store;
    } else {
      _postStore = _appStore.getStoreByKey(key);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        String themeModeKey = _settingStore?.themeModeKey ?? 'value';

        bool loading = _postStore!.loading;
        List<Post> posts = _postStore!.posts;

        // Fields config
        double? height = ConvertData.stringToDoubleCanBeNull(get(widget.styles, ['height'], 300));

        // Item template
        String? layout = get(widget.fields, ['layoutItem'], Strings.postLayoutList);

        // general config
        int limit = ConvertData.stringToInt(get(widget.fields, ['limit'], 4));
        List<Post> emptyPost = List.generate(limit, (index) => Post()).toList();
        bool isShimmer = posts.length == 0 && loading;

        return Container(
          height: layout == Strings.postLayoutCarousel || layout == Strings.postLayoutSlideshow
              ? ConvertData.stringToDouble(height)
              : null,
          child: LayoutPostList(
            fields: widget.fields,
            styles: widget.styles,
            posts: isShimmer ? emptyPost : posts,
            padding: EdgeInsetsDirectional.zero,
            layout: layout,
            themeModeKey: themeModeKey,
            onLoadMore: () => _postStore!.getPosts(),
            canLoadMore: _postStore!.canLoadMore,
            loading: loading,
          ),
        );
      },
    );
  }
}
