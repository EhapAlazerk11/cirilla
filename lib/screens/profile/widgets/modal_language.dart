import 'package:cirilla/constants/app.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/widgets/cirilla_tile.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ModalLanguage extends StatelessWidget {
  final SettingStore? settingStore;

  ModalLanguage({
    Key? key,
    required this.settingStore,
  }) : super(key: key);

  showAlertDialog(BuildContext context, {String? lang, required Function update}) async {
    String locale = settingStore?.locale ?? defaultLanguage;
    TranslateType translate = AppLocalizations.of(context)!.translate;

    if (locale == lang) {
      Navigator.pop(context);
      return;
    }

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(translate('confirm_clean_cart_cancel')!),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(translate('confirm_clean_cart_ok')!),
      onPressed: () {
        update();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(translate('confirm_clean_cart_heading')!),
      content: Text(translate('confirm_clean_cart_description')!),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ProductCategoryStore productCategoryStore = Provider.of<ProductCategoryStore>(context);
    CartStore cartStore = Provider.of<CartStore>(context);

    String locale = settingStore?.locale ?? defaultLanguage;

    return Observer(
      builder: (_) => Column(
        children: settingStore!.supportedLanguages.map((item) {
          TextStyle titleStyle = theme.textTheme.subtitle2!;
          TextStyle activeTitleStyle = titleStyle.copyWith(color: theme.primaryColor);

          return CirillaTile(
            title: Text(item.language!, style: item.locale == locale ? activeTitleStyle : titleStyle),
            trailing: item.locale == locale ? Icon(FeatherIcons.check, size: 20, color: theme.primaryColor) : null,
            isChevron: false,
            onTap: () {
              if (cartStore.count! > 0) {
                showAlertDialog(context, lang: item.locale, update: () async {
                  await cartStore.cleanCart();
                  settingStore!.changeLanguage(item.locale ?? locale);
                  productCategoryStore.onChanged(language: item.locale);
                });
              } else {
                settingStore!.changeLanguage(item.locale ?? locale);
                productCategoryStore.onChanged(language: item.locale);
                Navigator.pop(context);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
