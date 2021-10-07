import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';

class RehubVersusTable extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const RehubVersusTable({Key? key, this.block}) : super(key: key);

  Widget buildItem(
    BuildContext context, {
    Map? item,
    double? maxWidth,
    TextAlign? textAlign,
    Color? color,
    required ThemeData theme,
  }) {
    String? type = get(item, ['type'], 'text');
    String content = get(item, ['content'], '');
    String? image = get(item, ['image'], '');
    bool isGrey = get(item, ['isGrey'], false);
    Widget child = Text(
      content,
      textAlign: textAlign,
      style: theme.textTheme.subtitle2!.copyWith(color: color),
    );
    if (type == 'image') {
      double? size = maxWidth! > 70 ? 70 : maxWidth;
      child = CirillaCacheImage(image, width: size, height: size);
    }
    if (type == 'tick') {
      child = Icon(FeatherIcons.checkCircle, size: 22, color: Color(0xFF21BA45));
    }
    if (type == 'times') {
      child = Icon(FeatherIcons.xCircle, size: 22, color: Color(0xFFF01F0E));
    }
    return isGrey ? Opacity(opacity: 0.6, child: child) : child;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    String heading = get(attrs, ['heading'], translate('post_detail_versus_title'));
    String subheading = get(attrs, ['subheading'], translate('post_detail_versus_subline'));
    String? type = get(attrs, ['type'], 'two');
    Map? firstColumn = get(attrs, ['firstColumn'], {});
    Map? secondColumn = get(attrs, ['secondColumn'], {});
    Map? thirdColumn = get(attrs, ['thirdColumn'], {});

    Color? bg = get(attrs, ['bg'], '') != '' ? ConvertData.fromHex(get(attrs, ['bg'], '')) : null;
    Color? color = get(attrs, ['color'], '') != '' ? ConvertData.fromHex(get(attrs, ['color'], '')) : null;
    int column = type == 'three' ? 3 : 2;
    List<Map?> table = [firstColumn, secondColumn, thirdColumn];

    return VersusTable(
      title: heading.isNotEmpty
          ? Text(
              heading,
              style: theme.textTheme.headline6!.copyWith(color: color ?? null),
              textAlign: TextAlign.center,
            )
          : null,
      subtitle: subheading.isNotEmpty
          ? Text(
              subheading,
              style: theme.textTheme.bodyText2!.copyWith(color: color != null ? color.withOpacity(0.5) : null),
              textAlign: TextAlign.center,
            )
          : null,
      column: column,
      buildItem: (int index, double maxWidth, TextAlign textAlign) {
        return buildItem(
          context,
          item: table[index],
          maxWidth: maxWidth,
          textAlign: textAlign,
          theme: theme,
          color: color,
        );
      },
      separator: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: theme.colorScheme.surface, shape: BoxShape.circle),
        child: Text(
          translate('post_detail_vs')!.toUpperCase(),
          style: theme.textTheme.subtitle2!.copyWith(color: theme.colorScheme.onSurface),
        ),
      ),
      color: bg,
      padding: color != null ? EdgeInsets.all(16) : EdgeInsets.zero,
    );
  }
}
