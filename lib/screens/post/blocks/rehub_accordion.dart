import 'package:cirilla/mixins/mixins.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';

class RehubAccordion extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const RehubAccordion({Key? key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};

    List tabs = get(attrs, ['tabs'], []);
    if (tabs.isEmpty) {
      return Container();
    }
    return Accordion(
      count: tabs.length,
      icon: FeatherIcons.plus,
      activeIcon: FeatherIcons.minus,
      buildTitle: (int index) {
        Map tab = tabs.elementAt(index);
        String title = get(tab, ['title'], '');
        return Text(title, style: theme.textTheme.subtitle2);
      },
      buildExpansion: (int index) {
        Map tab = tabs.elementAt(index);
        String content = get(tab, ['content'], '');
        return Text(content, style: theme.textTheme.bodyText2);
      },
      color: theme.textTheme.subtitle1!.color,
      dividerColor: theme.dividerColor,
    );
  }
}
