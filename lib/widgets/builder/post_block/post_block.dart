import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/post/blocks/blocks.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostBlockWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  PostBlockWidget({
    Key? key,
    required this.widgetConfig,
  }) : super(key: key);

  @override
  _PostBlockWidgetState createState() => _PostBlockWidgetState();
}

class _PostBlockWidgetState extends State<PostBlockWidget> with Utility, LoadingMixin {
  SettingStore? _settingStore;
  bool _loading = true;
  Post? _post;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);

    // Styles
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    int idPost = ConvertData.stringToInt(get(fields, ['post', 'key'], 0));

    if (idPost > 0) {
      getPost(idPost);
    } else {
      setState(() {
        _loading = false;
      });
    }
    super.didChangeDependencies();
  }

  Future<void> getPost(int id) async {
    try {
      _post = await Provider.of<RequestHelper>(context).getPost(id: id);
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
      child: _post != null && _post!.blocks!.isNotEmpty
          ? Column(
              children:
                  List.generate(_post!.blocks!.length, (index) => PostBlock(block: _post!.blocks!.elementAt(index))),
            )
          : _loading
              ? entryLoading(context)
              : null,
    );
  }
}
