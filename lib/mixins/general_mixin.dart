import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/store/store.dart';

import 'utility_mixin.dart' show get;

class GeneralMixin {
  dynamic getConfig(SettingStore store, List<String> paths, [dynamic defaultValue]) {
    final WidgetConfig? widgetConfig =
        store.data != null ? store.data!.settings!['general']!.widgets!['general'] : null;
    final Map<String, dynamic>? fields = widgetConfig != null ? widgetConfig.fields : {};
    return get(fields, paths, defaultValue);
  }
}
