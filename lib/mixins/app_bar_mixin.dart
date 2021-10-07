import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

abstract class AppBarMixin {
  Widget leading({Color? color}) {
    return Builder(
      builder: (BuildContext context) {
        if (Navigator.of(context).canPop()) {
          return IconButton(
            icon: Icon(
              FeatherIcons.chevronLeft,
              size: 22,
              color: color,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        }
        return Container();
      },
    );
  }

  Widget leadingPined() {
    return Builder(
      builder: (BuildContext context) {
        return Ink(
          width: 38.0,
          height: 38.0,
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  Widget leadingButton({IconData? icon, Function? onPress}) {
    return Builder(
      builder: (BuildContext context) {
        return Ink(
          width: 38.0,
          height: 38.0,
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              icon,
              size: 20,
            ),
            onPressed: onPress as void Function()?,
          ),
        );
      },
    );
  }

  AppBar baseStyleAppBar(BuildContext context,
      {required String title, bool automaticallyImplyLeading = true, List<Widget>? actions}) {
    return AppBar(
      shadowColor: Colors.transparent,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      // actionsIconTheme: IconThemeData(size: 22, opacity: 0),
      leading: automaticallyImplyLeading ? leading() : null,
      centerTitle: true,
      title: Text(
        title,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      actions: actions,
    );
  }
}
