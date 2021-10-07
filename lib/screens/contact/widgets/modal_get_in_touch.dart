import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/mixins/snack_mixin.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:provider/provider.dart';

class ModalGetInTouch extends StatefulWidget {
  final String? formId;
  ModalGetInTouch({
    Key? key,
    this.formId,
  }) : super(key: key);
  @override
  _ModalGetInTouchState createState() => _ModalGetInTouchState();
}

class _ModalGetInTouchState extends State<ModalGetInTouch> with SnackMixin, LoadingMixin {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _messController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    RequestHelper requestHelper = Provider.of<RequestHelper>(context);
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        return Container(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight - 140),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: layoutPadding, vertical: itemPaddingExtraLarge),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: itemPadding),
                        child: Text(
                          translate('contact_touch')!,
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        translate('contact_questions')!,
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: itemPaddingLarge,
                      ),
                      TextFormField(
                        minLines: 10,
                        maxLines: 20,
                        controller: _messController,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsetsDirectional.only(start: itemPaddingMedium, top: itemPaddingMedium),
                            labelText: translate('contact_mess'),
                            labelStyle: Theme.of(context).textTheme.bodyText1,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignLabelWithHint: true),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return translate('contact_mess_is_required');
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: itemPaddingMedium,
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: translate('contact_name'),
                          labelStyle: Theme.of(context).textTheme.bodyText1,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsetsDirectional.only(start: itemPaddingMedium),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return translate('contact_name_is_required');
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: itemPaddingMedium,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: translate('contact_email'),
                          labelStyle: Theme.of(context).textTheme.bodyText1,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsetsDirectional.only(start: itemPaddingMedium),
                        ),
                        validator: (value) =>
                            emailValidator(value: value!, errorEmail: translate('validate_email_value')),
                      ),
                      SizedBox(
                        height: itemPaddingLarge,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _loading = true;
                                });
                                try {
                                  Map<String, dynamic> res = await requestHelper.sendContact(queryParameters: {
                                    'your-email': _emailController.text,
                                    'your-name': _nameController.text,
                                    'your-subject': 'yourSub',
                                    'your-message': _messController.text,
                                  }, formId: widget.formId);
                                  if (res['status'] != 'mail_sent') {
                                    showError(context, res['message']);
                                  } else {
                                    showSuccess(context, res['message']);
                                  }
                                  setState(() {
                                    _loading = false;
                                  });
                                } on DioError catch (e) {
                                  showError(context, e);
                                  setState(() {
                                    _loading = false;
                                  });
                                }
                              }
                            },
                            child: _loading
                                ? entryLoading(context, color: Theme.of(context).colorScheme.onPrimary)
                                : Text(
                                    translate('contact_submit')!,
                                  )),
                      ),
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }
}
