import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/country.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/widgets/cirilla_tile.dart';

class ModalCountries extends StatefulWidget with Utility {
  final String? countryId;
  final List<CountryData>? countries;
  final Function(String? countryId, String? stateId)? onChange;

  ModalCountries({
    Key? key,
    this.countryId,
    this.countries,
    this.onChange,
  }) : super(key: key);
  _ModalCountriesState createState() => _ModalCountriesState();
}

class _ModalCountriesState extends State<ModalCountries> {
  final _txtSearch = TextEditingController();
  String search = '';

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Column(
      children: [
        Text(translate('address_select_country')!, style: Theme.of(context).textTheme.subtitle1),
        SizedBox(height: 16),
        TextFormField(
          controller: _txtSearch,
          onChanged: (value) {
            setState(() {
              search = value;
            });
          },
          decoration: InputDecoration(hintText: translate('address_search')),
        ),
        Expanded(
            child: ListView(
          children: widget.countries!
              .where((element) => element.name!.toLowerCase().contains(search.toLowerCase()))
              .toList()
              .map((item) {
            TextStyle titleStyle = theme.textTheme.subtitle2!;
            TextStyle activeTitleStyle = titleStyle.copyWith(color: theme.primaryColor);
            return CirillaTile(
              title: Text(item.name!, style: item.code == widget.countryId ? activeTitleStyle : titleStyle),
              trailing:
                  item.code == widget.countryId ? Icon(FeatherIcons.check, size: 20, color: theme.primaryColor) : null,
              isChevron: false,
              onTap: () {
                if (item.code != widget.countryId) {
                  List<Map<String, dynamic>> states = item.states ?? [];
                  String? stateId = '';
                  if (states.isNotEmpty) {
                    stateId = get(states[0], ['code'], '');
                  }
                  widget.onChange!(item.code, stateId);
                }
              },
            );
          }).toList(),
        ))
      ],
    );
  }
}
