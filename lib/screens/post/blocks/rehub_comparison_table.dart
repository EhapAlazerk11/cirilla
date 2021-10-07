import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:cirilla/widgets/cirilla_rating.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';

class RehubComparisonTable extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const RehubComparisonTable({Key? key, this.block}) : super(key: key);

  void openUrl(String? url) {
    if (url != null && url.isNotEmpty) {
      launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    List? innerBlocks = get(block, ['innerBlocks'], []);
    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};

    bool? enableBadges = get(attrs, ['enableBadges'], false);
    bool? enableBottom = get(attrs, ['enableBottom'], true);
    bool? enablePros = get(attrs, ['enablePros'], true);
    bool? enableCons = get(attrs, ['enableCons'], true);
    bool? enableSpec = get(attrs, ['enableSpec'], false);
    bool? enableCallout = get(attrs, ['enableCallout'], false);

    String? bottomTitle = get(attrs, ['bottomTitle'], 'Bottom line');
    String? prosTitle = get(attrs, ['prosTitle'], 'Pros');
    String? consTitle = get(attrs, ['consTitle'], 'Cons');
    String? specTitle = get(attrs, ['specTitle'], 'Spec');

    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double widthView = constraints.maxWidth - 100;

        Map<int, TableColumnWidth> columnWidths = {
          0: FixedColumnWidth(100),
        };

        double widthItem = innerBlocks!.length < 2 ? widthView : widthView * 0.8;

        for (int i = 0; i < innerBlocks.length; i++) {
          columnWidths.addAll({i + 1: FixedColumnWidth(widthItem)});
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            border: TableBorder.all(width: 1, color: theme.dividerColor),
            columnWidths: columnWidths,
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              if (enableBadges!) buildBadge(innerBlocks: innerBlocks, theme: theme),
              buildProduct(context, innerBlocks: innerBlocks, theme: theme, attrsBlock: attrs, widthItem: widthItem),
              if (enableBottom!)
                buildInfo(context,
                    innerBlocks: innerBlocks, theme: theme, title: bottomTitle!, nameValue: 'bottomText'),
              if (enablePros!)
                buildInfo(context, innerBlocks: innerBlocks, theme: theme, title: prosTitle!, nameValue: 'prosText'),
              if (enableCons!)
                buildInfo(context, innerBlocks: innerBlocks, theme: theme, title: consTitle!, nameValue: 'consText'),
              if (enableSpec!)
                buildInfo(context, innerBlocks: innerBlocks, theme: theme, title: specTitle!, nameValue: 'specText'),
              if (enableCallout!) buildButtonCallout(context, innerBlocks: innerBlocks, theme: theme),
            ],
          ),
        );
      },
    );
  }

  TableRow buildBadge({required List innerBlocks, ThemeData? theme}) {
    return TableRow(
      children: <Widget>[
        Container(),
        ...List.generate(innerBlocks.length, (index) {
          Map dataBlock = innerBlocks.elementAt(index) is Map ? innerBlocks.elementAt(index) : {};
          Map? attrs = get(dataBlock, ['attrs'], {}) is Map ? get(dataBlock, ['attrs'], {}) : {};

          bool enableBadge = get(attrs, ['enableBadge'], false);

          String? textBadge = get(attrs, ['productBadge'], '');

          Color? colorBadge = ConvertData.fromHex(get(attrs, ['badgeColor'], ''), Colors.transparent);
          if (enableBadge)
            return Container(
              color: colorBadge,
              alignment: Alignment.center,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(textBadge!.toUpperCase(),
                  style: theme!.textTheme.subtitle1!.copyWith(color: Colors.white), textAlign: TextAlign.center),
            );
          return Container();
        })
      ],
    );
  }

  TableRow buildProduct(
    BuildContext context, {
    required List innerBlocks,
    Map? attrsBlock,
    double? widthItem,
    ThemeData? theme,
  }) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    bool? enableNumbers = get(attrsBlock, ['enableNumbers'], false);
    bool? enableImage = get(attrsBlock, ['enableImage'], true);
    bool? enableTitle = get(attrsBlock, ['enableTitle'], true);
    bool? enableSubtitle = get(attrsBlock, ['enableSubtitle'], true);
    bool? enableStars = get(attrsBlock, ['enableStars'], true);
    bool? enableList = get(attrsBlock, ['enableList'], false);
    bool? enableListTitle = get(attrsBlock, ['enableListTitle'], true);
    bool? enableButton = get(attrsBlock, ['enableButton'], true);

    return TableRow(
      children: <Widget>[
        Container(),
        ...List.generate(innerBlocks.length, (index) {
          Map dataBlock = innerBlocks.elementAt(index) is Map ? innerBlocks.elementAt(index) : {};
          Map? attrs = get(dataBlock, ['attrs'], {}) is Map ? get(dataBlock, ['attrs'], {}) : {};

          // number
          int number = ConvertData.stringToInt(get(attrs, ['numberValue'], 1), 1);
          Color? numberColor = ConvertData.fromHex(get(attrs, ['numberColor'], ''), theme!.primaryColor);

          // image
          String? linkImage = get(attrs, ['productImage', 'url'], '');

          // title
          String? productTitle = get(attrs, ['productTitle'], '');

          // subtitle
          String? productSubtitle = get(attrs, ['productSubtitle'], '');

          // rating
          double? starRating = ConvertData.stringToDouble(get(attrs, ['starRating'], 5), 5);

          // list
          String? listTitle = get(attrs, ['listTitle'], translate('post_detail_comparison_list_item'));
          List? listItems = get(attrs, ['listItems'], []);

          // button
          String? buttonText = get(attrs, ['buttonText'], translate('post_detail_comparison_button'));
          Color? buttonColor = ConvertData.fromHex(get(attrs, ['buttonColor'], ''), theme.primaryColor);
          String? buttonUrl = get(attrs, ['buttonUrl'], '');

          double widthImage = widthItem! - 24;
          double heightImage = 160;

          return TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: buildBox(
              child: Stack(
                children: [
                  Column(
                    children: [
                      if (enableImage! && linkImage!.length > 0)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child:
                              CirillaCacheImage(linkImage, width: widthImage, height: heightImage, fit: BoxFit.contain),
                        ),
                      if (enableTitle! && productTitle!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 3),
                          child: Text(productTitle, style: theme.textTheme.subtitle1, textAlign: TextAlign.center),
                        ),
                      if (enableSubtitle! && productSubtitle!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(productSubtitle, style: theme.textTheme.caption, textAlign: TextAlign.center),
                        ),
                      if (enableStars!)
                        Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: CirillaRating(initialValue: starRating),
                        ),
                      if (enableList!)
                        Column(
                          children: [
                            if (enableListTitle!)
                              Text(listTitle!, style: theme.textTheme.bodyText2, textAlign: TextAlign.center),
                            if (listItems!.length > 0) SizedBox(height: 8),
                            ...List.generate(listItems.length, (index) {
                              String nameListItem = listItems.elementAt(index) is Map
                                  ? get(listItems.elementAt(index), ['key'], '')
                                  : listItems.elementAt(index) is String
                                      ? listItems.elementAt(index)
                                      : '';
                              return Text(nameListItem, style: theme.textTheme.bodyText2, textAlign: TextAlign.center);
                            }),
                            if (listItems.length > 0) SizedBox(height: 8),
                          ],
                        ),
                      if (enableButton!)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(buttonText!),
                            onPressed: () => openUrl(buttonUrl),
                            style: ElevatedButton.styleFrom(
                              primary: buttonColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    top: 8,
                    start: 8,
                    child: enableNumbers!
                        ? Badge(
                            text: Text(number.toString(),
                                style: theme.textTheme.subtitle1!.copyWith(color: Colors.white)),
                            size: 30,
                            color: numberColor,
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          );
        })
      ],
    );
  }

  TableRow buildInfo(BuildContext context,
      {required String title, required List innerBlocks, required ThemeData theme, String? nameValue}) {
    return TableRow(
      children: <Widget>[
        TableCell(
          child: buildBox(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.subtitle2,
            ),
          ),
          verticalAlignment: TableCellVerticalAlignment.middle,
        ),
        ...List.generate(innerBlocks.length, (index) {
          Map dataBlock = innerBlocks.elementAt(index) is Map ? innerBlocks.elementAt(index) : {};
          Map? attrs = get(dataBlock, ['attrs'], {}) is Map ? get(dataBlock, ['attrs'], {}) : {};

          String bottomText = get(attrs, [nameValue ?? 'bottomText'], '');
          return buildBox(
            child: Text(bottomText, style: theme.textTheme.bodyText2),
          );
        })
      ],
    );
  }

  TableRow buildButtonCallout(BuildContext context, {required List innerBlocks, ThemeData? theme}) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return TableRow(
      children: <Widget>[
        Container(),
        ...List.generate(innerBlocks.length, (index) {
          Map dataBlock = innerBlocks.elementAt(index) is Map ? innerBlocks.elementAt(index) : {};
          Map? attrs = get(dataBlock, ['attrs'], {}) is Map ? get(dataBlock, ['attrs'], {}) : {};

          String buttonText = get(attrs, ['buttonText'], translate('post_detail_comparison_button'));
          Color? buttonColor = ConvertData.fromHex(get(attrs, ['buttonColor'], ''), theme!.primaryColor);
          String? buttonUrl = get(attrs, ['buttonUrl'], '');

          return TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: buildBox(
              child: ElevatedButton(
                child: Text(buttonText),
                onPressed: () => openUrl(buttonUrl),
                style: ElevatedButton.styleFrom(
                  primary: buttonColor,
                ),
              ),
            ),
          );
        })
      ],
    );
  }

  Widget buildBox({Widget? child, EdgeInsetsGeometry? padding}) {
    return Container(
      padding: padding ?? EdgeInsets.all(12),
      child: child,
    );
  }
}
