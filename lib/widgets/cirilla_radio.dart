import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class CirillaRadio extends StatelessWidget {
  final bool? isSelect;
  final ValueChanged<bool>? onChange;
  final Color? selectColor;
  final Color? color;

  CirillaRadio({
    Key? key,
    this.isSelect = true,
    this.onChange,
    this.color,
    this.selectColor,
  }) : super(key: key);

  factory CirillaRadio.iconCheck({
    bool? isSelect,
    ValueChanged<bool>? onChange,
    Color? selectColor,
    Color? color,
    Color? iconColor,
  }) = _CirillaRadioIconCheck;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color colorItem = color ?? theme.dividerColor;
    Color colorActiveItem = selectColor ?? Color(0xFF21BA45);
    double widthBorder = isSelect! ? 7 : 2;
    Widget radio = Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(width: widthBorder, color: isSelect! ? colorActiveItem : colorItem),
        shape: BoxShape.circle,
      ),
    );
    return onChange != null
        ? GestureDetector(
            onTap: () => onChange!(!isSelect!),
            child: radio,
          )
        : radio;
  }
}

class _CirillaRadioIconCheck extends CirillaRadio {
  final Color? iconColor;
  _CirillaRadioIconCheck({
    Key? key,
    bool? isSelect,
    ValueChanged<bool>? onChange,
    Color? selectColor,
    Color? color,
    this.iconColor,
  }) : super(
          key: key,
          isSelect: isSelect,
          onChange: onChange,
          selectColor: selectColor,
          color: color,
        );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color colorItem = color ?? theme.dividerColor;
    Color colorActiveItem = selectColor ?? Color(0xFF21BA45);
    Color? background = isSelect! ? colorActiveItem : null;

    Widget radio = Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: background,
        border: Border.all(width: 2, color: isSelect! ? colorActiveItem : colorItem),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: isSelect!
          ? Icon(
              FeatherIcons.check,
              size: 16,
              color: iconColor ?? Colors.white,
            )
          : null,
    );
    return onChange != null
        ? GestureDetector(
            onTap: () => onChange!(!isSelect!),
            child: radio,
          )
        : radio;
  }
}
