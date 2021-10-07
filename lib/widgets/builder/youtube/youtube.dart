import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cirilla/models/models.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/store/store.dart';

class YoutubeWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;
  YoutubeWidget({
    Key? key,
    required this.widgetConfig,
  }) : super(key: key);
  @override
  _YoutubeWidgetState createState() => _YoutubeWidgetState();
}

class _YoutubeWidgetState extends State<YoutubeWidget> with Utility {
  @override
  Widget build(BuildContext context) {
    SettingStore settingStore = Provider.of<SettingStore>(context);

    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};

    dynamic uri = Uri.parse(get(fields, ['url', 'text'], ''));

    String? id = uri.queryParameters['v'];

    Map<String, dynamic> styles = widget.widgetConfig?.styles ?? {};
    String themeModeKey = settingStore.themeModeKey;
    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);

    double? height = ConvertData.stringToDouble(get(fields, ["height"], 315), 315);
    double? width = ConvertData.stringToDouble(get(fields, ["width"], 560), 560);

    Map? padding = get(styles, ['padding'], {});
    Map? margin = get(styles, ['margin'], {});

    return Container(
        padding: ConvertData.space(padding, 'padding'),
        margin: ConvertData.space(margin, 'margin'),
        color: background,
        child: LayoutBuilder(
          builder: (_, BoxConstraints constraints) {
            double widthView = constraints.maxWidth;
            double heightView = widthView * height / width;

            return Html(
                data:
                    '<iframe width="$widthView" height="$heightView" src="https://www.youtube.com/embed/$id"></iframe>');
          },
        ));
  }
}
