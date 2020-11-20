import 'dart:convert';

import 'package:get/get.dart';
import 'package:letsbeeclient/controllers/auth/auth_contract.dart';
import 'package:letsbeeclient/models/social.dart';
import 'package:letsbeeclient/services/auth_service.dart';
import 'package:letsbeeclient/_utils/config.dart';

class AuthModel implements AuthModelContract {

  final AuthService _authService = Get.find();

  @override
  void onGoogleSignInRequest(OnSocialSignInRequest listener) {
    _authService.googleSignIn().then((googleSigninAccount) async {
      var auth = await googleSigninAccount.authentication;
      _request(Config.GOOGLE, auth.idToken, listener);
    }).catchError((onError) {
      if(onError.toString().contains(Config.NETWORK_ERROR)) {
        listener.onSocialSignInRequestFailed(Config.NO_INTERNET_CONNECTION);
      } else {
        listener.onSocialSignInRequestFailed(onError.toString());
      }
      print('onGoogleSignInRequestFailed: $onError');
    });
  }

  @override
  void onFacebookSignInRequest(OnSocialSignInRequest listener) {
    _authService.facebookSignIn().then((accessToken) {
      _request(Config.FACEBOOK, accessToken.token, listener);
    }).catchError((onError) {
       if (onError.toString().contains("The getter 'token' was called on null")) {
         listener.onSocialSignInRequestFailed('User cancelled');
       } 
       print('onFacebookSignInRequestFailed: $onError');
    });
  }

  @override
  void onKakaoSignInRequest(OnSocialSignInRequest listener) {
    _authService.kakaoSignIn().then((accessTokenResponse) {
      _request(Config.KAKAO, accessTokenResponse.accessToken, listener);
    }).catchError((onError) {
      if (onError.toString().contains('User canceled login.') || onError.toString().contains('REDIRECT_URL_MISMATCH')) {
        listener.onSocialSignInRequestFailed('User cancelled');
      } else if (onError.toString().contains('net::ERR_INTERNET_DISCONNECTED')) {
        listener.onSocialSignInRequestFailed(Config.NO_INTERNET_CONNECTION);
      }
      print('onKakaoSignInRequestFailed: $onError');
    });
  }

  @override
  void onAppleSignInRequest(OnSocialSignInRequest listener) {
    _authService.appleSignIn().then((credential) {
      _request(Config.APPLE, credential.identityToken, listener);
    }).catchError((onError) {
      if (onError.toString().contains('AuthorizationErrorCode.canceled')) {
        listener.onSocialSignInRequestFailed('User cancelled');
      }
      print('onAppleSignInRequestFailed: $onError');
    });
  }

  void _request(String social, String token, OnSocialSignInRequest listener) {
    _authService.socialRequest(social, token).then((response) { 
      var model = Social.fromJson(jsonDecode(response.body));
      if (model.status == 200) {
        listener.onSocialSignInRequestSuccess(social, model.data);
      } else {
        listener.onSocialSignInRequestFailed(response.body);
      }
    }).catchError((onError) {
      if (onError.toString().contains('Connection timed out')) {
        listener.onSocialSignInRequestFailed('Connection timed out');
      } else {
        listener.onSocialSignInRequestFailed('$social request onError: $onError');
      }
    });
  }
}