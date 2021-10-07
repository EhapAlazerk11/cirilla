import 'package:cirilla/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

mixin FacebookLoginMixin<T extends StatefulWidget> on State<T> {
  Future loginFacebook(Function? login) async {
    try {
      // by default the login method has the next permissions ['email','public_profile']
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        login!({
          'type': Strings.loginFacebook,
          'token': result.accessToken!.token,
        });
      } else {
        print(result.status);
        print(result.message);
      }
    } catch (e) {
      print(e);
    }
  }
}
