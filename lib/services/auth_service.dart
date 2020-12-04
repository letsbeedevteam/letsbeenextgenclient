import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class AuthService extends GetxService {

  final GoogleSignIn _googleSignIn = Get.find();
  final FacebookLogin _facebookLogin = Get.find();

  Future<http.Response> socialRequest(String social, String token) {
    return http.post(
      Config.BASE_URL + '/auth/customer/${social.toLowerCase()}/login',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'token': token
      })
    );
  }

  Future<GoogleSignInAccount> googleSignIn() async {
    final googleSignInAccount = await _googleSignIn.signIn();

    if (googleSignInAccount == null) {
      throw 'User cancelled';
    } 

    return googleSignInAccount;
  }

  Future<FacebookAccessToken> facebookSignIn() async {
    _facebookLogin.loginBehavior = FacebookLoginBehavior.webOnly;
    final result = await _facebookLogin.logIn(['email']);

    return result.accessToken != null ? result.accessToken : null;
  }

  Future<AccessTokenResponse> kakaoSignIn() async {
    final authCode = await AuthCodeClient.instance.request();

    return AuthApi.instance.issueAccessToken(authCode);
  }

  Future<AuthorizationCredentialAppleID> appleSignIn() async => await SignInWithApple.getAppleIDCredential(scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName]);
}