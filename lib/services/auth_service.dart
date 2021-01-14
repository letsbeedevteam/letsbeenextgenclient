import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/social.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class AuthService extends GetConnect {

  final GoogleSignIn _googleSignIn = Get.find();
  final FacebookLogin _facebookLogin = Get.find();
  
  @override
  void onInit() {
    httpClient.baseUrl = Config.BASE_URL;
    super.onInit();
  }

  Future<SocialLoginResponse> socialRequest(String social, String token) async {
    
    final response = await post(
      '/auth/customer/${social.toLowerCase()}/login',
      {'token': token},
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('Login response: ${response.body}');

    return socialFromJson(response.bodyString);
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