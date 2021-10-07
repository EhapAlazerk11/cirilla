import 'package:cirilla/screens/post/comment_modal_reply.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/post_comment/post_comment_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/screens/auth/login_screen.dart';

class CommentForm extends StatefulWidget {
  final PostCommentStore? commentStore;

  final String type;

  final int? parent;

  const CommentForm({Key? key, this.type = 'button', this.commentStore, this.parent}) : super(key: key);
  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  late AuthStore _authStore;

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    if (widget.type == 'text') {
      return Observer(builder: (_) {
        return _authStore.isLogin
            ? InkWell(
                onTap: () => showModal(context),
                child: Text(translate('comment_reply')!, style: Theme.of(context).textTheme.overline),
              )
            : InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamed(LoginScreen.routeName, arguments: {'showMessage': ({String? message}) => print('113')}),
                child: Text(translate('comment_reply')!, style: Theme.of(context).textTheme.overline),
              );
      });
    }
    return Observer(builder: (_) {
      return _authStore.isLogin
          ? ElevatedButton(
              child: Text(translate('comment_s')!),
              onPressed: () => showModal(context),
            )
          : ElevatedButton(
              child: Text(translate('comment_login_to_comment')!),
              onPressed: () => Navigator.of(context)
                  .pushNamed(LoginScreen.routeName, arguments: {'showMessage': ({String? message}) => print('113')}),
            );
    });
  }

  void showModal(BuildContext context) async {
    bool? success = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (
        BuildContext context,
      ) {
        return ModalReply(commentStore: widget.commentStore, parent: widget.parent);
      },
    );
    if (success != null && success) {
      widget.commentStore!.getPostComments();
    }
  }
}
