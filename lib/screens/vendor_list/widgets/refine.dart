import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Refine extends StatefulWidget {
  final String? search;
  final RangeValues? rangeDistance;
  final ProductCategory? category;
  final Function(String search, RangeValues? rangeDistance, ProductCategory? category)? onSubmit;

  Refine({
    Key? key,
    this.search,
    this.rangeDistance,
    this.category,
    this.onSubmit,
  }) : super(key: key);

  @override
  _RefineState createState() => _RefineState();
}

class _RefineState extends State<Refine> {
  TextEditingController? _txtSearch;
  RangeValues? _rangeDistance;
  ProductCategory? _category;
  late ProductCategoryStore _productCategoryStore;
  bool isExpand = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productCategoryStore = Provider.of<ProductCategoryStore>(context);
  }

  @override
  void initState() {
    super.initState();
    _txtSearch = TextEditingController(text: widget.search ?? '');
    _rangeDistance = widget.rangeDistance != null ? widget.rangeDistance : RangeValues(0.0, 50.0);
    _category = widget.category;
  }

  @override
  void dispose() {
    _txtSearch?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        List<ProductCategory> categories = _productCategoryStore.categories;
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Stack(
                    children: [
                      Center(child: Text(translate('refine')!, style: theme.textTheme.subtitle1)),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          child: TextButton(
                            child: Text(translate('clear_all')!),
                            onPressed: () {
                              _txtSearch!.clear();
                              setState(() {
                                _rangeDistance = RangeValues(0.0, 50.0);
                                _category = null;
                              });
                            },
                            style: TextButton.styleFrom(
                              primary: theme.textTheme.caption!.color,
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                              textStyle: theme.textTheme.caption,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _txtSearch,
                        decoration: InputDecoration(
                          labelText: translate('vendor_refine_search'),
                          prefixIcon: Icon(
                            FeatherIcons.search,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(translate('vendor_refine_range')!, style: theme.textTheme.subtitle2),
                      Row(
                        children: [
                          Container(child: Text(translate('vendor_refine_distance', {'distance': '0'})!)),
                          Expanded(
                            child: RangeSlider(
                              values: _rangeDistance!,
                              min: 0,
                              max: 50,
                              divisions: 50,
                              // divisions: (filterStore.productPrices.maxPrice - filterStore.productPrices.minPrice).toInt(),
                              labels: RangeLabels(
                                _rangeDistance!.start.toStringAsFixed(1),
                                _rangeDistance!.end.toStringAsFixed(1),
                              ),
                              onChanged: (RangeValues values) => setState(() {
                                _rangeDistance = values;
                              }),
                            ),
                          ),
                          Container(child: Text(translate('vendor_refine_distance', {'distance': '50'})!)),
                        ],
                      ),
                      CirillaTile(
                        title: Text(translate('categories')!, style: theme.textTheme.subtitle2),
                        trailing: _IconButton(active: isExpand),
                        isChevron: false,
                        onTap: () => setState(() {
                          isExpand = !isExpand;
                        }),
                      ),
                      if (isExpand)
                        ...List.generate(categories.length, (index) {
                          ProductCategory category = categories.elementAt(index);
                          return Padding(
                            padding: EdgeInsetsDirectional.only(start: 32),
                            child: _ItemCategory(
                              category: category,
                              selectCategory: _category,
                              onChange: (ProductCategory value) => setState(() {
                                _category = value;
                              }),
                            ),
                          );
                        })
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      child: Text(translate('apply')!),
                      onPressed: () => widget.onSubmit!(_txtSearch!.text, _rangeDistance, _category),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ItemCategory extends StatefulWidget {
  final ProductCategory? category;
  final ProductCategory? selectCategory;
  final Function(ProductCategory value)? onChange;

  _ItemCategory({
    Key? key,
    this.category,
    this.selectCategory,
    this.onChange,
  }) : super(key: key);

  @override
  _ItemCategoryState createState() => _ItemCategoryState();
}

class _ItemCategoryState extends State<_ItemCategory> {
  bool isExpand = true;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ProductCategory category = widget.category!;
    bool isSelect = widget.selectCategory != null ? widget.selectCategory!.id == category.id : false;
    Color? textColor = isSelect ? theme.textTheme.subtitle1!.color : null;
    return Column(
      children: [
        CirillaTile(
          leading: CirillaRadio(isSelect: isSelect),
          title: Text(category.name!, style: theme.textTheme.bodyText2!.copyWith(color: textColor)),
          trailing: category.categories!.length > 0
              ? _IconButton(
                  active: isExpand,
                  onPressed: () => setState(() {
                    isExpand = !isExpand;
                  }),
                )
              : null,
          isChevron: false,
          onTap: () => widget.onChange!(category),
        ),
        if (isExpand)
          Padding(
            padding: EdgeInsetsDirectional.only(start: 32),
            child: Column(
              children: List.generate(category.categories!.length, (index) {
                ProductCategory? categoryChild = category.categories!.elementAt(index);
                return _ItemCategory(
                  category: categoryChild,
                  selectCategory: widget.selectCategory,
                  onChange: widget.onChange,
                );
              }),
            ),
          )
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final Function? onPressed;
  final bool active;

  const _IconButton({Key? key, this.onPressed, this.active = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).textTheme.headline1!.color;
    Color activeColor = Theme.of(context).primaryColor;
    return IconButton(
      icon: Icon(
        active ? FeatherIcons.chevronDown : FeatherIcons.chevronRight,
        color: active ? activeColor : color,
        size: 16,
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}
