import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product/attributes.dart';
import 'package:cirilla/models/product_category/product_category.dart';
import 'package:cirilla/store/product/filter_store.dart';
import 'package:cirilla/store/product_category/product_category_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:ui/ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Refine extends StatefulWidget {
  final ProductCategory? category;

  // Product list store
  final FilterStore? filterStore;

  final Function? clearAll;

  final Function? onSubmit;

  final double min;

  final double max;

  final String? refineItemStyle;
  final String? refinePosition;

  const Refine({
    Key? key,
    this.category,
    this.filterStore,
    this.clearAll,
    this.onSubmit,
    this.min = 0.8,
    this.max = 1,
    this.refineItemStyle,
    this.refinePosition,
  }) : super(key: key);

  @override
  _RefineState createState() => _RefineState();
}

class _RefineState extends State<Refine> with CategoryMixin, LoadingMixin, CategoryMixin {
  List<ProductCategory?> _categories = List<ProductCategory>.of([]);
  bool _categoryExpand = true;

  @override
  void didChangeDependencies() {
    ProductCategoryStore productCategoryStore = Provider.of<ProductCategoryStore>(context);
    setState(() {
      _categories = parent(
        categories: productCategoryStore.categories,
        parentId: widget.category != null ? widget.category!.id : 0,
      );
    });
    // widget.clearAll();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.clearAll!();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: widget.min,
      minChildSize: widget.min,
      maxChildSize: widget.max,
      builder: (_, controller) {
        return Observer(builder: (_) {
          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                controller: controller,
                children: [
                  _buildHeader(),
                  _buildInStock(),
                  _buildOnSale(),
                  _buildFeatured(),
                  if (_categories.length > 0) _buildCategories(),
                  if (widget.filterStore!.attributes.length > 0) _buildAttributes(),
                  if (widget.filterStore!.productPrices.minPrice != widget.filterStore!.productPrices.maxPrice)
                    _buildRangesPrice(),
                  _buildApplyButton(context),
                ],
              ),
              if (widget.filterStore!.loadingAttributes) Center(child: buildLoadingOverlay(context)),
            ],
          );
        });
      },
    );
  }

  Widget _buildHeader() {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    bool isCenter = widget.refinePosition == Strings.refinePositionBottom;
    bool isSafeArea = widget.refinePosition != Strings.refinePositionBottom;

    double paddingTop = isSafeArea ? MediaQuery.of(context).padding.top : 24;

    Widget title = isCenter
        ? Center(
            child: Text(
              translate('product_list_filters')!,
              style: theme.textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          )
        : Text(
            translate('product_list_filters')!,
            style: theme.textTheme.subtitle1,
            textAlign: TextAlign.center,
          );
    return Padding(
      padding: EdgeInsets.only(top: paddingTop > 0 ? paddingTop : 24, bottom: 16),
      child: Stack(
        children: [
          title,
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
              height: double.infinity,
              child: TextButton(
                onPressed: () => widget.clearAll!(),
                child: Text(translate('product_list_clear_all')!),
                style: TextButton.styleFrom(
                  primary: theme.textTheme.caption!.color,
                  textStyle: theme.textTheme.caption,
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInStock() {
    return CirillaTile(
      title: CirillaText(AppLocalizations.of(context)!.translate('product_list_in_stock')),
      trailing: CupertinoSwitch(
        activeColor: Theme.of(context).primaryColor,
        value: widget.filterStore!.inStock,
        onChanged: (value) => widget.filterStore!.onChange(inStock: value),
      ),
      isChevron: false,
    );
  }

  Widget _buildOnSale() {
    return CirillaTile(
      title: CirillaText(AppLocalizations.of(context)!.translate('product_list_on_sale')),
      trailing: CupertinoSwitch(
        activeColor: Theme.of(context).primaryColor,
        value: widget.filterStore!.onSale,
        onChanged: (value) => widget.filterStore!.onChange(onSale: value),
      ),
      isChevron: false,
    );
  }

  Widget _buildFeatured() {
    return CirillaTile(
      title: CirillaText(AppLocalizations.of(context)!.translate('product_list_featured')),
      trailing: CupertinoSwitch(
        activeColor: Theme.of(context).primaryColor,
        value: widget.filterStore!.featured,
        onChanged: (value) => widget.filterStore!.onChange(featured: value),
      ),
      isChevron: false,
    );
  }

  Widget _buildCategories() {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    List<ProductCategory?> data =
        widget.refineItemStyle == Strings.refineItemStyleCard ? flatten(categories: _categories) : _categories;

    return _Tile(
      title: translate('product_list_categories'),
      activeList: _categoryExpand,
      onChangeActiveList: () => setState(() {
        _categoryExpand = !_categoryExpand;
      }),
      count: widget.category != null ? data.length + 1 : data.length,
      buildItem: (index) {
        if (index == data.length) {
          if (widget.category == null) return Container();
          return _Category(
            category: ProductCategory(
              id: widget.category?.id,
              categories: [],
              name: translate('product_list_view_all'),
              count: -1,
            ),
            filterStore: widget.filterStore,
            refineItemStyle: widget.refineItemStyle,
          );
        }
        return _Category(
          category: data[index],
          filterStore: widget.filterStore,
          refineItemStyle: widget.refineItemStyle,
        );
      },
      refineItemStyle: widget.refineItemStyle,
    );
  }

  Widget _buildAttributes() {
    return Observer(
      builder: (_) => Column(
        children: List.generate(
          widget.filterStore!.attributes.length,
          (i) => widget.filterStore!.attributes[i].terms!.options!.length > 0
              ? _Attribute(
                  filterStore: widget.filterStore,
                  attribute: widget.filterStore!.attributes[i],
                  refineItemStyle: widget.refineItemStyle,
                )
              : SizedBox(),
        ),
      ),
    );
  }

  Widget _buildRangesPrice() {
    bool expand = widget.filterStore!.itemExpand['ranges_price'] != null;

    return Column(children: [
      CirillaTile(
        onTap: () => widget.filterStore!.expand('ranges_price'),
        title: CirillaText(AppLocalizations.of(context)!.translate('product_list_ranges_price')),
        trailing: _IconButton(
          active: expand,
          onPressed: () => widget.filterStore!.expand('ranges_price'),
        ),
        isChevron: false,
      ),
      if (expand) _RangePrice(filterStore: widget.filterStore),
    ]);
  }

  Widget _buildApplyButton(BuildContext context) {
    return Container(
      height: 48,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        child: Text(AppLocalizations.of(context)!.translate('product_list_apply')!),
        onPressed: () {
          widget.onSubmit!(widget.filterStore);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String? title;
  final int? count;
  final Widget Function(int index)? buildItem;
  final bool? activeList;
  final Function? onChangeActiveList;
  final String? refineItemStyle;

  _Tile({
    Key? key,
    this.title,
    this.count,
    this.buildItem,
    this.activeList,
    this.onChangeActiveList,
    this.refineItemStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        switch (refineItemStyle) {
          case Strings.refineItemStyleCard:
            double widthItem = (width - 16) / 2;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CirillaText(title),
                      SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: List.generate(
                          count!,
                          (index) => SizedBox(
                            width: widthItem,
                            child: buildItem!(index),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 1),
              ],
            );
          default:
            return Column(
              children: [
                CirillaTile(
                  onTap: onChangeActiveList as void Function()?,
                  title: CirillaText(title),
                  trailing: _IconButton(active: activeList),
                  isChevron: false,
                ),
                if (activeList!) ...List.generate(count!, (index) => buildItem!(index))
              ],
            );
        }
      },
    );
  }
}

class _IconButton extends StatelessWidget {
  final Function? onPressed;
  final bool? active;

  const _IconButton({Key? key, this.onPressed, this.active = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).textTheme.headline1!.color;
    Color activeColor = Theme.of(context).primaryColor;
    return IconButton(
      icon: Icon(
        active! ? FeatherIcons.chevronDown : FeatherIcons.chevronRight,
        color: active! ? activeColor : color,
        size: 16,
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}

class _Attribute extends StatelessWidget {
  final Attribute? attribute;
  final FilterStore? filterStore;
  final String? refineItemStyle;

  const _Attribute({
    Key? key,
    this.attribute,
    this.filterStore,
    this.refineItemStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        List<Option> options = attribute!.terms!.options!;
        return _Tile(
          title: attribute!.name,
          activeList: filterStore!.itemExpand[attribute!.slug] != null,
          onChangeActiveList: () => filterStore!.expand(attribute!.slug),
          count: options.length,
          refineItemStyle: refineItemStyle,
          buildItem: (index) {
            if (refineItemStyle == Strings.refineItemStyleCard) {
              return _buildCard(context, options.elementAt(index));
            }
            return _buildListTitle(context, options.elementAt(index));
          },
        );
      },
    );
  }

  onSelected(Option option) {
    filterStore!.selectAttribute(
      ItemAttributeSelected(
        taxonomy: option.taxonomy,
        field: 'term_id',
        terms: option.termId,
        title: '${attribute!.name}: ${option.name}',
      ),
    );
  }

  Widget _buildCard(BuildContext context, Option option) {
    ThemeData theme = Theme.of(context);
    bool isSelected = filterStore!.attributeSelected
            .indexWhere((ItemAttributeSelected s) => s.taxonomy == option.taxonomy && s.terms == option.termId) >=
        0;

    return ButtonSelect.filter(
      child: Text(
        "${option.name}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.caption!.copyWith(color: theme.textTheme.subtitle1!.color),
      ),
      isSelect: isSelected,
      colorSelect: theme.primaryColor,
      color: theme.colorScheme.surface,
      onTap: () => onSelected(option),
    );
  }

  Widget _buildListTitle(BuildContext context, Option option) {
    ThemeData theme = Theme.of(context);
    Widget trailing = SizedBox();
    bool isSelected = filterStore!.attributeSelected
            .indexWhere((ItemAttributeSelected s) => s.taxonomy == option.taxonomy && s.terms == option.termId) >=
        0;
    Color? textColor = isSelected ? theme.textTheme.subtitle1!.color : null;

    if (attribute!.type == 'color') {
      trailing = Padding(
        padding: EdgeInsetsDirectional.only(end: 12),
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: ConvertData.fromHex(option.value!, Colors.transparent),
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      );
    }

    if (attribute!.type == 'image') {
      trailing = Padding(
        padding: EdgeInsetsDirectional.only(end: 13),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Image.network(
            option.value!,
            width: 22,
            height: 22,
          ),
        ),
      );
    }

    return CirillaTile(
      onTap: () => onSelected(option),
      leading: CirillaRadio.iconCheck(isSelect: isSelected),
      title: Container(
        alignment: AlignmentDirectional.centerStart,
        child: RichText(
          text: TextSpan(
            text: option.name,
            children: [
              TextSpan(text: ' (${option.count.toString()})', style: theme.textTheme.overline),
            ],
            style: theme.textTheme.bodyText2!.copyWith(color: textColor),
          ),
        ),
      ),
      trailing: trailing,
      isChevron: false,
    );
  }
}

class _Category extends StatelessWidget {
  final ProductCategory? category;
  final FilterStore? filterStore;
  final String? refineItemStyle;

  const _Category({
    Key? key,
    this.category,
    this.filterStore,
    this.refineItemStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSub = category!.categories!.length > 0;
    return Observer(builder: (_) {
      String key = "category_${category!.id}";
      bool expand = filterStore!.itemExpand[key] != null;
      return refineItemStyle == Strings.refineItemStyleCard
          ? _buildCard(context, key: key, isSub: isSub, expand: expand)
          : _buildListTitle(context, key: key, isSub: isSub, expand: expand);
    });
  }

  Widget _buildCard(BuildContext context, {bool? isSub, bool? expand, String? key}) {
    ThemeData theme = Theme.of(context);
    bool isActive = filterStore!.category != null && filterStore!.category!.id == category!.id;

    return SizedBox(
      child: ButtonSelect.filter(
        child: Text(
          "${category!.name}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.caption!.copyWith(color: theme.textTheme.subtitle1!.color),
        ),
        isSelect: isActive,
        colorSelect: theme.primaryColor,
        color: theme.colorScheme.surface,
        onTap: () => filterStore!.onChange(category: category),
      ),
      width: double.infinity,
    );
  }

  Widget _buildListTitle(BuildContext context, {bool? isSub, required bool expand, String? key}) {
    ThemeData theme = Theme.of(context);
    Color? textColor = filterStore?.category?.id == category!.id ? theme.textTheme.subtitle1!.color : null;
    return Column(
      children: [
        CirillaTile(
          leading: CirillaRadio(isSelect: filterStore?.category?.id == category!.id),
          title: Container(
            alignment: AlignmentDirectional.centerStart,
            child: RichText(
              text: TextSpan(
                text: category!.name,
                children: [
                  if (category!.count! > -1)
                    TextSpan(text: ' (${category!.count.toString()})', style: theme.textTheme.overline),
                ],
                style: theme.textTheme.bodyText2!.copyWith(color: textColor),
              ),
            ),
          ),
          trailing: category!.categories!.length > 0
              ? _IconButton(
                  active: expand,
                  onPressed: () => filterStore!.expand(key),
                )
              : null,
          onTap: () => filterStore!.onChange(category: category),
          isChevron: false,
        ),
        if (expand && category!.categories!.length > 0)
          Padding(
            padding: EdgeInsetsDirectional.only(start: 36),
            child: Column(
              children: List.generate(
                category!.categories!.length,
                (int index) => _Category(
                  category: category!.categories![index],
                  filterStore: filterStore,
                ),
              ),
            ),
          )
      ],
    );
  }
}

class _RangePrice extends StatelessWidget {
  final FilterStore? filterStore;

  const _RangePrice({Key? key, this.filterStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              child:
                  Center(child: Text(formatCurrency(context, price: filterStore!.productPrices.minPrice.toString()))),
            ),
            Expanded(
              child: RangeSlider(
                values: filterStore!.rangePrices,
                min: filterStore!.productPrices.minPrice!,
                max: filterStore!.productPrices.maxPrice!,
                divisions: (filterStore!.productPrices.maxPrice! - filterStore!.productPrices.minPrice!).toInt(),
                labels: RangeLabels(
                  formatCurrency(context, price: filterStore!.rangePrices.start.round().toString()),
                  formatCurrency(context, price: filterStore!.rangePrices.end.round().toString()),
                ),
                onChanged: (RangeValues values) {
                  filterStore!.setMinMaxPrice(values.start, values.end);
                },
              ),
            ),
            Container(
              // width: 60,
              child:
                  Center(child: Text(formatCurrency(context, price: filterStore!.productPrices.maxPrice.toString()))),
            )
          ],
        ),
      ),
    );
  }
}
