import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/screens/home/home.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import 'utility_mixin.dart' show get;

class NavigationMixin {
  void navigate(BuildContext context, Map<String, dynamic>? data) {
    print(data);

    SettingStore settingStore = Provider.of<SettingStore>(context, listen: false);
    Map<String, dynamic>? action = data;

    // User changed language
    if (settingStore.languageKey != 'text') {
      action = get(data, [settingStore.locale], data);
    }

    String? type = get(action, ['type'], 'tab');
    if (type == 'none') return;

    String? route = get(action, ['route'], '/');
    if (route == 'none') return;

    Map<String, dynamic>? args = get(action, ['args'], {});

    if (type == 'tab') {
      String? tab = get(action, ['args', 'key'], Strings.tabActive);
      SettingStore store = Provider.of<SettingStore>(context, listen: false);
      store.setTab(tab);
      Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
      if (ZoomDrawer.of(context) != null && ZoomDrawer.of(context)!.isOpen()) {
        ZoomDrawer.of(context)!.toggle();
      }
    } else if (type == 'launcher') {
      String url = get(args, ['url'], '/');
      launch(url);
    } else if (type == 'share') {
      String content = get(args, ['content'], '');
      String? subject = get(args, ['subject'], null);
      Share.share(content, subject: subject);
    } else {
      Navigator.of(context).pushNamed(route!, arguments: args);
    }
  }
}
