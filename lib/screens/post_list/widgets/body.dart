import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/post/post.dart';
import 'package:cirilla/models/post/post_category.dart';
import 'package:cirilla/screens/search/post_search.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_post_item.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:cirilla/store/post/post_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';
import 'package:ui/ui.dart';

class Body extends StatefulWidget {
  final PostStore? store;
  final Widget? sort;
  final Widget? refine;
  final bool? loading;
  final Map<String, dynamic>? configs;
  final Map<String, dynamic>? styles;

  const Body({
    Key? key,
    this.store,
    this.sort,
    this.refine,
    this.loading,
    this.configs,
    this.styles,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with LoadingMixin, AppBarMixin, Utility, HeaderListMixin, NavigationMixin {
  // final PostSearchDelegate _delegate = PostSearchDelegate();

  int type = 1;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void updateType(int value) {
    setState(() {
      type = value;
    });
  }

  void _onScroll() {
    if (!_controller.hasClients || widget.loading! || !widget.store!.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      widget.store!.getPosts();
    }
  }

  void removeSelectedCategory(PostCategory category) {
    List<PostCategory?> selected = List<PostCategory?>.of(widget.store!.categorySelected);
    selected.removeWhere((element) => element!.id == category.id);
    widget.store!.onChanged(categorySelected: selected);
  }

  void removeSelectedTag(PostTag tag) {
    List<PostTag?> selected = List<PostTag?>.of(widget.store!.tagSelected);
    selected.removeWhere((element) => element!.id == tag.id);
    widget.store!.onChanged(tagSelected: selected);
  }

  void clearAll() {
    widget.store!.onChanged(tagSelected: [], categorySelected: []);
  }

  Widget buildAppbar(BuildContext context, {required TranslateType translate}) {
    bool enableAppbarSearch = get(widget.configs, ['enableAppbarSearch'], true);
    bool? enableCenterTitle = get(widget.configs, ['enableCenterTitle'], true);
    String? appBarType = get(widget.configs, ['appBarType'], Strings.appbarFloating);
    // bool extendBodyBehindAppBar = get(widget.configs, ['extendBodyBehindAppBar'], true);

    Widget title = Text(translate('post_list_txt')!);

    List<Widget>? actions = enableAppbarSearch
        ? [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: IconButton(
                icon: Icon(FeatherIcons.search),
                iconSize: 20,
                onPressed: () async {
                  final String? selected = await showSearch<String?>(
                    context: context,
                    delegate: PostSearchDelegate(context, translate),
                  );
                  print(selected);
                },
              ),
            )
          ]
        : null;
    return SliverAppBar(
      leading: leading(),
      title: title,
      floating: appBarType == Strings.appbarFloating,
      elevation: 0,
      primary: true,
      centerTitle: enableCenterTitle,
      actions: actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    List<Post> posts = widget.store!.posts;

    bool isFilter = widget.store!.categorySelected.length > 0 || widget.store!.tagSelected.length > 0;
    print(posts.length);
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      controller: _controller,
      slivers: <Widget>[
        buildAppbar(context, translate: translate),
        SliverPersistentHeader(
          pinned: false,
          floating: true,
          delegate: StickyTabBarDelegate(
            child: buildHeader(context, translate: translate),
          ),
        ),
        if (isFilter)
          SliverPadding(
            padding: EdgeInsets.only(top: 24),
            sliver: SliverPersistentHeader(
              pinned: false,
              floating: true,
              delegate: StickyTabBarDelegate(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: ListView(
                      padding: EdgeInsetsDirectional.only(start: 20, end: 12),
                      scrollDirection: Axis.horizontal,
                      children: [
                        InputChip(
                          label: Text(translate('product_clear_all')!),
                          deleteIcon: Icon(FeatherIcons.x, size: 16),
                          onPressed: clearAll,
                          labelPadding: EdgeInsets.zero,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          backgroundColor: Colors.transparent,
                          labelStyle: theme.textTheme.caption!
                              .copyWith(fontWeight: FontWeight.w500, color: theme.textTheme.subtitle1!.color),
                          side: BorderSide(width: 2, color: theme.dividerColor),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        SizedBox(width: 8),
                        ...List.generate(widget.store!.categorySelected.length, (index) {
                          PostCategory cat = widget.store!.categorySelected[index]!;

                          return Padding(
                            padding: EdgeInsetsDirectional.only(end: 8),
                            child: InputChip(
                              label: Row(
                                children: [
                                  Text(cat.name!),
                                  SizedBox(width: 8),
                                  Icon(Icons.clear, size: 14),
                                ],
                              ),
                              onPressed: () => removeSelectedCategory(cat),
                              labelPadding: EdgeInsets.zero,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              backgroundColor: theme.colorScheme.surface,
                              labelStyle: theme.textTheme.caption!
                                  .copyWith(fontWeight: FontWeight.w500, color: theme.textTheme.subtitle1!.color),
                              side: BorderSide(width: 2, color: theme.dividerColor),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ),
                          );
                        }).toList(),
                        ...List.generate(widget.store!.tagSelected.length, (index) {
                          PostTag tag = widget.store!.tagSelected[index]!;
                          return Padding(
                            padding: EdgeInsetsDirectional.only(end: 8),
                            child: InputChip(
                              label: Row(
                                children: [
                                  Text(tag.name!),
                                  SizedBox(width: 8),
                                  Icon(Icons.clear, size: 14),
                                ],
                              ),
                              onPressed: () => removeSelectedTag(tag),
                              labelPadding: EdgeInsets.zero,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              backgroundColor: theme.colorScheme.surface,
                              labelStyle: theme.textTheme.caption!
                                  .copyWith(fontWeight: FontWeight.w500, color: theme.textTheme.subtitle1!.color),
                              side: BorderSide(width: 2, color: theme.dividerColor),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                height: 34,
              ),
            ),
          ),
        CupertinoSliverRefreshControl(
          onRefresh: widget.store!.refresh,
          builder: buildAppRefreshIndicator,
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          sliver: posts.length == 0 || posts.isEmpty
              ? SliverToBoxAdapter(child: LayoutBuilder(
                  builder: (_, BoxConstraints constraints) {
                    if (widget.loading! && posts.isEmpty)
                      return Column(
                        children: List.generate(
                            10,
                            (index) => _Post(
                                  post: Post(),
                                  type: type,
                                  styles: widget.styles,
                                )),
                      );
                    return NotificationScreen(
                      title: Text(
                        translate('post')!,
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                      content: Text(
                        translate('post_no_posts_were_found_matching')!,
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.center,
                      ),
                      iconData: FeatherIcons.rss,
                      textButton: Text(translate('post_category')!),
                      onPressed: () => navigate(context, {
                        "type": "tab",
                        "router": "/",
                        "args": {"key": "screens_category"}
                      }),
                    );
                  },
                ))
              : SliverList(
                  // Use a delegate to build items as they're scrolled on screen.
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _Post(
                        post: widget.loading! && posts.length == 0 ? Post() : posts[index],
                        type: type,
                        styles: widget.styles,
                      );
                    },
                    childCount: widget.loading! && posts.length == 0 ? 10 : posts.length,
                  ),
                ),
        ),
        if (widget.loading! && posts.length != 0)
          SliverToBoxAdapter(
            child: buildLoading(context, isLoading: widget.store!.canLoadMore),
          ),
      ],
    );
  }

  Widget buildHeader(BuildContext context, {required TranslateType translate}) {
    return buildBoxHeader(
      context,
      left: Row(
        children: [
          buildButtonIcon(context, icon: FeatherIcons.barChart2, title: translate('product_list_sort')!, onPressed: () {
            showModalBottomSheet(
              // isScrollControlled: true,
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              builder: (context) {
                // Using Wrap makes the bottom sheet height the height of the content.
                // Otherwise, the height will be half the height of the screen.
                return widget.sort!;
              },
            );
          }),
          SizedBox(width: 8),
          buildButtonIcon(
            context,
            icon: FeatherIcons.sliders,
            title: translate('product_list_refine')!,
            onPressed: () async {
              Map<String, dynamic>? data = await showModalBottomSheet<Map<String, dynamic>>(
                isScrollControlled: true,
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                builder: (context) {
                  // Using Wrap makes the bottom sheet height the height of the content.
                  // Otherwise, the height will be half the height of the screen.
                  return widget.refine!;
                },
              );
              if (data == null) return;

              widget.store!.onChanged(
                categorySelected: data['categories'],
                tagSelected: data['tags'],
              );
            },
          ),
        ],
      ),
      right: buildGroupButtonIcon(
        context,
        icons: [FeatherIcons.square, FeatherIcons.list],
        visitSelect: type,
        onChange: (int value) => setState(() {
          type = value;
        }),
      ),
    );
  }
}

class _Post extends StatelessWidget with Utility {
  final Post? post;
  final int type;
  final Map<String, dynamic>? styles;

  const _Post({
    Key? key,
    this.post,
    this.type = 1,
    this.styles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    Color textColor = ConvertData.fromRGBA(
      get(styles, ['textColor', themeModeKey], {}),
      Theme.of(context).textTheme.subtitle1!.color,
    );
    Color subTextColor = ConvertData.fromRGBA(
      get(styles, ['subTextColor', themeModeKey], {}),
      Theme.of(context).textTheme.caption!.color,
    );
    Color labelColor = ConvertData.fromRGBA(get(styles, ['labelColor', themeModeKey], {}), Color(0xFF21BA45));
    Color labelTextColor = ConvertData.fromRGBA(get(styles, ['labelTextColor', themeModeKey], {}), Colors.white);
    double? labelRadius = ConvertData.stringToDouble(get(styles, ['labelRadius'], 0));
    double? radiusImage = ConvertData.stringToDouble(get(styles, ['radiusImage'], 8));

    String typeTemplate = type == 1 ? Strings.postItemHorizontal : Strings.postItemDefault;
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      double width = constraints.maxWidth;
      double height = typeTemplate == Strings.postItemHorizontal ? width : (width * 260) / 335;
      return Column(
        children: [
          CirillaPostItem(
            post: post,
            width: width,
            height: height,
            template: typeTemplate,
            textColor: textColor,
            subTextColor: subTextColor,
            labelColor: labelColor,
            labelTextColor: labelTextColor,
            labelRadius: labelRadius,
            radiusImage: radiusImage,
            background: Colors.transparent,
          ),
          Divider(
            height: 40,
            thickness: 1,
          ),
        ],
      );
    });
  }
}
