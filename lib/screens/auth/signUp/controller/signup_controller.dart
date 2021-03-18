import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/signin_response.dart';
import 'package:letsbeeclient/screens/auth/social/controller/auth_contract.dart';
import 'package:letsbeeclient/screens/auth/social/controller/auth_presenter.dart';

class SignUpController extends GetxController implements AuthViewContract {

  AuthPresenter _presenter;
  final GetStorage _box = Get.find();
  
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
      errorSnackbarTop(title: tr('oops'), message: tr('inputFields'));

    } else {
      
      if(GetUtils.isEmail(emailController.text)) {

        if (confirmPasswordController.text == passwordController.text) {
            
          signUpEmail(emailController.text);
          signUpPassword(passwordController.text);

          Get.toNamed(Config.USER_DETAILS_ROUTE).whenComplete(() {
            isShowConfirmPassword(false);
            isShowPassword(false);
            dismissKeyboard(Get.context);
            if (signUpEmail.call().isNotEmpty || signUpPassword.call().isNotEmpty) clear();
          });

        } else {
          isLoading(false);
          errorSnackbarTop(title: tr('oops'), message: tr('incorrectRepeatPassword'));

          confirmPasswordController.selection = TextSelection.fromPosition(TextPosition(offset: confirmPasswordController.text.length));
          confirmPasswordFN.requestFocus();
        }

      } else {
        errorSnackbarTop(title: tr('oops'), message: tr('emailInvalid'));
        isLoading(false);
      }
    }
  }

  void goToVerifyNumber() {
     dismissKeyboard(Get.context);
     successSnackBarTop(title: tr('yay'), message: tr('registeredSuccess'));
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
    if (error != 'User cancelled') errorSnackBarBottom(title: tr('oops'), message: tr('somethingWentWrong'));
    isGoogleLoading(false);
    isFacebookLoading(false);
    isKakaoLoading(false);
    print(error);
  }

  @override
  void onSocialSignInSuccess(String social, SignInData data) {
    print(data.toJson());
    _box.write(Config.SOCIAL_LOGIN_TYPE, social);
    if (data.cellphoneNumber == null) {
      Get.toNamed(Config.USER_DETAILS_ROUTE, arguments: data.toJson());
    } else {
      Get.toNamed(Config.VERIFY_NUMBER_ROUTE, arguments: data.toJson());
    }

    isGoogleLoading(false);
    isFacebookLoading(false);
    isKakaoLoading(false);
    dismissKeyboard(Get.context);
  }

  @override
  void setLoading(bool isLoading) {
    this.isLoading(isLoading);
  }
}