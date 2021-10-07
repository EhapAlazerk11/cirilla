import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/post_author/post_author.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

List<BoxShadow> defaultShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.08),
    offset: Offset(0, 4),
    blurRadius: 24,
    spreadRadius: 0,
  ),
];

class CirillaPostAuthorItem extends StatelessWidget with PostAuthorMixin, Utility {
  final PostAuthor? postAuthor;
  final String? type;
  final double? width;
  final bool? enableAvatar;
  final bool? enableCount;
  final Color? background;
  final Color? textColor;
  final Color? subTextColor;
  final double? radius;
  final List<BoxShadow>? shadow;

  CirillaPostAuthorItem({
    Key? key,
    this.postAuthor,
    this.type = Strings.postAuthorItemVertical,
    this.width,
    this.enableAvatar = true,
    this.enableCount = true,
    this.background,
    this.textColor,
    this.subTextColor,
    this.radius = 8,
    this.shadow,
  }) : super(key: key);

  void navigate(BuildContext context) {
    if (postAuthor!.id == null) {
      return;
    }

    Navigator.of(context).pushNamed(PostAuthorScreen.routeName, arguments: {'author': postAuthor});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    switch (type) {
      case Strings.postAuthorItemContained:
        return LayoutBuilder(
          builder: (_, BoxConstraints constraints) {
            double defaultWidthItem =
                constraints.maxWidth is double && constraints.maxWidth != double.infinity ? constraints.maxWidth : 220;
            return UserContainedItem(
              image: buildImage(author: postAuthor!, width: 70, height: 70),
              title: buildName(theme, author: postAuthor!, color: textColor),
              trailing: buildCount(
                context,
                theme: theme,
                author: postAuthor!,
                color: subTextColor,
              ),
              width: width ?? defaultWidthItem,
              color: background,
              borderRadius: BorderRadius.circular(radius!),
              shadow: shadow ?? defaultShadow,
              onClick: () => navigate(context),
            );
          },
        );
      default:
        return UserVerticalItem(
          image: buildImage(author: postAuthor!, width: 70, height: 70),
          title: buildName(theme, author: postAuthor!, color: textColor, textAlign: TextAlign.center),
          trailing: buildCount(
            context,
            theme: theme,
            author: postAuthor!,
            color: subTextColor,
            textAlign: TextAlign.center,
          ),
          width: width ?? 159,
          color: background,
          borderRadius: BorderRadius.circular(radius!),
          shadow: shadow ?? defaultShadow,
          onClick: () => navigate(context),
        );
    }
  }
}
