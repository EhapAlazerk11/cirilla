import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_animation_indicator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';

import 'rehub_conspros.dart';

class RehubReviewbox extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const RehubReviewbox({Key? key, this.block}) : super(key: key);

  Widget buildCriterias(BuildContext context, {required List data, Color? selectColor}) {
    ThemeData theme = Theme.of(context);

    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
      children: List.generate(data.length, (index) {
        dynamic item = data.elementAt(index);
        if (item is Map) {
          String title = get(item, ['title'], '');
          double value = ConvertData.stringToDouble(get(item, ['value'], 0), 0);
          double padItem = index < data.length - 1 ? 4 : 0;
          return TableRow(
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: buildItemBottom(
                  pad: padItem,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 60),
                    margin: EdgeInsetsDirectional.only(end: 12),
                    child:
                        Text(title, style: theme.textTheme.caption!.copyWith(color: theme.textTheme.subtitle1!.color)),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: buildItemBottom(
                  pad: padItem,
                  child: CirillaAnimationIndicator(
                    value: value / 10,
                    indicatorColor: selectColor,
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: buildItemBottom(
                  pad: padItem,
                  child: Container(
                    margin: EdgeInsetsDirectional.only(start: 22),
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(value.toString(),
                        style: theme.textTheme.caption!.copyWith(color: theme.textTheme.subtitle1!.color)),
                  ),
                ),
              ),
            ],
          );
        }
        return TableRow(
          children: [Container(), Container(), Container()],
        );
      }),
    );
  }

  Widget buildItemBottom({Widget? child, double? pad}) {
    return Container(
      padding: EdgeInsets.only(bottom: pad ?? 0),
      child: child,
    );
  }

  Widget buildScore(
      {required ThemeData theme,
      required TranslateType translate,
      required double scoreManual,
      double? score,
      Color? color}) {
    double value = scoreManual > 0 ? scoreManual : score!;
    return Column(
      children: [
        Stack(
          children: [
            CirillaAnimationIndicator(
              value: value / 10,
              indicatorColor: color,
              size: 72,
              type: CirillaAnimationIndicatorType.circle,
            ),
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              child: Text(
                value.toString(),
                style: theme.textTheme.headline5!.copyWith(color: color),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(translate('post_detail_expert_score')!,
            style: theme.textTheme.caption!.copyWith(color: theme.textTheme.subtitle1!.color)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    Map? attrs = get(block, ['attrs'], {});

    Color? mainColor = ConvertData.fromHex(get(attrs, ['mainColor'], ''), Color(0xFFE43917));
    String title = get(attrs, ['title'], translate('post_detail_reviewbox_title'));
    String description = get(attrs, ['description'], translate('post_detail_reviewbox_description'));
    double scoreManual = ConvertData.stringToDouble(get(attrs, ['scoreManual'], 0), 0);
    double? score = ConvertData.stringToDouble(get(attrs, ['score'], 0), 0);
    List criterias = get(attrs, ['criterias'], []);
    List? positives = get(attrs, ['positives'], []);
    List? negatives = get(attrs, ['negatives'], []);
    String? prosTitle = get(attrs, ['prosTitle'], translate('post_detail_positive'));
    String? consTitle = get(attrs, ['consTitle'], translate('post_detail_negatives'));

    List<String> dataPositives = convertList(positives);
    List<String> dataNegatives = convertList(negatives);

    return ReviewBox(
      score: buildScore(
        score: score,
        scoreManual: scoreManual,
        theme: theme,
        translate: translate,
        color: mainColor,
      ),
      title: title.isNotEmpty ? Text(title, style: theme.textTheme.headline6) : null,
      description: description.isNotEmpty ? Text(description, style: theme.textTheme.bodyText2) : null,
      criteria: criterias.length > 0 ? buildCriterias(context, data: criterias, selectColor: mainColor) : null,
      consPros: dataPositives.isNotEmpty || dataNegatives.isNotEmpty
          ? ConsprosList(
              positives: dataPositives,
              negatives: dataNegatives,
              prosTitle: prosTitle,
              negaTitle: consTitle,
            )
          : null,
      separator: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          Path customPathDashed = Path()
            ..moveTo(0, 0)
            ..lineTo(width, 0);
          return DottedBorder(
            customPath: (size) => customPathDashed,
            color: theme.dividerColor,
            dashPattern: [5, 3],
            strokeWidth: 1,
            child: Container(),
            padding: EdgeInsets.zero,
          );
        },
      ),
    );
  }
}
