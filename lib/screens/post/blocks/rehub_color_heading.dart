import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';

class RehubColorHeading extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const RehubColorHeading({Key? key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};

    String title = get(attrs, ['title'], '');
    String? subtitle = get(attrs, ['subtitle'], '');
    if (title.isEmpty && subtitle!.isEmpty) {
      return Container();
    }
    Color backgroundColor = ConvertData.fromHex(get(attrs, ['backgroundColor'], '#ebf2fc'))!;
    Color? titleColor = ConvertData.fromHex(get(attrs, ['titleColor'], '#111111'));
    Color? subtitleColor = ConvertData.fromHex(get(attrs, ['subtitleColor'], '#111111'));

    return ColorHeading(
      background: backgroundColor,
      title: title.isNotEmpty
          ? Text(
              title,
              style: theme.textTheme.headline6!.copyWith(color: titleColor),
            )
          : null,
      subtitle: subtitle!.isNotEmpty
          ? Text(
              subtitle,
              style: theme.textTheme.subtitle2!.copyWith(color: subtitleColor),
            )
          : null,
    );
  }
}
