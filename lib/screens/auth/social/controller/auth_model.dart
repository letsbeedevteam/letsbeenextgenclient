import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/screens/auth/social/controller/auth_contract.dart';
import 'package:letsbeeclient/services/auth_service.dart';
import 'package:letsbeeclient/_utils/config.dart';

class AuthModel implements AuthModelContract {

  final AuthService _authService = Get.find();

  @override
  void onGoogleSignInRequest(OnSocialSignInRequest listener) {
    _authService.googleSignIn().then((googleSigninAccount) async {
      var auth = await googleSigninAccount.authentication;
      copyText(auth.idToken);
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
      copyText(accessToken.token);
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
      copyText(accessTokenResponse.accessToken);
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
      copyText(credential.identityToken);
      _request(Config.APPLE, credential.identityToken, listener);
    }).catchError((onError) {
      if (onError.toString().contains('AuthorizationErrorCode.canceled') || onError.toString().contains('AuthorizationErrorCode.unknown')) {
        listener.onSocialSignInRequestFailed('User cancelled');
      }
      print('onAppleSignInRequestFailed: $onError');
    });
  }

  void _request(String social, String token, OnSocialSignInRequest listener) {
    _authService.socialRequest(social, token).then((response) { 

      if (response.status == 200) {
        listener.onSocialSignInRequestSuccess(social, response.data);
      } else {
        listener.onSocialSignInRequestFailed(Config.SOMETHING_WENT_WRONG);
      }
    }).catchError((onError) {
      if (onError.toString().contains('Connection timed out')) {
        listener.onSocialSignInRequestFailed('Connection timed out');
      } else if (onError.toString().contains('Operation timed out')) {
        listener.onSocialSignInRequestFailed(Config.TIMED_OUT);
      } else {
        listener.onSocialSignInRequestFailed(Config.SOMETHING_WENT_WRONG);
      }
      print('$social request onError: $onError');
    });
  }
}