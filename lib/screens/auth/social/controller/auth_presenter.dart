import 'package:get/get.dart';
import 'package:letsbeeclient/models/signInResponse.dart';
// import 'package:letsbeeclient/models/social.dart';

import 'auth_contract.dart';
import 'auth_controller.dart';
import 'auth_model.dart';

class AuthPresenter implements AuthPresenterContract, OnSocialSignInRequest {
  
  final AuthController controller;
  AuthPresenter({this.controller});

  final AuthModel _model = Get.find();

  @override
  void googleSignIn() {
    _model.onGoogleSignInRequest(this);
  }

 @override
  void facebookSignIn() {
    _model.onFacebookSignInRequest(this);
  }

  @override
  void kakaoSignIn() {
    _model.onKakaoSignInRequest(this);
  }

  @override
  void appleSignIn() {
    _model.onAppleSignInRequest(this);
  }

  @override
  void onSocialSignInRequestSuccess(String social, SignInData data) {
    controller.onSocialSignInSuccess(social, data);
  }

  @override
  void onSocialSignInRequestFailed(String error) {
    controller.onError(error);
  }
}