import 'package:cirilla/mixins/app_bar_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ForgotScreen extends StatefulWidget {
  static const routeName = '/forgot';

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  AuthStore? _authStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authStore ??= Provider.of<AuthStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return ForgotPassword(authStore: _authStore);
      },
    );
  }
}

class ForgotPassword extends StatelessWidget with AppBarMixin, SnackMixin {
  final _formKey = GlobalKey<FormState>();
  final _txtEmail = TextEditingController();

  final AuthStore? authStore;

  ForgotPassword({
    Key? key,
    required this.authStore,
  }) : super(key: key);

  void onSubmit(BuildContext context, {String? email, required TranslateType translate}) async {
    try {
      await authStore!.forgotPasswordStore.forgotPassword(email);
      showSuccess(context, translate('forgot_password_success'));
    } catch (e) {
      showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate('forgot_password_appbar')!),
      body: SafeArea(
        child: renderForm(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      Text(translate('forgot_password_description')!, style: textTheme.bodyText1),
                      SizedBox(height: 24),
                      renderEmailField(translate),
                      SizedBox(height: 24),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: !authStore!.forgotPasswordStore.loading
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    String email = _txtEmail.text;
                                    onSubmit(context, email: email, translate: translate);
                                  }
                                }
                              : () {},
                          child: authStore!.forgotPasswordStore.loading
                              ? SpinKitThreeBounce(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  size: 20.0,
                                )
                              : Text(translate('forgot_password_btn')!),
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderForm({required Widget child}) {
    return Form(
      key: _formKey,
      child: child,
    );
  }

  Widget renderEmailField(TranslateType translate) {
    return TextFormField(
      controller: _txtEmail,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('validate_email_required');
        }
        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
          return translate('validate_email_value');
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: translate('input_email'),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
