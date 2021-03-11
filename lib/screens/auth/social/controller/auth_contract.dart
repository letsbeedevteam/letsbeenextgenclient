
import 'package:letsbeeclient/_utils/_base/BaseView.dart';
import 'package:letsbeeclient/models/signin_response.dart';

abstract class AuthModelContract {
  void onGoogleSignInRequest(OnSocialSignInRequest listener) {}
  void onFacebookSignInRequest(OnSocialSignInRequest listener) {}
  void onKakaoSignInRequest(OnSocialSignInRequest listener) {}
  void onAppleSignInRequest(OnSocialSignInRequest listener) {}
}

abstract class AuthViewContract extends BaseView {
  void onSocialSignInSuccess(String social, SignInData data) {}
}

abstract class AuthPresenterContract {
  void googleSignIn() {}
  void facebookSignIn() {}
  void kakaoSignIn() {}
  void appleSignIn() {}
}

// LISTENER
abstract class OnSocialSignInRequest {
  void onSocialSignInRequestSuccess(String social, SignInData data) {}
  void onSocialSignInRequestFailed(String error) {}
}

