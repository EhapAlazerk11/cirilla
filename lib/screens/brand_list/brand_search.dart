import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'widgets/item_brand.dart';

class BrandSearch extends StatefulWidget {
  final List<Brand> brands;
  final bool enableImage;
  final bool enableNumber;

  BrandSearch({
    Key? key,
    required this.brands,
    this.enableImage = true,
    this.enableNumber = true,
  }) : super(key: key);

  @override
  _BrandSearchState createState() => _BrandSearchState();
}

class _BrandSearchState extends State<BrandSearch> {
  TextEditingController _controller = new TextEditingController();
  bool enableClear = false;
  List<Brand> dataSearch = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Brand> searchBrand(String value) {
    if (value.isNotEmpty) {
      return widget.brands.where((element) => element.name!.toLowerCase().contains(value.toLowerCase())).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    InputBorder border = OutlineInputBorder(
      borderSide: BorderSide(color: theme.dividerColor),
      borderRadius: BorderRadius.circular(8),
    );
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  onChanged: (String value) {
                    setState(() {
                      enableClear = value.isNotEmpty;
                      dataSearch = searchBrand(value);
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    hintText: translate('brand_search'),
                    prefixIcon: Icon(FeatherIcons.search, size: 16, color: theme.textTheme.subtitle1?.color),
                    suffixIcon: _controller.text.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              _controller.clear();
                              setState(() {
                                enableClear = false;
                                dataSearch = searchBrand('');
                              });
                            },
                            child: Icon(
                              FeatherIcons.xCircle,
                              size: 16,
                              color: theme.textTheme.subtitle1?.color,
                            ))
                        : null,
                    border: border,
                    focusedBorder: border,
                    enabledBorder: border,
                    errorBorder: border,
                    disabledBorder: border,
                  ),
                ),
              ),
              SizedBox(width: 7),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(translate('brand_cancel')!),
                style: TextButton.styleFrom(
                  primary: theme.textTheme.subtitle1?.color,
                  textStyle: theme.textTheme.caption,
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
        toolbarHeight: 90,
      ),
      body: _controller.text.isNotEmpty
          ? dataSearch.isEmpty
              ? Center(
                  child: Text('Empty data'),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: List.generate(
                      dataSearch.length,
                      (index) => ItemBrand(
                        brand: dataSearch[index],
                        enableImage: widget.enableImage,
                        enableNumber: widget.enableNumber,
                      ),
                    ),
                  ),
                )
          : null,
    );
  }
}
