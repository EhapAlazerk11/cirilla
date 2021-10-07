import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/models/post/post_category.dart';
import 'package:cirilla/store/post/post_store.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class Refine extends StatefulWidget {
  final PostStore? store;

  const Refine({Key? key, this.store}) : super(key: key);

  @override
  _RefineState createState() => _RefineState();
}

class _RefineState extends State<Refine> {
  List<PostCategory?> _categorySelected = [];
  List<PostTag?> _tagSelected = [];

  @override
  void didChangeDependencies() {
    setState(() {
      _categorySelected = widget.store!.categorySelected;
      _tagSelected = widget.store!.tagSelected;
    });

    super.didChangeDependencies();
  }

  void onChangeCategory({PostCategory? postCategory, selected = false}) {
    List<PostCategory?> categorySelected = List<PostCategory?>.of(_categorySelected);

    if (selected) {
      categorySelected.add(postCategory);
    } else {
      categorySelected.removeWhere((e) => e!.id == postCategory!.id);
    }

    setState(() {
      _categorySelected = categorySelected;
    });
  }

  void onChangeTag({PostTag? postTag, selected = false}) {
    List<PostTag?> tagSelected = List<PostTag?>.of(_tagSelected);

    if (selected) {
      tagSelected.add(postTag);
    } else {
      tagSelected.removeWhere((e) => e!.id == postTag!.id);
    }

    setState(() {
      _tagSelected = tagSelected;
    });
  }

  void clearAll() {
    setState(() {
      _tagSelected = List<PostTag>.of([]);
      _categorySelected = List<PostCategory>.of([]);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 24, bottom: 16),
              child: Stack(
                children: [
                  Center(child: Text(translate('refine')!, style: theme.textTheme.subtitle1)),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: SizedBox(
                      height: double.infinity,
                      child: TextButton(
                        onPressed: clearAll,
                        child: Text(translate('clear_all')!),
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
            ),
            Expanded(
              child: ListView(
                children: [
                  _Categories(
                    categories: widget.store!.postCategoryStore!.postCategories,
                    categorySelected: _categorySelected,
                    onChange: onChangeCategory,
                  ),
                  _Tags(
                    tags: widget.store!.postTagStore!.postTags,
                    tagSelected: _tagSelected,
                    onChange: onChangeTag,
                  ),
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
                  onPressed: () => Navigator.pop(context, {'categories': _categorySelected, 'tags': _tagSelected}),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Categories extends StatefulWidget {
  final List<PostCategory>? categories;
  final List<PostCategory?>? categorySelected;
  final Function? onChange;

  const _Categories({
    Key? key,
    this.categories,
    this.categorySelected,
    this.onChange,
  }) : super(key: key);

  @override
  __CategoriesState createState() => __CategoriesState();
}

class __CategoriesState extends State<_Categories> {
  bool _expand = true;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Column(
      children: [
        CirillaTile(
          title: CirillaText(translate('categories')),
          trailing: _IconButton(active: _expand),
          isChevron: false,
          onTap: () => setState(() {
            _expand = !_expand;
          }),
        ),
        if (_expand)
          Padding(
            padding: EdgeInsetsDirectional.only(start: 36),
            child: Column(
              children: List.generate(widget.categories!.length, (index) {
                PostCategory category = widget.categories!.elementAt(index);
                bool checkSelect = widget.categorySelected!.indexWhere((e) => e!.id == category.id) >= 0;
                Color? textColor = checkSelect ? theme.textTheme.subtitle1!.color : null;
                return CirillaTile(
                  leading: CirillaRadio.iconCheck(isSelect: checkSelect),
                  title: RichText(
                    text: TextSpan(
                      text: category.name,
                      children: [
                        TextSpan(text: ' (${category.count ?? '0'})', style: theme.textTheme.overline),
                      ],
                      style: theme.textTheme.bodyText2!.copyWith(color: textColor),
                    ),
                  ),
                  isChevron: false,
                  onTap: () => widget.onChange!(postCategory: category, selected: !checkSelect),
                );
              }),
            ),
          )
      ],
    );
  }
}

class _Tags extends StatefulWidget {
  final List<PostTag>? tags;
  final List<PostTag?>? tagSelected;
  final Function? onChange;

  const _Tags({
    Key? key,
    this.tags,
    this.tagSelected,
    this.onChange,
  }) : super(key: key);

  @override
  __TagsState createState() => __TagsState();
}

class __TagsState extends State<_Tags> {
  bool _expand = true;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Column(
      children: [
        CirillaTile(
          title: CirillaText(translate('post_list_tags')),
          trailing: _IconButton(active: _expand),
          isChevron: false,
          onTap: () => setState(() {
            _expand = !_expand;
          }),
        ),
        if (_expand)
          Padding(
            padding: EdgeInsetsDirectional.only(start: 36),
            child: Column(
              children: List.generate(widget.tags!.length, (index) {
                PostTag tag = widget.tags!.elementAt(index);
                bool isSelect = widget.tagSelected!.indexWhere((e) => e!.id == tag.id) >= 0;
                Color? textColor = isSelect ? theme.textTheme.subtitle1!.color : null;
                return CirillaTile(
                  leading: CirillaRadio.iconCheck(isSelect: isSelect),
                  title: RichText(
                    text: TextSpan(
                      text: tag.name,
                      children: [
                        TextSpan(text: ' (${tag.count ?? '0'})', style: theme.textTheme.overline),
                      ],
                      style: theme.textTheme.bodyText2!.copyWith(color: textColor),
                    ),
                  ),
                  isChevron: false,
                  onTap: () => widget.onChange!(postTag: tag, selected: !isSelect),
                );
              }),
            ),
          ),
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
