import 'package:cirilla/constants/app.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:cirilla/widgets/cirilla_cache_image.dart';

class DefaultItem extends StatelessWidget with Utility {
  final Map<String, dynamic>? item;
  final Size? size;
  final Color background;
  final double? radius;
  final Function(Map<String, dynamic>? action) onClick;
  final String language;
  final String themeModeKey;

  DefaultItem({
    Key? key,
    required this.item,
    required this.onClick,
    this.size = const Size(375, 330),
    this.background = Colors.transparent,
    this.radius = 0,
    this.language = defaultLanguage,
    this.themeModeKey = 'value',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic image = get(item, ['image'], '');
    String? linkImage = ConvertData.imageFromConfigs(image, language);

    Map<String, dynamic>? action = get(item, ['action'], {});
    String? typeAction = get(action, ['type'], 'none');
    BoxFit fit = ConvertData.toBoxFit(get(item, ['imageSize'], 'cover'));

    Widget imageWidget = CirillaCacheImage(
      linkImage,
      width: size!.width,
      height: size!.height,
      fit: fit,
    );
    return Container(
      width: size!.width,
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(radius!)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: typeAction != 'none'
          ? InkWell(
              onTap: () => onClick(action),
              child: imageWidget,
            )
          : imageWidget,
    );
  }
}
