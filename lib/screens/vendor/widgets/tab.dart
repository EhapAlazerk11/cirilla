import 'package:cirilla/types/types.dart';
import 'package:flutter/material.dart';
import 'package:ui/tab/sticky_tab_bar_delegate.dart';

class TabWidget extends StatelessWidget {
  final List<String>? tabs;
  final TranslateType? translate;
  final TabController? controller;
  final Function(String value)? onChanged;

  TabWidget({Key? key, this.tabs, this.translate, this.controller, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: StickyTabBarDelegate(
        child: Container(
          color: theme.scaffoldBackgroundColor,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 32, bottom: 24),
          child: TabBar(
            labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            onTap: (int index) => onChanged!(tabs!.elementAt(index)),
            isScrollable: true,
            labelColor: theme.primaryColor,
            controller: controller,
            labelStyle: theme.textTheme.subtitle2,
            unselectedLabelColor: theme.textTheme.subtitle2!.color,
            indicatorWeight: 2,
            indicatorColor: theme.primaryColor,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
            tabs: List.generate(tabs!.length, (index) {
              String keyTab = tabs!.elementAt(index);
              return Text(translate!('vendor_detail_$keyTab')!.toUpperCase());
            }),
          ),
        ),
        height: 80,
      ),
    );
  }
}
