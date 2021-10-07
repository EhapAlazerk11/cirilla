import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabBasicWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  TabBasicWidget({
    Key? key,
    required this.widgetConfig,
  }) : super(key: key);

  @override
  _TabBasicWidgetState createState() => _TabBasicWidgetState();
}

class _TabBasicWidgetState extends State<TabBasicWidget> with Utility, TickerProviderStateMixin {
  SettingStore? _settingStore;
  TabController? _tabController;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    List items = get(fields, ['items'], []);
    super.didChangeDependencies();
    _tabController = TabController(vsync: this, length: items.length);
  }

  @override
  void didUpdateWidget(covariant TabBasicWidget oldWidget) {
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    List items = get(fields, ['items'], []);
    Map<String, dynamic> oldFields = oldWidget.widgetConfig?.fields ?? {};
    List oldItems = get(oldFields, ['items'], []);
    if (items.length != oldItems.length) {
      setState(() {
        _tabController = TabController(vsync: this, length: items.length);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String themeModeKey = _settingStore?.themeModeKey ?? 'value';
    String languageKey = _settingStore?.languageKey ?? 'text';

    // Styles
    Map<String, dynamic> styles = widget.widgetConfig?.styles ?? {};
    Map<String, dynamic> margin = get(styles, ['margin'], {});
    Map<String, dynamic> padding = get(styles, ['padding'], {});
    Map background = get(styles, ['background', themeModeKey], {});
    double contentHeight = ConvertData.stringToDouble(get(styles, ['contentHeight'], 300));
    Color tabColor = ConvertData.fromRGBA(get(styles, ['tabColor', themeModeKey], {}), theme.colorScheme.onSurface);
    Color selectTabColor = ConvertData.fromRGBA(get(styles, ['selectTabColor', themeModeKey], {}), theme.primaryColor);
    Color contentTextColor =
        ConvertData.fromRGBA(get(styles, ['contentTextColor', themeModeKey], {}), theme.textTheme.subtitle2?.color);

    // General config
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    List items = get(fields, ['items'], []);

    Color backgroundColor = ConvertData.fromRGBA(background, Colors.transparent);

    return Container(
      margin: ConvertData.space(margin, 'margin'),
      padding: ConvertData.space(padding, 'padding'),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Theme(
            data: theme.copyWith(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            child: TabBar(
              labelPadding: EdgeInsetsDirectional.only(end: 32),
              isScrollable: true,
              labelColor: selectTabColor,
              controller: _tabController,
              labelStyle: theme.textTheme.subtitle2,
              unselectedLabelColor: tabColor,
              indicatorWeight: 2,
              indicatorColor: selectTabColor,
              indicatorPadding: EdgeInsetsDirectional.only(end: 32),
              tabs: List.generate(
                items.length,
                (inx) {
                  String name = get(items[inx], ['data', 'title', languageKey], 'item');
                  return Container(
                    height: 33,
                    alignment: Alignment.center,
                    child: Text(
                      name.toUpperCase(),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: contentHeight,
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                items.length,
                (index) {
                  String text = get(items[index], ['data', 'content', languageKey], '');
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Text(
                      text,
                      style: theme.textTheme.subtitle2?.copyWith(color: contentTextColor),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
