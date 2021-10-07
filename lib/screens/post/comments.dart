import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/app_bar_mixin.dart';
import 'package:cirilla/models/post/post_comment.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/post_comment/post_comment_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/date_format.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ui/ui.dart';

import 'comment_form.dart';

class Comments extends StatefulWidget {
  final int? post;
  final PostComment? parent;
  final top;
  final RequestHelper? requestHelper;

  Comments({Key? key, this.post, this.parent, this.requestHelper, this.top}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  PostCommentStore? _commentStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _commentStore = PostCommentStore(
      widget.requestHelper,
      post: widget.post,
      parent: widget.parent != null ? widget.parent!.id : 0,
    )..getPostComments();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(
      builder: (_) {
        if (_commentStore!.loading) {
          return buildLoading(context: context);
        }

        List<PostComment> _comments = _commentStore!.postComments;

        if (widget.top == 0) {
          return Column(
            children: List.generate(_comments.length + 1, (index) {
              // Render button Read more and Comments
              if (index == _comments.length) {
                return buildMore(top: widget.top);
              }

              // Render comment Item
              final comment = _comments[index];
              return buildItem(comment: comment, first: index == 0);
            }),
          );
          // return SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (context, index) {
          //       // Render button Read more and Comments
          //       if (index == _comments.length) {
          //         return buildMore(top: widget.top);
          //       }
          //
          //       // Render comment Item
          //       final comment = _comments[index];
          //       return buildItem(comment: comment, first: index == 0);
          //     },
          //     childCount: _comments.length + 1,
          //   ),
          // );
        }

        return Container(
          child: _comments.length > 0
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, _a1, _a2) => CommentsModal(
                          requestHelper: widget.requestHelper,
                          post: widget.post,
                          parent: widget.parent,
                        ),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          Offset begin = Offset(0.0, 1.0);
                          Offset end = Offset.zero;
                          Curve curve = Curves.ease;

                          Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: 101,
                    height: 23,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FeatherIcons.cornerDownRight, size: 14, color: Theme.of(context).colorScheme.onSurface),
                        SizedBox(width: 4),
                        if (_comments.length > 1)
                          Text(translate('comment_feedbacks', {'count': '${_comments.length}'})!,
                              style: Theme.of(context).textTheme.overline),
                        if (_comments.length == 1)
                          Text(translate('comment_feedback', {'count': '${_comments.length}'})!,
                              style: Theme.of(context).textTheme.overline),
                      ],
                    ),
                  ),
                )
              : Container(),
        );
      },
    );
  }

  Widget buildLoading({BuildContext? context}) {
    return SpinKitThreeBounce(
      color: Theme.of(context!).primaryColor,
      size: 30.0,
    );
  }

  Widget buildMore({int? top = 0}) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Container(
      padding: EdgeInsetsDirectional.only(end: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_commentStore!.canLoadMore)
            OutlinedButton(
              onPressed: () => _commentStore!.getPostComments(),
              child: Text(translate('comment_show_more')!),
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: itemPaddingLarge, vertical: itemPadding)),
            ),
          if (_commentStore!.canLoadMore) SizedBox(width: itemPaddingMedium),
          CommentForm(commentStore: _commentStore),
        ],
      ),
    );
  }

  Widget buildItem({required PostComment comment, bool? first}) {
    return Container(
      child: Column(
        children: [
          CommentHorizontalItem(
            name: Text(
              comment.authorName!,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            image: comment.avatar!.large!,
            onClick: () => {},
            comment: Html(
              data: comment.content!.rendered,
              style: {
                "body": Style(margin: EdgeInsets.zero),
                "p": Style(margin: EdgeInsets.only(top: 11, bottom: 16)),
              },
            ),
            date: Text(formatDate(date: comment.date!), style: Theme.of(context).textTheme.caption),
            reply: Row(
              children: [
                CommentForm(type: 'text', commentStore: _commentStore, parent: comment.id),
                SizedBox(width: itemPaddingMedium),
                if (comment.children!)
                  Comments(
                    post: comment.post,
                    requestHelper: widget.requestHelper,
                    parent: comment,
                    top: 1,
                  )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: itemPaddingLarge),
            child: Divider(height: 0),
          ),
        ],
      ),
    );
  }
}

class CommentsModal extends StatelessWidget with AppBarMixin {
  final int? post;
  final PostComment? parent;
  final RequestHelper? requestHelper;

  const CommentsModal({Key? key, this.post, this.parent, this.requestHelper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: leading(),
              title: Text(translate('comment_reply')!),
            ),
            SliverToBoxAdapter(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: layoutPadding),
                  child: Column(children: [
                    CommentHorizontalItem(
                      name: Text(
                        parent!.authorName!,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      image: parent!.avatar!.large!,
                      onClick: () => {},
                      comment: Html(
                        data: parent!.content!.rendered,
                        style: {
                          "body": Style(margin: EdgeInsets.zero),
                          "p": Style(margin: EdgeInsets.only(top: 11)),
                        },
                      ),
                      date: Text(
                        formatDate(date: parent!.date!),
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: itemPaddingLarge),
                      child: Divider(height: 0),
                    ),
                  ])),
            ),
            SliverPadding(
              padding: EdgeInsetsDirectional.only(start: itemPadding * 5, end: layoutPadding),
              sliver: SliverToBoxAdapter(
                child: Comments(
                  requestHelper: requestHelper,
                  post: post,
                  parent: parent,
                  top: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
