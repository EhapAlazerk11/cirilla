import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/mixins/post_mixin.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/builder/post/layout/layout_big_first.dart';
import 'package:cirilla/widgets/cirilla_post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'layout/layout_list.dart';
import 'layout/layout_carousel.dart';
import 'layout/layout_masonry.dart';
import 'layout/layout_slideshow.dart';

class PostWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  PostWidget({
    Key? key,
    this.widgetConfig,
  }) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> with Utility, PostMixin {
  late AppStore _appStore;
  SettingStore? _settingStore;
  PostStore? _postStore;

  @override
  void didChangeDependencies() {
    _appStore = Provider.of<AppStore>(context);
    _settingStore = Provider.of<SettingStore>(context);

    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};

    // Filter
    int limit = ConvertData.stringToInt(get(fields, ['limit'], '4'));
    String? search = get(fields, ['search', _settingStore!.languageKey], '');
    List<dynamic> tags = get(fields, ['tags'], []);
    List<dynamic> categories = get(fields, ['categories'], []);
    List<dynamic> includePost = get(fields, ['post'], []);
    String? postType = get(fields, ['postType'], 'posts');

    // Gen key for store
    List<PostTag> tagsObj = tags.map((t) => PostTag(id: ConvertData.stringToInt(t['key']))).toList();
    List<PostCategory> catsObj = categories.map((t) => PostCategory(id: ConvertData.stringToInt(t['key']))).toList();
    List<Post> includePostObj = includePost.map((t) => Post(id: ConvertData.stringToInt(t['key']))).toList();

    String? key = StringGenerate.getPostKeyStore(
      widget.widgetConfig!.id,
      language: _settingStore!.locale,
      search: search,
      limit: limit,
      tags: tagsObj,
      categories: catsObj,
      includePost: includePostObj,
    );

    // Add store to list store
    if (widget.widgetConfig != null && _appStore.getStoreByKey(key) == null) {
      PostStore store = PostStore(
        _settingStore!.requestHelper,
        lang: _settingStore!.locale,
        key: key,
        perPage: limit,
        search: search,
        tags: tagsObj,
        categories: catsObj,
        include: includePostObj,
        postType: postType,
      )..getPosts();
      _appStore.addStore(store);
      _postStore ??= store;
    } else {
      _postStore = _appStore.getStoreByKey(key);
    }
    super.didChangeDependencies();
  }

  void goDetail(BuildContext context, Post post) {
    Navigator.pushNamed(context, PostScreen.routeName, arguments: {'post': post});
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (_postStore == null) return Container();
        String themeModeKey = _settingStore?.themeModeKey ?? 'value';

        bool loading = _postStore!.loading;
        List<Post> posts = _postStore!.posts;

        // Item style
        WidgetConfig configs = widget.widgetConfig!;

        // Item template
        String layout = configs.layout ?? Strings.postLayoutList;

        // Style
        Map<String, dynamic>? margin = get(configs.styles, ['margin'], {});
        Map<String, dynamic>? padding = get(configs.styles, ['padding'], {});
        Color background =
            ConvertData.fromRGBA(get(configs.styles, ['background', themeModeKey], {}), Colors.transparent);

        double? height = ConvertData.stringToDoubleCanBeNull(get(configs.styles, ['height'], null));

        int limit = ConvertData.stringToInt(get(configs.fields, ['limit'], '4'), 4);

        List<Post> emptyPosts = List.generate(limit, (index) => Post()).toList();

        bool isShimmer = posts.length == 0 && loading;

        return Container(
          margin: ConvertData.space(margin, 'margin'),
          height: layout == Strings.postCategoryLayoutCarousel || layout == Strings.postCategoryLayoutSlideshow
              ? ConvertData.stringToDouble(height, 300)
              : null,
          color: background,
          child: LayoutPostList(
            fields: configs.fields,
            styles: configs.styles,
            posts: isShimmer ? emptyPosts : posts,
            layout: layout,
            padding: ConvertData.space(padding, 'padding'),
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

class LayoutPostList extends StatelessWidget {
  final Map<String, dynamic>? fields;
  final Map<String, dynamic>? styles;
  final List<Post>? posts;
  final String? layout;
  final EdgeInsetsDirectional padding;
  final String themeModeKey;
  final Function? onLoadMore;
  final bool canLoadMore;
  final bool loading;

  LayoutPostList({
    Key? key,
    this.fields = const {},
    this.styles = const {},
    this.posts,
    this.layout = Strings.postLayoutList,
    this.padding = EdgeInsetsDirectional.zero,
    this.themeModeKey = 'value',
    this.onLoadMore,
    this.canLoadMore = false,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // General config
    Map<String, dynamic>? templateItem = get(fields, ['template'], {});
    bool? enableLoadMore = get(fields, ['enableLoadMore'], false);
    String? template = get(fields, ['template', 'template'], Strings.postItemDefault);
    Map<String, dynamic>? dataTemplate = get(fields, ['template', 'data'], {});
    double? width = ConvertData.stringToDouble(get(templateItem, ['data', 'size', 'width'], 100), 100);
    double? height = ConvertData.stringToDouble(get(templateItem, ['data', 'size', 'height'], 100), 100);

    // Styles config
    double? maxHeightImage = ConvertData.stringToDouble(get(styles, ['maxHeightImage'], 300), 300);
    double? pad = ConvertData.stringToDouble(get(styles, ['pad'], 0));
    double? dividerHeight = ConvertData.stringToDouble(get(styles, ['dividerWidth'], 1));
    Color dividerColor = ConvertData.fromRGBA(get(styles, ['dividerColor', themeModeKey], {}), Colors.transparent);
    Color indicatorColor = ConvertData.fromRGBA(
      get(styles, ['indicatorColor', themeModeKey], {}),
      theme.dividerColor,
    );
    Color indicatorActiveColor = ConvertData.fromRGBA(
      get(styles, ['indicatorActiveColor', themeModeKey], {}),
      theme.primaryColor,
    );

    Color backgroundColor = ConvertData.fromRGBA(
      get(styles, ['backgroundColorItem', themeModeKey], {}),
      theme.colorScheme.surface,
    );
    Color textColor = ConvertData.fromRGBA(
      get(styles, ['textColor', themeModeKey], {}),
      theme.textTheme.subtitle1!.color,
    );
    Color subTextColor = ConvertData.fromRGBA(
      get(styles, ['subTextColor', themeModeKey], {}),
      theme.textTheme.caption!.color,
    );
    Color labelColor = ConvertData.fromRGBA(get(styles, ['labelColor', themeModeKey], {}), Color(0xFF21BA45));
    Color labelTextColor = ConvertData.fromRGBA(get(styles, ['labelTextColor', themeModeKey], {}), Colors.white);
    double? labelRadius = ConvertData.stringToDouble(get(styles, ['labelRadius'], 19));
    BorderRadius radius = ConvertData.corn(get(styles, ['radius'], 0));
    double? radiusImage =
        get(styles, ['radiusImage'], null) == null ? null : ConvertData.stringToDouble(get(styles, ['radiusImage'], 8));
    Map valuePaddingContent = get(styles, ['paddingContent'], {});
    EdgeInsetsDirectional? paddingContent = valuePaddingContent.isNotEmpty
        ? ConvertData.space(valuePaddingContent, 'paddingContent', EdgeInsetsDirectional.only(top: 8))
        : null;
    Color shadowColor = ConvertData.fromRGBA(get(styles, ['shadowColor', themeModeKey], {}), Colors.black);
    double offsetX = ConvertData.stringToDouble(get(styles, ['offsetX'], 0));
    double offsetY = ConvertData.stringToDouble(get(styles, ['offsetY'], 4));
    double blurRadius = ConvertData.stringToDouble(get(styles, ['blurRadius'], 24));
    double spreadRadius = ConvertData.stringToDouble(get(styles, ['spreadRadius'], 0));
    BoxShadow shadow = BoxShadow(
      color: shadowColor,
      offset: Offset(offsetX, offsetY),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
    );

    switch (layout) {
      case Strings.postLayoutCarousel:
        return LayoutCarousel(
          posts: posts,
          buildItem: (_, {Post? post, int? index, double? widthView}) => _buildItem(
            context,
            post: post,
            template: template,
            dataTemplate: dataTemplate,
            index: index,
            widthView: widthView,
            width: width,
            height: height,
            backgroundColor: backgroundColor,
            textColor: textColor,
            subTextColor: subTextColor,
            labelColor: labelColor,
            labelTextColor: labelTextColor,
            labelRadius: labelRadius,
            radius: radius,
            radiusImage: radiusImage,
            paddingContent: paddingContent,
            boxShadow: [shadow],
          ),
          pad: pad,
          dividerColor: dividerColor,
          dividerHeight: dividerHeight,
          padding: padding,
          enableLoadMore: enableLoadMore,
          canLoadMore: canLoadMore,
          onLoadMore: onLoadMore,
          loading: loading,
        );
      case Strings.postLayoutMasonry:
        return LayoutMasonry(
          posts: posts,
          buildItem: (_, {Post? post, int? index, double? widthView, double? width, double? height}) => _buildItem(
            context,
            post: post,
            template: template,
            dataTemplate: dataTemplate,
            index: index,
            widthView: widthView,
            width: width,
            height: height,
            backgroundColor: backgroundColor,
            textColor: textColor,
            subTextColor: subTextColor,
            labelColor: labelColor,
            labelTextColor: labelTextColor,
            labelRadius: labelRadius,
            radius: radius,
            radiusImage: radiusImage,
            paddingContent: paddingContent,
            boxShadow: [shadow],
          ),
          pad: pad,
          dividerColor: dividerColor,
          dividerHeight: dividerHeight,
          padding: padding,
          width: width,
          height: height,
          enableLoadMore: enableLoadMore,
          canLoadMore: canLoadMore,
          onLoadMore: onLoadMore,
          loading: loading,
        );
      case Strings.postLayoutBigFirst:
        return LayoutBigFirst(
          posts: posts,
          buildItem: (
            BuildContext context, {
            Post? post,
            int? index,
            double? widthView,
            String? template,
            double? width,
            double? height,
            BorderRadius? radius,
            double? radiusImage,
            EdgeInsetsGeometry? paddingContent,
          }) =>
              _buildItem(
            context,
            post: post,
            template: template,
            dataTemplate: dataTemplate,
            index: index,
            widthView: widthView,
            width: width,
            height: height,
            backgroundColor: backgroundColor,
            textColor: textColor,
            subTextColor: subTextColor,
            labelColor: labelColor,
            labelTextColor: labelTextColor,
            labelRadius: labelRadius,
            radius: radius,
            radiusImage: radiusImage,
            paddingContent: paddingContent as EdgeInsetsDirectional?,
            boxShadow: [shadow],
          ),
          pad: pad,
          dividerColor: dividerColor,
          dividerHeight: dividerHeight,
          template: template,
          padding: padding,
          radius: radius,
          radiusImage: radiusImage,
          paddingContent: paddingContent,
          enableLoadMore: enableLoadMore,
          canLoadMore: canLoadMore,
          onLoadMore: onLoadMore,
          loading: loading,
        );
      case Strings.postLayoutSlideshow:
        return LayoutSlideshow(
          posts: posts,
          buildItem: (_, {Post? post, int? index, double? widthView}) => _buildItem(
            context,
            post: post,
            template: template,
            dataTemplate: dataTemplate,
            index: index,
            widthView: widthView,
            width: width,
            height: height,
            maxHeight: maxHeightImage,
            backgroundColor: backgroundColor,
            textColor: textColor,
            subTextColor: subTextColor,
            labelColor: labelColor,
            labelTextColor: labelTextColor,
            labelRadius: labelRadius,
            radius: radius,
            radiusImage: radiusImage,
            paddingContent: paddingContent,
            boxShadow: [shadow],
          ),
          padding: padding,
          indicatorColor: indicatorColor,
          indicatorActiveColor: indicatorActiveColor,
        );
      default:
        return LayoutList(
          posts: posts,
          buildItem: (_, {Post? post, int? index, double? widthView}) => _buildItem(
            context,
            post: post,
            template: template,
            dataTemplate: dataTemplate,
            index: index,
            widthView: widthView,
            width: width,
            height: height,
            backgroundColor: backgroundColor,
            textColor: textColor,
            subTextColor: subTextColor,
            labelColor: labelColor,
            labelTextColor: labelTextColor,
            labelRadius: labelRadius,
            radius: radius,
            radiusImage: radiusImage,
            paddingContent: paddingContent,
            boxShadow: [shadow],
          ),
          pad: pad,
          dividerColor: dividerColor,
          dividerHeight: dividerHeight,
          padding: padding,
          enableLoadMore: enableLoadMore,
          canLoadMore: canLoadMore,
          onLoadMore: onLoadMore,
          loading: loading,
        );
    }
  }

  Widget _buildItem(
    BuildContext context, {
    Post? post,
    int? index,
    String? template,
    Map<String, dynamic>? dataTemplate,
    double? widthView,
    double? maxHeight,
    double? width = 100,
    double? height = 100,
    Color? backgroundColor,
    Color? textColor,
    Color? subTextColor,
    Color? labelColor,
    Color? labelTextColor,
    double? labelRadius,
    BorderRadius? radius,
    double? radiusImage,
    EdgeInsetsDirectional? paddingContent,
    List<BoxShadow>? boxShadow,
  }) {
    String? alignment = get(dataTemplate, ['alignment'], 'left');

    return CirillaPostItem(
      post: post,
      number: index! + 1,
      template: template,
      dataTemplate: dataTemplate,
      widthItem: widthView,
      width: width,
      height: height,
      maxHeight: maxHeight,
      background: backgroundColor,
      textColor: textColor,
      subTextColor: subTextColor,
      labelColor: labelColor,
      labelTextColor: labelTextColor,
      labelRadius: labelRadius,
      radius: radius,
      radiusImage: radiusImage,
      paddingContent: paddingContent,
      boxShadow: boxShadow,
      isRightImage: (alignment == 'zigzag' && index % 2 == 1) || alignment == 'right',
    );
  }
}
