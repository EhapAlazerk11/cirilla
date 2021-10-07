import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/mixins/app_bar_mixin.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import 'horizontal.dart';

class WithOutMap extends StatelessWidget with AppBarMixin, Utility {
  /// customize items
  final List items;
  final String? languageKey;
  final bool? enableDirectMap;
  final String? image;

  /// widget FloatingActionButtonLocation
  final Widget? buttonLocation;
  WithOutMap(
      {Key? key,
      required this.items,
      this.languageKey = 'text',
      this.enableDirectMap,
      this.buttonLocation,
      this.image});

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    int count = items.length;
    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate('contact_us')!),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: buttonLocation,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 21),
        child: Column(
          children: [
            ImageLoading(image ?? Assets.noImageUrl, width: double.infinity, height: 197),
            SizedBox(height: 40),
            ...List.generate(
              items.length,
              (index) {
                dynamic item = items.elementAt(index);

                // info
                String heading = get(item, ['data', 'titleHeading', languageKey], '');

                EdgeInsetsDirectional padding = EdgeInsetsDirectional.only(bottom: index < count - 1 ? 24 : 0);

                return Padding(
                  padding: padding,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.08),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ContactContainedItem(
                      headOffice: Text(heading, style: theme.textTheme.headline6),
                      description: Info(
                        item: item,
                        languageKey: languageKey,
                        disableOnClick: true,
                      ),
                      width: width - 40,
                      padding: EdgeInsets.all(24),
                      color: theme.scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
