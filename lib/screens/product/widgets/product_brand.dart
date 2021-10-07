import 'package:cirilla/models/brand/brand.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/models/product/product_brand.dart';
import 'package:cirilla/screens/product_list/product_list.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/brand/brand_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:cirilla/widgets/cirilla_tile.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductBrandWidget extends StatelessWidget {
  final Product? product;
  final String? layoutBlock;

  ProductBrandWidget({Key? key, this.product, this.layoutBlock = 'horizontal'}) : super(key: key);

  void goBrand(BuildContext context, ProductBrand? brand) {
    if (brand?.id != null) {
      Brand data = new Brand(id: brand?.id, name: brand?.name);
      Navigator.of(context).pushNamed(ProductListScreen.routeName, arguments: {
        'brand': data,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ProductBrand?> brands = product?.brands ?? [];
    if (brands.isEmpty) {
      return Container();
    }
    switch (layoutBlock) {
      case 'vertical':
        return ListVertical(
          brands: brands,
        );
      default:
        return ListHorizontal(
          brands: brands,
        );
    }
  }
}

class ListHorizontal extends StatelessWidget {
  final List<ProductBrand?> brands;

  ListHorizontal({
    Key? key,
    required this.brands,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Row(
      children: [
        Text(
          translate('product_brand') ?? 'Brand:',
          style: theme.textTheme.subtitle2,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Wrap(
            spacing: 12,
            children: List.generate(brands.length, (index) {
              ProductBrand? brand = brands[index];
              return ItemBrand(brand: brand, type: 'horizontal');
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ListVertical extends StatelessWidget {
  final List<ProductBrand?> brands;

  ListVertical({
    Key? key,
    required this.brands,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        children: [
          for (int i = 0; i < brands.length; i++) ...[
            ItemBrand(
              brand: brands[i],
              type: 'vertical',
            ),
            if (i < brands.length - 1) Divider(height: 1, thickness: 1, color: theme.dividerColor),
          ]
        ],
      ),
    );
  }
}

class ItemBrand extends StatelessWidget {
  final ProductBrand? brand;
  final String type;

  ItemBrand({
    Key? key,
    this.brand,
    this.type = 'horizontal',
  }) : super(key: key);

  void goBrand(BuildContext context, Brand brand) {
    if (brand.id != null) {
      Navigator.of(context).pushNamed(ProductListScreen.routeName, arguments: {
        'brand': brand,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (brand == null) {
      return Container();
    }
    ThemeData theme = Theme.of(context);
    BrandStore brandStore = BrandStore(Provider.of<RequestHelper>(context));
    return FutureBuilder<Brand>(
      future: brandStore.getBrand(id: brand?.id ?? 0),
      builder: (context, snapshot) {
        Brand data = snapshot.hasData && snapshot.data is Brand
            ? snapshot.data!
            : snapshot.hasError
                ? Brand(
                    id: brand?.id ?? 0,
                    name: brand?.name ?? '',
                  )
                : Brand(
                    name: brand?.name ?? '',
                  );
        switch (type) {
          case 'vertical':
            return buildVerticalItem(context, theme, data);
          default:
            return buildHorizontalItem(context, theme, data);
        }
      },
    );
  }

  Widget buildHorizontalItem(BuildContext context, ThemeData theme, Brand brand) {
    Widget child = brand.id == null
        ? CirillaShimmer(
            child: Container(
              height: 37,
              width: 57,
              color: Colors.white,
            ),
          )
        : brand.image is String && brand.image!.isNotEmpty
            ? CirillaCacheImage(
                brand.image,
                width: 57,
                height: 37,
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(brand.name ?? ''),
              );
    return SizedBox(
      height: 37,
      child: TextButton(
        onPressed: () => goBrand(context, brand),
        child: child,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          primary: theme.textTheme.subtitle2?.color,
          backgroundColor: theme.colorScheme.surface,
          textStyle: theme.textTheme.subtitle2,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget buildVerticalItem(BuildContext context, ThemeData theme, Brand brand) {
    Widget trailing = brand.id == null
        ? CirillaShimmer(
            child: Container(
              height: 34,
              width: 60,
              color: Colors.white,
            ),
          )
        : brand.image is String && brand.image!.isNotEmpty
            ? CirillaCacheImage(
                brand.image,
                width: 60,
                height: 34,
              )
            : Icon(
                FeatherIcons.chevronRight,
                size: 16,
              );
    return CirillaTile(
      onTap: () => goBrand(context, brand),
      title: Text(
        brand.name ?? '',
        style: theme.textTheme.subtitle2,
      ),
      height: 66,
      trailing: trailing,
      padding: EdgeInsets.symmetric(horizontal: 16),
      isChevron: false,
      isDivider: false,
    );
  }
}
