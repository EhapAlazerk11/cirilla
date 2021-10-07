import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/form_field_validator.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class EditAccountScreen extends StatefulWidget {
  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> with SnackMixin, AppBarMixin, LoadingMixin {
  final _formKey = GlobalKey<FormState>();

  final _txtFirstName = TextEditingController();
  final _txtLastName = TextEditingController();
  final _txtDisplayName = TextEditingController();
  final _txtEmail = TextEditingController();

  FocusNode? _lastNameFocusNode;
  FocusNode? _displayNameFocusNode;
  FocusNode? _emailFocusNode;

  AuthStore? _authStore;

  @override
  void initState() {
    super.initState();

    _lastNameFocusNode = FocusNode();
    _displayNameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    if (_authStore == null) {
      _authStore = Provider.of<AuthStore>(context);
      _txtFirstName.text = _authStore!.user!.firstName!;
      _txtLastName.text = _authStore!.user!.lastName!;
      _txtDisplayName.text = _authStore!.user!.displayName!;
      _txtEmail.text = _authStore!.user!.userEmail!;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _txtFirstName.dispose();
    _txtLastName.dispose();
    _txtDisplayName.dispose();
    _txtEmail.dispose();

    _lastNameFocusNode!.dispose();
    _displayNameFocusNode!.dispose();
    _emailFocusNode!.dispose();
    super.dispose();
  }

  void saveAccount() async {
    if (_formKey.currentState!.validate()) {
      try {
        Map<String, dynamic> data = {
          'first_name': _txtFirstName.text,
          'last_name': _txtLastName.text,
          'name': _txtDisplayName.text,
          'email': _txtEmail.text,
        };

        await _authStore!.editAccount(data);
        showSuccess(context, "update edit successfully.");
      } catch (e) {
        showError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(
      builder: (_) {
        return Scaffold(
          appBar: baseStyleAppBar(context, title: translate('edit_account')!),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: renderForm(
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      renderFirstName(translate: translate),
                      SizedBox(height: 16),
                      renderLastName(translate: translate),
                      SizedBox(height: 16),
                      renderDisplayName(translate: translate),
                      SizedBox(height: 16),
                      renderEmail(translate: translate),
                      SizedBox(height: 24),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(translate('edit_account_save')!),
                          onPressed: saveAccount,
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              if (_authStore!.loadingEditAccount == true)
                Align(
                  child: buildLoadingOverlay(context),
                  alignment: FractionalOffset.center,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget renderForm({required Widget child}) {
    return Form(
      key: _formKey,
      child: child,
    );
  }

  Widget renderFirstName({required TranslateType translate}) {
    return TextFormField(
      controller: _txtFirstName,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('edit_account_first_name_required');
        }
        return null;
      },
      decoration: InputDecoration(labelText: translate('edit_account_first_name')),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_lastNameFocusNode);
      },
    );
  }

  Widget renderLastName({required TranslateType translate}) {
    return TextFormField(
      controller: _txtLastName,
      focusNode: _lastNameFocusNode,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('edit_account_last_name_required');
        }
        return null;
      },
      decoration: InputDecoration(labelText: translate('edit_account_last_name')),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_displayNameFocusNode);
      },
    );
  }

  Widget renderDisplayName({required TranslateType translate}) {
    return TextFormField(
      controller: _txtDisplayName,
      focusNode: _displayNameFocusNode,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('edit_account_display_name_required');
        }
        return null;
      },
      decoration: InputDecoration(labelText: translate('edit_account_display_name')),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_emailFocusNode);
      },
    );
  }

  Widget renderEmail({required TranslateType translate}) {
    return TextFormField(
      controller: _txtEmail,
      focusNode: _emailFocusNode,
      validator: (value) => emailValidator(value: value!, errorEmail: translate('validate_email_value')),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(labelText: translate('edit_account_email_address')),
    );
  }
}
