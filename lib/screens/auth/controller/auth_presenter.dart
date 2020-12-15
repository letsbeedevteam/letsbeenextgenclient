import 'package:get/get.dart';
import 'package:letsbeeclient/screens/auth/controller/auth_controller.dart';
import 'package:letsbeeclient/screens/auth/controller/auth_contract.dart';
import 'package:letsbeeclient/screens/auth/controller/auth_model.dart';
import 'package:letsbeeclient/models/social.dart';

class AuthPresenter implements AuthPresenterContract, OnSocialSignInRequest {
  
  final AuthController controller;
  AuthPresenter({this.controller});

  final AuthModel _model = Get.find();

  @override
  void googleSignIn() {
    controller.setLoading(true);
    _model.onGoogleSignInRequest(this);
  }

 @override
  void facebookSignIn() {
    controller.setLoading(true);
    _model.onFacebookSignInRequest(this);
  }

  @override
  void kakaoSignIn() {
    controller.setLoading(true);
    _model.onKakaoSignInRequest(this);
  }

  @override
  void appleSignIn() {
    controller.setLoading(true);
    _model.onAppleSignInRequest(this);
  }

  @override
  void onSocialSignInRequestSuccess(String social, SocialData data) {
    controller.setLoading(false);
    controller.onSocialSignInSuccess(social, data);
  }

  @override
  void onSocialSignInRequestFailed(String error) {
    controller.setLoading(false);
    controller.onError(error);
  }
}