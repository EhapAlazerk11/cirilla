import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/post/post.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'post_action.dart';
import 'post_author.dart';
import 'post_category.dart';
import 'post_comment_count.dart';
import 'post_comments.dart';
import 'post_content.dart';
import 'post_date.dart';
import 'post_image.dart';
import 'post_name.dart';
import 'post_tag.dart';

class PostBlock extends StatelessWidget with PostMixin {
  final Post? post;
  final List<dynamic>? rows;
  final Map<String, dynamic>? styles;
  final Color? color;

  PostBlock({Key? key, this.post, this.rows, this.styles, this.color}) : super(key: key);

  List<Widget> buildColumn(List<dynamic>? columns, {required ThemeData theme, required String themeModeKey}) {
    if (columns == null) return [Container()];
    return columns.map((e) {
      String? type = get(e, ['value', 'type'], '');

      int flex = ConvertData.stringToInt(get(e, ['value', 'flex'], '1'), 1);
      bool enableFlex = get(e, ['value', 'enableFlex'], true);

      EdgeInsetsDirectional margin = ConvertData.space(
        get(e, ['value', 'margin'], null),
        'margin',
        EdgeInsetsDirectional.zero,
      );

      EdgeInsetsDirectional padding = ConvertData.space(
        get(e, ['value', 'padding'], null),
        'padding',
        EdgeInsetsDirectional.only(start: 20, end: 20),
      );
      Color foreground = ConvertData.fromRGBA(get(e, ['value', 'foreground', themeModeKey]), Colors.transparent);

      Widget child = Container(
        margin: margin,
        padding: padding,
        color: foreground,
        child: buildBlock(type),
      );

      if (enableFlex) {
        return Expanded(
          child: child,
          flex: flex,
        );
      }
      return child;
    }).toList();
  }

  Widget buildBlock(String? type) {
    switch (type) {
      case PostBlocks.Category:
        return PostCategory(
          post: post,
          styles: styles,
        );
      case PostBlocks.Name:
        return PostName(
          post: post,
          color: color,
        );
      case PostBlocks.FeatureImage:
        return Column(
          children: [
            LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              double maxWidth = constraints.maxWidth;
              double width = MediaQuery.of(context).size.width;

              double widthImage = maxWidth is double && maxWidth != double.infinity ? maxWidth : width;
              double heightImage = widthImage * 0.8;

              return PostImage(post: post, width: widthImage, height: heightImage);
            }),
          ],
        );
      case PostBlocks.Author:
        return PostAuthor(
          post: post,
          color: color,
        );
      case PostBlocks.CountComment:
        return PostCommentCount(
          post: post,
          color: color,
        );
      case PostBlocks.Date:
        return PostDate(
          post: post,
          color: color,
        );
      case PostBlocks.Wishlist:
        return PostWishlist(
          post: post,
          color: color,
        );
      case PostBlocks.Share:
        return PostShare(post: post, color: color);
      case PostBlocks.NavigateComment:
        return PostNavigateComment(
          post: post,
          color: color,
        );
      case PostBlocks.Content:
        return PostContent(post: post);
      case PostBlocks.Tag:
        return PostTagWidget(
          post: post,
          paddingHorizontal: 0,
        );
      case PostBlocks.Comments:
        return PostComments(
          post: post,
        );
      default:
        return Container(child: Text(type!));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (rows == null || rows!.isEmpty) {
      return Container();
    }
    ThemeData theme = Theme.of(context);

    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(rows!.length, (index) {
        dynamic e = rows![index];
        String? mainAxisAlignment = get(e, ['data', 'mainAxisAlignment'], 'start');
        String? crossAxisAlignment = get(e, ['data', 'crossAxisAlignment'], 'start');
        bool divider = get(e, ['data', 'divider'], false);
        List<dynamic>? columns = get(e, ['data', 'columns']);
        return Column(
          children: [
            Row(
              mainAxisAlignment: ConvertData.mainAxisAlignment(mainAxisAlignment),
              crossAxisAlignment: ConvertData.crossAxisAlignment(crossAxisAlignment),
              children: buildColumn(columns, theme: theme, themeModeKey: themeModeKey),
            ),
            if (divider)
              Divider(
                height: 1,
                thickness: 1,
                endIndent: 20,
                indent: 20,
              ),
          ],
        );
      }),
    );
  }
}
