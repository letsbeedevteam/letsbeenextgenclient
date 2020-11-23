import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/controllers/auth/auth_contract.dart';
import 'package:letsbeeclient/controllers/auth/auth_presenter.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/social.dart';

class AuthController extends GetxController implements AuthViewContract {
  
  AuthPresenter _presenter;

  final GetStorage _box = Get.find();

  var isLoading = false.obs;

  var socialColor = Colors.black.obs;
  
  void googleSignIn() {
    socialColor.value = Colors.red;
    _presenter.googleSignIn();
    update();
  }

  void facebookSignIn() {
    socialColor.value = Colors.blue;
    _presenter.facebookSignIn();
    update();
  }

  void kakaoSignIn() {
    socialColor.value = Colors.brown;
    _presenter.kakaoSignIn();
    update();
  }

  void appleSignIn() {
    socialColor.value = Colors.black;
    _presenter.appleSignIn();
    update();
  }

  @override
  void onInit() {
    _presenter = AuthPresenter(controller: this);
    super.onInit();
  }

  @override
  void setLoading(bool isLoading) {
    this.isLoading.value = isLoading;
    update();
  }

  @override
  void onSocialSignInSuccess(String social, SocialData data) {
      print('LOL: ${data.toJson()}');
      _box.write(Config.SOCIAL_LOGIN_TYPE, social);
      _box.write(Config.IS_LOGGED_IN, true);
      _box.write(Config.USER_NAME, data.name);
      _box.write(Config.USER_EMAIL, data.email);
      _box.write(Config.USER_TOKEN, data.accessToken);
      Get.offAllNamed(Config.SETUP_LOCATION_ROUTE);
  }

  @override
  void onError(String error) {
    if (error != 'User cancelled') customSnackbar(title: 'Error', message: error);
    print(error);
  }
}