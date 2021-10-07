import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/mixins/snack_mixin.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/utils/app_localization.dart';

class ChangePasswordScreen extends StatefulWidget {
  final HandleLoginType? handleLogin;

  const ChangePasswordScreen({Key? key, this.handleLogin}) : super(key: key);
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> with SnackMixin, AppBarMixin {
  late AuthStore _authStore;

  final _formKey = GlobalKey<FormState>();
  final _txtPassword = TextEditingController();
  final _txtNewPassword = TextEditingController();
  final _txtConfirmPassword = TextEditingController();

  bool obscureTextPassword = true;
  bool obscureTextNewPassword = true;
  bool obscureTextConfirmPassword = true;

  FocusNode? _newPasswordFocusNode;
  FocusNode? _confirmPasswordFocusNode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authStore = Provider.of<AuthStore>(context);
  }

  @override
  void initState() {
    super.initState();
    _newPasswordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _txtPassword.dispose();
    _txtNewPassword.dispose();
    _txtConfirmPassword.dispose();

    _newPasswordFocusNode!.dispose();
    _confirmPasswordFocusNode!.dispose();
    super.dispose();
  }

  void submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (_txtNewPassword.text == _txtPassword.text) {
      showError(context, "Old Password and new password cannot be same.");
    } else if (_txtNewPassword.text != _txtConfirmPassword.text) {
      showError(context, "New passwords do not match.");
    } else {
      try {
        final res = await _authStore.changePasswordStore.changePassword(
          _txtPassword.text,
          _txtNewPassword.text,
        );
        if (res.toString() == _authStore.user!.id.toString()) {
          showSuccess(context, "change password successfully.");
        }
      } catch (e) {
        showError(context, e);
      }
    }
    _formKey.currentState!.save();
  }

  void updateObscure(String type) {
    setState(() {
      switch (type) {
        case 'confirm_password':
          obscureTextConfirmPassword = !obscureTextConfirmPassword;
          return;
        case 'new_password':
          obscureTextNewPassword = !obscureTextNewPassword;
          return;
        default:
          obscureTextPassword = !obscureTextPassword;
          return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate('change_password')!),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: renderForm(
          child: Column(
            children: [
              SizedBox(height: 12),
              renderPassword(translate: translate),
              SizedBox(height: 16),
              renderNewPassword(translate: translate),
              SizedBox(height: 16),
              renderConfirm(translate: translate),
              SizedBox(height: 24),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  child: Text(
                    translate('change_password_save')!,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      submit();
                    }
                  },
                ),
              )
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

  Widget renderPassword({required TranslateType translate}) {
    return TextFormField(
      controller: _txtPassword,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('change_password_old_required');
        }
        return null;
      },
      obscureText: obscureTextPassword,
      decoration: InputDecoration(
        labelText: translate('change_password_old'),
        suffixIcon: IconButton(
          iconSize: 16,
          icon: Icon(obscureTextPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: () => updateObscure('password'),
        ),
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_newPasswordFocusNode);
      },
    );
  }

  Widget renderNewPassword({required TranslateType translate}) {
    return TextFormField(
      controller: _txtNewPassword,
      focusNode: _newPasswordFocusNode,
      validator: (value) => changePassword(
        value: value!,
        errorPassNew: translate('change_password_old_required'),
        errorCharInLength: translate('validate_characters_in_length'),
        errorUpperCase: translate('validate_one_upper_case'),
        errorLowerCase: translate('validate_one_lower_case'),
        errorDigit: translate('validate_one_digit'),
        errorSpecial: translate('validate_one_special_character'),
        errorNewDiffOld: translate('change_password_new_diff_old'),
        password: _txtPassword.text,
      ),
      obscureText: obscureTextNewPassword,
      decoration: InputDecoration(
        labelText: translate('change_password_new'),
        suffixIcon: IconButton(
          iconSize: 16,
          icon: Icon(obscureTextNewPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: () => updateObscure('new_password'),
        ),
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
    );
  }

  Widget renderConfirm({required TranslateType translate}) {
    return TextFormField(
      controller: _txtConfirmPassword,
      focusNode: _confirmPasswordFocusNode,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('change_password_confirm_required');
        }
        if (value != _txtNewPassword.text) {
          return translate('change_password_confirm_same_new');
        }
        return null;
      },
      obscureText: obscureTextConfirmPassword,
      decoration: InputDecoration(
        labelText: translate('change_password_confirm'),
        suffixIcon: IconButton(
          iconSize: 16,
          icon: Icon(obscureTextConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: () => updateObscure('confirm_password'),
        ),
      ),
    );
  }
}
