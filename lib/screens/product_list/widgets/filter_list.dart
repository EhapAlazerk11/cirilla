import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/product/filter_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ui/tab/sticky_tab_bar_delegate.dart';

class FilterList extends StatelessWidget {
  final FilterStore? filter;
  final ProductsStore? productsStore;
  final ProductCategory? category;

  const FilterList({
    Key? key,
    required this.productsStore,
    required this.filter,
    this.category,
  }) : super(key: key);

  List<Map<String, dynamic>> getFilter(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    FilterStore filterStore = productsStore!.filter!;

    List<Map<String, dynamic>> filters = [
      {
        'text': translate('product_list_clear_all'),
        'onDeleted': () {
          filterStore.clearAll(category: category);
          filter!.clearAll(category: category);
        },
      }
    ];

    if (filterStore.inStock) {
      filters.add({
        'text': translate('product_list_in_stock'),
        'onDeleted': () {
          filterStore.onChange(inStock: false);
          filter!.onChange(inStock: false);
        },
      });
    }

    if (filterStore.onSale) {
      filters.add({
        'text': translate('product_list_on_sale'),
        'onDeleted': () {
          filterStore.onChange(onSale: false);
          filter!.onChange(onSale: false);
        },
      });
    }

    if (filterStore.featured) {
      filters.add({
        'text': translate('product_list_featured'),
        'onDeleted': () {
          filterStore.onChange(featured: false);
          filter!.onChange(featured: false);
        },
      });
    }

    if (filterStore.category != null && (category == null || filterStore.category!.id != category!.id)) {
      filters.add({
        'text': filterStore.category!.name,
        'onDeleted': () {
          filterStore.clearCategory(category: category);
          filter!.clearCategory(category: category);
        },
      });
    }

    if (filterStore.attributeSelected.length > 0) {
      for (int i = 0; i < filterStore.attributeSelected.length; i++) {
        filters.add({
          'text': filterStore.attributeSelected[i].title,
          'onDeleted': () {
            filterStore.selectAttribute(filterStore.attributeSelected[i]);
            filterStore.onChange(attributeSelected: filterStore.attributeSelected);
            filter!.selectAttribute(filterStore.attributeSelected[i]);
            filter!.onChange(attributeSelected: filterStore.attributeSelected);
          },
        });
      }
    }
    if (filterStore.rangePrices.start > filter!.productPrices.minPrice!) {
      filters.add({
        'text': translate(
          'product_list_min_price',
          {
            'price': formatCurrency(context, price: '${filterStore.rangePrices.end}'),
          },
        ),
        'onDeleted': () {
          RangeValues rangePrices = new RangeValues(
            filter!.productPrices.minPrice!,
            filterStore.rangePrices.end,
          );
          filterStore.onChange(rangePrices: rangePrices);
          filter!.onChange(rangePrices: rangePrices);
        },
      });
    }

    if (filterStore.rangePrices.end < filter!.productPrices.maxPrice! && filterStore.rangePrices.end > 0) {
      filters.add({
        'text': translate(
          'product_list_max_price',
          {
            'price': formatCurrency(context, price: '${filterStore.rangePrices.end}'),
          },
        ),
        'onDeleted': () {
          RangeValues rangePrices = RangeValues(
            filterStore.rangePrices.start,
            filter!.productPrices.maxPrice!,
          );
          filterStore.onChange(rangePrices: rangePrices);
          filter!.onChange(rangePrices: rangePrices);
        },
      });
    }

    return filters;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Map<String, dynamic>> filters = getFilter(context);
    if (filters.length > 1) {
      return SliverPadding(
        padding: EdgeInsets.only(top: 24),
        sliver: SliverPersistentHeader(
          pinned: false,
          floating: true,
          delegate: StickyTabBarDelegate(
            child: Container(
              alignment: Alignment.center,
              child: Container(
                child: ListView(
                  padding: EdgeInsetsDirectional.only(start: 20, end: 20),
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...List.generate(filters.length, (index) {
                      return Padding(
                        padding: EdgeInsetsDirectional.only(end: index < filters.length - 1 ? 8 : 0),
                        child: SizedBox(
                          height: 34,
                          child: InputChip(
                            label: Row(
                              children: [
                                Text(filters[index]['text']),
                                if (index > 0) ...[
                                  SizedBox(width: 8),
                                  Icon(Icons.clear, size: 14),
                                ]
                              ],
                            ),
                            labelPadding: EdgeInsets.zero,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            backgroundColor: index > 0 ? theme.colorScheme.surface : Colors.transparent,
                            labelStyle: theme.textTheme.caption!
                                .copyWith(fontWeight: FontWeight.w500, color: theme.textTheme.subtitle1!.color),
                            side: BorderSide(width: 2, color: theme.dividerColor),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            onPressed: filters[index]['onDeleted'],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            height: 34,
          ),
        ),
      );
    }
    return SliverPersistentHeader(
      pinned: false,
      floating: true,
      delegate: StickyTabBarDelegate(
        height: 1,
        child: Container(),
      ),
    );
  }
}
