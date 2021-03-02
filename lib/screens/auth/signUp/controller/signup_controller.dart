import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/signInResponse.dart';
import 'package:letsbeeclient/screens/auth/social/controller/auth_contract.dart';
import 'package:letsbeeclient/screens/auth/social/controller/auth_presenter.dart';

class SignUpController extends GetxController implements AuthViewContract {

  AuthPresenter _presenter;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final emailFN = FocusNode();
  final passwordFN = FocusNode();
  final confirmPasswordFN = FocusNode();

  final keyboardVisibilityController = KeyboardVisibilityController();

  var isLoading = false.obs;
  var isShowPassword = false.obs;
  var isShowConfirmPassword = false.obs;
  var isKeyboardVisible = false.obs;

  var isGoogleLoading = false.obs;
  var isFacebookLoading = false.obs;
  var isKakaoLoading = false.obs;
  var isAgreeTerms = true.obs;


  var signUpName = ''.obs;
  var signUpEmail = ''.obs;
  var signUpPassword = ''.obs;
  var signUpCellphoneNumber = ''.obs;

  static SignUpController get to => Get.find();

  @override
  void onInit() {
    _presenter = AuthPresenter(controller: this);
    keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible(visible);
    });

    super.onInit();
  }

  void googleSignIn() {
    isGoogleLoading(true);
    _presenter.googleSignIn();
  }

  void facebookSignIn() {
    isFacebookLoading(true);
    _presenter.facebookSignIn();
  }

  void kakaoSignIn() {
    isKakaoLoading(true);
    _presenter.kakaoSignIn();
  }

  void appleSignIn() {
    _presenter.appleSignIn();
  }

  void signUp() {

    if (emailController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      errorSnackbarTop(title: 'Oops!', message: 'Please input your required field(s)');

    } else {
      
      if(GetUtils.isEmail(emailController.text)) {

        if (confirmPasswordController.text == passwordController.text) {
            
          signUpEmail(emailController.text);
          signUpPassword(passwordController.text);

          Get.toNamed(Config.USER_DETAILS_ROUTE).whenComplete(() {
            isShowConfirmPassword(false);
            isShowPassword(false);
            dismissKeyboard(Get.context);
          });

        } else {
          isLoading(false);
          errorSnackbarTop(title: 'Oops!', message: 'Your repeat password is incorrect.');

          confirmPasswordController.selection = TextSelection.fromPosition(TextPosition(offset: confirmPasswordController.text.length));
          confirmPasswordFN.requestFocus();
        }

      } else {
        errorSnackbarTop(title: 'Oops!', message: 'Your email address is invalid.');
        isLoading(false);
      }
    }
  }

  void goToVerifyNumber() {
     dismissKeyboard(Get.context);
     successSnackBarTop(title: 'Yay!', message: 'Registered successfully! Please sign in your account.');
  }

  void clear() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
  
  Future<bool> willPopCallback() async {
    dismissKeyboard(Get.context);
    Get.back(closeOverlays: true);
    return true;
  }

  @override
  void onError(String error) {
    if (error != 'User cancelled') errorSnackBarBottom(title: 'Error', message: error);
    isGoogleLoading(false);
    isFacebookLoading(false);
    isKakaoLoading(false);
    print(error);
  }

  @override
  void onSocialSignInSuccess(String social, SignInData data) {
    print(data.toJson());
    //  _box.write(Config.SOCIAL_LOGIN_TYPE, social);
    //   Get.toNamed(Config.USER_DETAILS_ROUTE, arguments: data.toJson()).whenComplete(() {
    //   isGoogleLoading(false);
    //   isFacebookLoading(false);
    //   isKakaoLoading(false);
    // });
  }

  @override
  void setLoading(bool isLoading) {
    this.isLoading(isLoading);
  }
}