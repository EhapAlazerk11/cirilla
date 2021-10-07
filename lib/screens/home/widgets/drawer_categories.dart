import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/models/product_category/product_category.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/screens/product_list/product_list.dart';
import 'package:cirilla/store/store.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

class Categories extends StatefulWidget {
  final List<ProductCategory?>? categories;
  final Data? data;

  const Categories({Key? key, this.categories, this.data}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> with Utility {
  @override
  Widget build(BuildContext context) {
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String? languageKey = settingStore.languageKey;

    final sidebarData = widget.data!.widgets!['sidebar']!;

    String titleCategory = get(sidebarData.fields, ['titleCategory', languageKey], '');

    String? alignCategory = get(sidebarData.fields, ['alignCategory'], 'left');
    return Padding(
      padding: EdgeInsets.only(bottom: itemPadding * 4),
      child: Column(
        crossAxisAlignment: alignCategory == 'center'
            ? CrossAxisAlignment.center
            : alignCategory == 'left'
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: itemPadding),
            child: Text(titleCategory, style: Theme.of(context).textTheme.headline6),
          ),
          ...List.generate(
            widget.categories!.length,
            (i) => SubCategories(
              productCategory: widget.categories![i],
              data: widget.data,
            ),
          )
        ],
      ),
    );
  }
}

class SubCategories extends StatefulWidget {
  final ProductCategory? productCategory;
  final Data? data;

  const SubCategories({Key? key, this.productCategory, this.data}) : super(key: key);

  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> with Utility {
  navigate(BuildContext context, {ProductCategory? category}) {
    if (category != null) {
      Navigator.of(context).pushNamed(ProductListScreen.routeName, arguments: {'category': category});
    }
  }

  bool _expand = false;

  @override
  Widget build(BuildContext context) {
    List<ProductCategory?>? categories = widget.productCategory!.categories;

    WidgetConfig sidebarData = widget.data!.widgets!['sidebar']!;

    bool? enableImageCategory = get(sidebarData.fields, ['enableImageCategory'], true);

    bool? enableCount = get(sidebarData.fields, ['enableCount'], true);

    String? alignCategory = get(sidebarData.fields, ['alignCategory'], 'left');

    String? name = get(widget.productCategory!.name, [], '');

    int? count = get(widget.productCategory!.count, [], 0);

    bool? hierarchy = get(sidebarData.fields, ['showHierarchy'], true);

    String? categoryImg = get(widget.productCategory?.image, ['woocommerce_gallery_thumbnail'], Assets.noImageUrl);

    return buildItem(
      categories,
      alignCategory: alignCategory,
      name: name,
      hierarchy: hierarchy,
      enableCount: enableCount,
      count: count,
      enableImageCategory: enableImageCategory,
      categoryImg: categoryImg,
    );
  }

  Widget buildItem(List<ProductCategory?>? categories,
      {String? alignCategory,
      String? name,
      bool? hierarchy,
      bool? enableCount,
      int? count,
      bool? enableImageCategory,
      String? categoryImg}) {
    switch (alignCategory) {
      case 'right':
        return ProductCategoryTextRightItem(
          onTap: () => navigate(context, category: widget.productCategory),
          name: buildName(name: name!),
          count: buildCount(count: count, enableCount: enableCount),
          iconRight: buildIconRight(categories!),
          image: buildImgItem(img: categoryImg, enableImageCategory: enableImageCategory),
          child: _expand ? buildChildItem(categories) : SizedBox(),
        );
      case 'center':
        return ProductCategoryTextCenterItem(
          onTap: () => navigate(context, category: widget.productCategory),
          name: buildName(name: name!),
          count: buildCount(count: count, enableCount: enableCount),
          iconRight: buildIconRight(categories!),
          image: buildImgItem(img: categoryImg, enableImageCategory: enableImageCategory),
          child: _expand ? buildChildItem(categories, alignCategory: alignCategory) : null,
        );
      default:
        return ProductCategoryTextLeftItem(
          onTap: () => navigate(context, category: widget.productCategory),
          name: buildName(name: name!),
          count: buildCount(count: count, enableCount: enableCount),
          iconRight: buildIconRight(categories!),
          image: buildImgItem(img: categoryImg, enableImageCategory: enableImageCategory),
          child: _expand ? buildChildItem(categories) : SizedBox(),
        );
    }
  }

  Widget? buildIconRight(List<ProductCategory?> categories) {
    if (categories.length == 0) {
      return null;
    }
    return _IconButton(
      active: _expand,
      onPressed: () {
        setState(() {
          _expand = !_expand;
        });
      },
    );
  }

  Widget? buildChildItem(List<ProductCategory?>? categories, {String? alignCategory}) {
    if (categories == null || categories.length == 0) return null;

    return Container(
      padding: alignCategory == 'center' ? EdgeInsets.zero : EdgeInsetsDirectional.only(start: itemPadding * 2),
      child: Column(
        children: List.generate(
          categories.length,
          (i) => SubCategories(
            productCategory: categories[i],
            data: widget.data,
          ),
        ),
      ),
    );
  }

  Widget? buildImgItem({String? img, bool? enableImageCategory}) {
    if (enableImageCategory == false) {
      return null;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular((24) / 2),
      child: ImageLoading(
        img!,
        height: itemPadding * 3,
        width: itemPadding * 3,
        fit: BoxFit.cover,
        color: Theme.of(context).dividerColor,
      ),
    );
  }

  Widget buildName({required String name}) {
    return Text(
      name,
      style: Theme.of(context).textTheme.subtitle2,
    );
  }

  Widget? buildCount({int? count, bool? enableCount}) {
    if (enableCount == false) {
      return null;
    }
    return Text(
      '$count',
      style: Theme.of(context).textTheme.caption,
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
    return InkResponse(
      onTap: onPressed as void Function()?,
      radius: 29,
      child: Icon(
        active ? FeatherIcons.chevronDown : FeatherIcons.chevronRight,
        color: active ? activeColor : color,
        size: itemPadding * 2,
      ),
    );
  }
}
