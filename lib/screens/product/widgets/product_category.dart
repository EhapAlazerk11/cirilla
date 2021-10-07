import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/models/product/product_category.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:flutter/material.dart';

class ProductCategoryList extends StatelessWidget {
  final Product? product;
  final String? align;

  const ProductCategoryList({Key? key, this.product, this.align = 'left'}) : super(key: key);

  void goCategory(BuildContext context, ProductCategory? category) {
    if (category == null) {
      return;
    }

    Navigator.pushNamed(context, ProductListScreen.routeName, arguments: {
      'id': category.id,
      'name': category.name,
    });
  }

  @override
  Widget build(BuildContext context) {
    WrapAlignment alignment = align == 'center'
        ? WrapAlignment.center
        : align == 'right'
            ? WrapAlignment.end
            : WrapAlignment.start;
    return _buildCategories(context, product: product!, alignment: alignment);
  }

  Widget _buildCategories(BuildContext context, {required Product product, required WrapAlignment alignment}) {
    ThemeData theme = Theme.of(context);
    List<ProductCategory?> categories = product.categories!;
    return Wrap(
      alignment: alignment,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 2,
      spacing: 6,
      children: [
        for (int i = 0; i < categories.length; i++) ...[
          InkWell(
            onTap: () => goCategory(context, categories.elementAt(i)),
            child: Text(
              categories.elementAt(i)!.name!.toUpperCase(),
              style: theme.textTheme.caption!.copyWith(fontSize: 12, color: Theme.of(context).primaryColor),
            ),
          ),
          if (i < categories.length - 1)
            SizedBox(
              height: 12,
              child: VerticalDivider(
                width: 2,
                thickness: 1,
                color: theme.primaryColor,
              ),
            )
        ]
      ],
    );
  }
}
