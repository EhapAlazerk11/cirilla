import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

const List listSortBy = [
  {'key': 'title'},
  {
    'key': 'product_list_default',
    'translate_name': 'product_list_default',
    'query': {
      'orderby': 'menu_order',
      'order': 'asc',
    }
  },
  {
    'key': 'product_list_popular',
    'translate_name': 'product_list_popular',
    'query': {
      'orderby': 'popularity',
      'order': 'desc',
    },
  },
  {
    'key': 'product_list_rating',
    'translate_name': 'product_list_rating',
    'query': {
      'orderby': 'rating',
      'order': 'desc',
    }
  },
  {
    'key': 'product_list_latest',
    'translate_name': 'product_list_latest',
    'query': {
      'orderby': 'date',
      'order': 'desc',
    }
  },
  {
    'key': 'product_list_low_to_high',
    'translate_name': 'product_list_low_to_high',
    'query': {
      'orderby': 'price',
      'order': 'asc',
    }
  },
  {
    'key': 'product_list_high_to_low',
    'translate_name': 'product_list_high_to_low',
    'query': {
      'orderby': 'price',
      'order': 'desc',
    }
  },
];

class Sort extends StatelessWidget {
  final Map<String, dynamic>? value;

  const Sort({Key? key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
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
            Color? textColor = item['key'] == value!['key'] ? theme.textTheme.subtitle1!.color : null;
            return CirillaTile(
              leading: CirillaRadio(isSelect: item['key'] == value!['key']),
              title: Text(translate(item['translate_name'])!,
                  style: theme.textTheme.bodyText2!.copyWith(color: textColor)),
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
