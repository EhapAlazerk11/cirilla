import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';

List<String> convertList(dynamic data) {
  List<String> result = [];
  if (data is List) {
    for (int i = 0; i < data.length; i++) {
      dynamic item = data.elementAt(i);
      if (item is Map && item['title'] is String && item['title'].length > 0) {
        result.add(item['title']);
      }
    }
  }

  return result;
}

class ConsPros extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const ConsPros({Key? key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    List? positives = get(attrs, ['positives'], []);
    List? negatives = get(attrs, ['negatives'], []);
    String? prosTitle = get(attrs, ['prosTitle'], translate('post_detail_positive'));
    String? consTitle = get(attrs, ['consTitle'], translate('post_detail_negatives'));
    List<String> dataPositives = convertList(positives);
    List<String> dataNegatives = convertList(negatives);
    if (dataNegatives.isEmpty && dataPositives.isEmpty) {
      return Container();
    }
    return ConsprosList(
      positives: dataPositives,
      negatives: dataNegatives,
      prosTitle: prosTitle,
      negaTitle: consTitle,
    );
  }
}

class ConsprosList extends StatelessWidget {
  final List<String?> positives;
  final List<String?> negatives;
  final String? prosTitle;
  final String? negaTitle;
  ConsprosList({
    Key? key,
    required this.positives,
    required this.negatives,
    this.prosTitle,
    this.negaTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color colorPositives = Color(0xFF21BA45);
    Color colorNegatives = Color(0xFFF01F0E);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (positives.isNotEmpty)
          ViewIconPros(
            title: prosTitle != null && prosTitle!.isNotEmpty
                ? Text(
                    prosTitle!,
                    style: theme.textTheme.subtitle1!.copyWith(color: colorPositives),
                  )
                : null,
            icon: FeatherIcons.checkCircle,
            colorIcon: colorPositives,
            items: positives as List<String>,
            styleItem: theme.textTheme.bodyText2!.copyWith(color: theme.textTheme.subtitle1!.color),
          ),
        if (negatives.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: negatives.isNotEmpty ? 24 : 0),
            child: ViewIconPros(
              title: prosTitle != null && prosTitle!.isNotEmpty
                  ? Text(
                      negaTitle!,
                      style: theme.textTheme.subtitle1!.copyWith(color: colorNegatives),
                    )
                  : null,
              icon: FeatherIcons.checkCircle,
              colorIcon: colorNegatives,
              items: negatives as List<String>,
              styleItem: theme.textTheme.bodyText2!.copyWith(color: theme.textTheme.subtitle1!.color),
            ),
          ),
      ],
    );
  }
}
