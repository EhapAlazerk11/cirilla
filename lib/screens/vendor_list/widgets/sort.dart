import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_tile.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Sort extends StatelessWidget {
  final Map? sort;

  Sort({
    Key? key,
    this.sort,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    /// List sort data
    List listSortBy = [
      {'key': 'title'},
      {
        'key': 'vendor_list_date_asc',
        'name': translate('vendor_sort_date_asc'),
        'query': {
          'orderby': 'date',
          'order': 'asc',
        }
      },
      {
        'key': 'vendor_list_date_desc',
        'name': translate('vendor_sort_date_desc'),
        'query': {
          'orderby': 'date',
          'order': 'desc',
        }
      },
      {
        'key': 'vendor_list_rating_asc',
        'name': translate('vendor_sort_rating_asc'),
        'query': {
          'orderby': 'rating',
          'order': 'asc',
        }
      },
      {
        'key': 'vendor_list_rating_desc',
        'name': translate('vendor_sort_rating_desc'),
        'query': {
          'orderby': 'rating',
          'order': 'desc',
        }
      },
      {
        'key': 'vendor_list_title_asc',
        'name': translate('vendor_sort_title_asc'),
        'query': {
          'orderby': 'title',
          'order': 'asc',
        }
      },
      {
        'key': 'vendor_list_title_desc',
        'name': translate('vendor_sort_title_desc'),
        'query': {
          'orderby': 'title',
          'order': 'desc',
        }
      },
    ];
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20),
          controller: controller,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> item = listSortBy[index];

            if (item['key'] == 'title') {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    translate('sort_by')!,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              );
            }
            Color? textColor = item['key'] == sort!['key'] ? theme.textTheme.subtitle1!.color : null;
            return CirillaTile(
              leading: CirillaRadio(isSelect: item['key'] == sort!['key']),
              title: Text(item['name'], style: theme.textTheme.bodyText2!.copyWith(color: textColor)),
              isChevron: false,
              onTap: () => Navigator.pop(context, item),
            );
          },
          separatorBuilder: (BuildContext context, int index) => SizedBox(),
          itemCount: listSortBy.length,
        );
      },
    );
  }
}
