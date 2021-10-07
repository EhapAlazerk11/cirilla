import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/post_comment/post_comment_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ModalReply extends StatefulWidget {
  final PostCommentStore? commentStore;
  final int? parent;

  const ModalReply({Key? key, this.commentStore, this.parent}) : super(key: key);

  @override
  _ModalReplyState createState() => _ModalReplyState();
}

class _ModalReplyState extends State<ModalReply> with SnackMixin {
  String? _error;
  bool _loading = false;

  final _formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
          top: itemPaddingExtraLarge,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: layoutPadding,
          right: layoutPadding),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text(
              translate('comment_leave_a_reply')!,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: itemPadding,
            ),
            Text(
              translate('comment_your_email_address_will')!,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: itemPadding,
            ),
            if (_error != null) Text(_error!, style: TextStyle(color: Colors.red)),
            Padding(padding: EdgeInsets.only(top: itemPaddingLarge)),
            TextFormField(
              controller: commentController,
              minLines: 5,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: translate('comment_your_comments'),
                alignLabelWithHint: true,
                contentPadding: EdgeInsetsDirectional.only(start: itemPaddingMedium, top: itemPaddingMedium),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return translate('comment_invalid_comment_content');
                }
                return null;
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: itemPaddingExtraLarge),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  child: _loading ? CircularProgressIndicator() : Text(translate('comment_post')!),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _loading = true;
                        _error = null;
                      });
                      try {
                        // Write comment
                        await widget.commentStore!.writeComment(
                          content: commentController.text,
                          parent: widget.parent,
                        );
                        setState(() {
                          _loading = false;
                        });
                        Navigator.pop(context, true);
                      } on DioError catch (e) {
                        _error =
                            e.response != null && e.response!.data != null ? e.response!.data['message'] : e.message;
                        setState(() {
                          _loading = false;
                        });
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
