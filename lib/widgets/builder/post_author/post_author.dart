import 'package:cirilla/constants/app.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/post_author/post_author.dart';
import 'package:cirilla/store/post_author/post_author_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_post_author_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'layout/carousel.dart';
import 'layout/two_column.dart';
import 'layout/list.dart';

class PostAuthorWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  PostAuthorWidget({
    Key? key,
    this.widgetConfig,
  }) : super(key: key);

  @override
  _PostAuthorWidgetState createState() => _PostAuthorWidgetState();
}

class _PostAuthorWidgetState extends State<PostAuthorWidget> with Utility, NavigationMixin {
  SettingStore? _settingStore;
  late AppStore _appStore;
  PostAuthorStore? _postAuthorStore;

  @override
  void didChangeDependencies() {
    _appStore = Provider.of<AppStore>(context);
    _settingStore = Provider.of<SettingStore>(context);

    String language = _settingStore?.locale ?? defaultLanguage;
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    int limit = ConvertData.stringToInt(get(fields, ['limit'], '4'));

    String? key = StringGenerate.getPostAuthorKeyStore(
      widget.widgetConfig!.id,
      language: language,
      limit: limit,
    );

    // Add store to list store
    if (widget.widgetConfig != null && _appStore.getStoreByKey(key) == null) {
      PostAuthorStore store = PostAuthorStore(
        _settingStore!.requestHelper,
        perPage: limit,
        lang: language,
        key: key,
      )..getPostAuthors();
      _appStore.addStore(store);
      _postAuthorStore ??= store;
    } else {
      _postAuthorStore = _appStore.getStoreByKey(key);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String themeModeKey = _settingStore?.themeModeKey ?? 'value';

    String layout = widget.widgetConfig?.layout ?? Strings.postAuthorLayoutList;

    // Styles
    Map<String, dynamic> styles = widget.widgetConfig?.styles ?? {};
    Map? margin = get(styles, ['margin'], {});
    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);
    double? height = ConvertData.stringToDouble(get(styles, ['height'], 300), 300);

    // Config general
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    int limit = ConvertData.stringToInt(get(fields, ['limit'], '4'));
    String? template = get(fields, ['template', 'template'], Strings.postAuthorItemVertical);
    Map? dataTemplate = get(fields, ['template', 'data'], {});

    return Observer(builder: (_) {
      if (_postAuthorStore == null) return Container();

      bool loading = _postAuthorStore!.loading;
      List<PostAuthor> postAuthors = _postAuthorStore!.postAuthors;
      List<PostAuthor> emptyPostAuthor = List.generate(limit, (index) => PostAuthor()).toList();

      return Container(
        margin: ConvertData.space(margin, 'margin'),
        color: background,
        height: layout == Strings.postAuthorLayoutCarousel ? height : null,
        child: buildLayout(
          layout: layout,
          postAuthors: loading ? emptyPostAuthor : postAuthors,
          template: template,
          templateData: dataTemplate as Map<String, dynamic>?,
          styles: styles,
        ),
      );
    });
  }

  Widget buildLayout({
    String? layout,
    List<PostAuthor>? postAuthors,
    String? template = Strings.postAuthorItemVertical,
    Map<String, dynamic>? templateData = const {},
    Map<String, dynamic>? styles,
  }) {
    Map? padding = get(styles, ['padding'], {});
    double? pad = ConvertData.stringToDouble(get(styles, ['pad'], 0));

    switch (layout) {
      case Strings.postAuthorLayoutTwoColumn:
        return TwoColumnLayout(
          itemCount: postAuthors!.length,
          axisSpacing: pad,
          buildItem: (BuildContext context, int index, double width) => buildItem(
            context,
            author: postAuthors.elementAt(index),
            template: template,
            templateData: templateData,
            styles: styles,
          ),
          padding: ConvertData.space(padding, 'padding'),
        );
      case Strings.postAuthorLayoutCarousel:
        return CarouselLayout(
          itemCount: postAuthors!.length,
          axisSpacing: pad,
          renderItem: (BuildContext context, int index) => buildItem(
            context,
            author: postAuthors.elementAt(index),
            template: template,
            templateData: templateData,
            styles: styles,
          ),
          padding: ConvertData.space(padding, 'padding'),
        );

      default:
        return ListLayout(
          itemCount: postAuthors!.length,
          axisSpacing: pad,
          buildItem: (BuildContext context, int index, double width) => buildItem(
            context,
            author: postAuthors.elementAt(index),
            template: template,
            templateData: templateData,
            styles: styles,
          ),
          padding: ConvertData.space(padding, 'padding'),
        );
    }
  }

  Widget buildItem(
    BuildContext context, {
    PostAuthor? author,
    String? template,
    Map<String, dynamic>? templateData,
    Map<String, dynamic>? styles,
    double? width,
  }) {
    ThemeData theme = Theme.of(context);
    String themeModeKey = _settingStore?.themeModeKey ?? 'value';

    // config template data

    bool? enableAvatar = get(templateData, ['enableAvatar'], true);
    bool? enableCount = get(templateData, ['enableCount'], true);

    // config styles
    Color background =
        ConvertData.fromRGBA(get(styles, ['backgroundItem', themeModeKey], {}), theme.colorScheme.surface);

    Color textColor = ConvertData.fromRGBA(get(styles, ['textColor', themeModeKey], {}), Colors.black);

    Color subTextColor = ConvertData.fromRGBA(get(styles, ['subTextColor', themeModeKey], {}), Colors.black);

    double? radiusItem = ConvertData.stringToDouble(get(styles, ['radiusItem'], 8));

    // config shadow
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

    return CirillaPostAuthorItem(
      postAuthor: author,
      type: template,
      width: width,
      enableAvatar: enableAvatar,
      enableCount: enableCount,
      background: background,
      textColor: textColor,
      subTextColor: subTextColor,
      radius: radiusItem,
      shadow: [shadow],
    );
  }
}
