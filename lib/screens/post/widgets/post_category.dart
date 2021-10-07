import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostCategory extends StatelessWidget with PostMixin {
  final Post? post;
  final Map<String, dynamic>? styles;

  PostCategory({
    Key? key,
    this.post,
    this.styles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    Color backgroundCategory =
        ConvertData.fromRGBA(get(styles, ['backgroundCategory', themeModeKey], {}), Color(0xFF21BA45));
    Color colorCategory = ConvertData.fromRGBA(get(styles, ['colorCategory', themeModeKey], {}), Colors.white);
    double? radiusCategory = ConvertData.stringToDouble(get(styles, ['radiusCategory'], 19));
    return buildCategory(theme, post!, false, backgroundCategory, colorCategory, radiusCategory);
  }
}
