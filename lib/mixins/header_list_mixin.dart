import 'package:flutter/material.dart';

mixin HeaderListMixin {
  Widget buildBoxHeader(
    BuildContext context, {
    double? height,
    Color? color,
    double? paddingHorizontal,
    Widget? left,
    Widget? right,
  }) {
    return Container(
      height: height ?? 58,
      color: color ?? Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal ?? 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [left ?? Container(), right ?? Container()],
      ),
    );
  }

  Widget buildButtonIcon(
    BuildContext context, {
    required String title,
    IconData? icon,
    double? paddingHorizontal,
    VoidCallback? onPressed,
    double height = 58,
  }) {
    ThemeData theme = Theme.of(context);

    return SizedBox(
      height: height,
      child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal ?? 8),
          child: Row(
            children: [
              Icon(icon, color: theme.primaryColor, size: 20),
              SizedBox(width: 8),
              Text(title),
            ],
          ),
        ),
        style: TextButton.styleFrom(
          primary: theme.colorScheme.onSurface,
          padding: EdgeInsets.zero,
          minimumSize: Size(0, height),
          textStyle: theme.textTheme.bodyText2,
        ),
      ),
    );
  }

  Widget buildGroupButtonIcon(
    BuildContext context, {
    required List<IconData> icons,
    int? visitSelect,
    ValueChanged<int>? onChange,
  }) {
    ThemeData theme = Theme.of(context);
    return Row(
      children: List.generate(icons.length, (index) {
        return IconButton(
          icon: Icon(icons.elementAt(index)),
          iconSize: 20,
          color: index == visitSelect ? theme.primaryColor : theme.colorScheme.onSurface,
          constraints: BoxConstraints(minWidth: 36, maxWidth: 36),
          splashRadius: 18,
          onPressed: () {
            if (index != visitSelect) {
              onChange!(index);
            }
          },
        );
      }),
    );
  }
}
