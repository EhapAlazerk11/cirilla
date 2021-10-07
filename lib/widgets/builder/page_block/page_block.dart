import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/post/blocks/blocks.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageBlockWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  PageBlockWidget({
    Key? key,
    required this.widgetConfig,
  }) : super(key: key);

  @override
  _PageBlockWidgetState createState() => _PageBlockWidgetState();
}

class _PageBlockWidgetState extends State<PageBlockWidget> with Utility, LoadingMixin {
  SettingStore? _settingStore;
  bool _loading = true;
  PageData? _page;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);

    // Styles
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    int idPage = ConvertData.stringToInt(get(fields, ['page', 'key'], 0));

    if (idPage > 0) {
      getPage(idPage);
    } else {
      setState(() {
        _loading = false;
      });
    }
    super.didChangeDependencies();
  }

  Future<void> getPage(int id) async {
    try {
      _page = await Provider.of<RequestHelper>(context).getPageDetail(idPage: id);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String themeModeKey = _settingStore?.themeModeKey ?? 'value';

    // Styles
    Map<String, dynamic> styles = widget.widgetConfig?.styles ?? {};
    Map<String, dynamic>? margin = get(styles, ['margin'], {});
    Map<String, dynamic>? padding = get(styles, ['padding'], {});
    Map<String, dynamic>? background = get(styles, ['background', themeModeKey], {});

    return Container(
      margin: ConvertData.space(margin, 'margin'),
      padding: ConvertData.space(padding, 'padding'),
      color: ConvertData.fromRGBA(background, Colors.transparent),
      child: _page != null && _page!.blocks!.isNotEmpty
          ? Column(
              children:
                  List.generate(_page!.blocks!.length, (index) => PostBlock(block: _page!.blocks!.elementAt(index))),
            )
          : _loading
              ? entryLoading(context)
              : null,
    );
  }
}
