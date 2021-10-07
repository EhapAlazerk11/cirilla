import 'package:cirilla/types/actions.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_tile.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Sort extends StatelessWidget {
  final Map value;
  final OnChangedBlogType onChanged;

  const Sort({Key? key, required this.value, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    /// List sort data
    const List listSortBy = [
      {
        'key': 'latest',
        'translate_name': 'post_list_sort_latest',
        'query': {
          'order': 'desc',
          'orderby': 'date',
        }
      },
      {
        'key': 'oldest',
        'translate_name': 'post_list_sort_oldest',
        'query': {
          'order': 'asc',
          'orderby': 'date',
        }
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(translate('sort_by')!, style: theme.textTheme.subtitle1),
          ),
          ...List.generate(
            listSortBy.length,
            (index) {
              Map item = listSortBy[index];
              Color? textColor = item['key'] == value['key'] ? theme.textTheme.subtitle1!.color : null;
              return CirillaTile(
                leading: CirillaRadio(isSelect: item['key'] == value['key']),
                title: Text(translate(item['translate_name'])!,
                    style: theme.textTheme.bodyText2!.copyWith(color: textColor)),
                isChevron: false,
                onTap: () {
                  onChanged(sort: item);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
