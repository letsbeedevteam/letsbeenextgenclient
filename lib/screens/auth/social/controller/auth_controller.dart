import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/signin_response.dart';
import 'package:letsbeeclient/screens/auth/social/controller/auth_contract.dart';
import 'package:letsbeeclient/screens/auth/social/controller/auth_presenter.dart';
import 'package:letsbeeclient/services/api_service.dart';
import 'package:easy_localization/easy_localization.dart';

class AuthController extends GetxController implements AuthViewContract {
  
  AuthPresenter _presenter;

  final GetStorage _box = Get.find();
  final ApiService _apiService = Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFN = FocusNode();
  final passwordFN = FocusNode();

  var isLoading = false.obs;
  var isGoogleLoading = false.obs;
  var isFacebookLoading = false.obs;
  var isKakaoLoading = false.obs;
  var isShowPassword = false.obs;
  var isRememberMe = false.obs;

  var language = ''.obs;

  StreamSubscription<SignInResponse> signInSub;

  @override
  void onInit() {
    _presenter = AuthPresenter(controller: this);

    language(_box.hasData(Config.LANGUAGE) ? _box.read(Config.LANGUAGE) : 'EN');
    isRememberMe(_box.hasData(Config.IS_REMEMBER_ME) ? _box.read(Config.IS_REMEMBER_ME) : false);

    if(_box.hasData(Config.USER_EMAIL) && _box.hasData(Config.USER_PASSWORD)) {
      
      if (isRememberMe.call()) {
        emailController.text = _box.read(Config.USER_EMAIL);
        passwordController.text = _box.read(Config.USER_PASSWORD);
        passwordController.selectedText();
      } else {
        _box.remove(Config.USER_EMAIL);
        _box.remove(Config.USER_PASSWORD);
      } 
    }

    super.onInit();
  }

  goToSignUp() => Get.toNamed(Config.SIGNUP_ROUTE).then((data) {
    isGoogleLoading(false);
    isFacebookLoading(false);
    isKakaoLoading(false);
    isLoading(false);
    signInSub?.cancel();
    _presenter.closeSubscriptions();
  });

  goToForgotPassword() =>  Get.toNamed(Config.FORGOT_PASS_ROUTE).then((data) {
    isGoogleLoading(false);
    isFacebookLoading(false);
    isKakaoLoading(false);
    isLoading(false);
    signInSub?.cancel();
    _presenter.closeSubscriptions();
  });

  setRememberMe(bool isRememberMe) {
    this.isRememberMe(isRememberMe);
    _box.write(Config.IS_REMEMBER_ME, this.isRememberMe.call());
  }

  @override
  void onClose() {
    signInSub?.cancel();
    _presenter.closeSubscriptions();
    super.onClose();
  }

  void changeLanguage(String lang) {
    language(lang);
    _box.write(Config.LANGUAGE, lang);
    Get.context.locale = lang == 'EN' ? Locale('en', 'US') : Locale('ko', 'KR');
    Get.back();
  } 

  void signIn() {

    isLoading(true);
    dismissKeyboard(Get.context);
    
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {

      errorSnackbarTop(title: tr('oops'), message: tr('inputFields'));
      isLoading(false);
    } else {
      if(GetUtils.isEmail(emailController.text)) {
        
        signInSub = _apiService.customerSignIn(email: emailController.text, password: passwordController.text).asStream().listen((response) {
          if (response.status == Config.OK) {
            
            if(isRememberMe.call()) {
              _box.write(Config.USER_EMAIL, emailController.text);
              _box.write(Config.USER_PASSWORD, passwordController.text);
            }

            _box.write(Config.SOCIAL_LOGIN_TYPE, Config.EMAIL);
            Get.toNamed(Config.VERIFY_NUMBER_ROUTE, arguments: response.data.toJson()).whenComplete(() {
              if(!isRememberMe.call()) {
                emailController.clear();
                passwordController.clear();
              }
              dismissKeyboard(Get.context);
            });

          } else if (response.status == Config.NOT_FOUND) {
            alertSnackBarTop(title: tr('oops'), message: tr('accountNotExist'));
            emailController.selection = TextSelection.fromPosition(TextPosition(offset: emailController.text.length));
            emailFN.requestFocus();
          } else {

            alertSnackBarTop(title: tr('oops'), message: tr('signInFailed'));
            passwordController.selection = TextSelection.fromPosition(TextPosition(offset: passwordController.text.length));
            passwordFN.requestFocus();
          }

          isLoading(false);

        })..onError((onError) {
          print('Sign In: $onError');
          alertSnackBarTop(title: tr('oops'), message: tr('somethingWentWrong'));
          isLoading(false);
          passwordController.selection = TextSelection.fromPosition(TextPosition(offset: passwordController.text.length));
          passwordFN.requestFocus();
        });

      } else {
        errorSnackbarTop(title: tr('oops'), message: tr('emailInvalid'));
        isLoading(false);
        emailController.selection = TextSelection.fromPosition(TextPosition(offset: emailController.text.length));
        emailFN.requestFocus();
      }
    }
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

  @override
  void setLoading(bool isLoading) {
    this.isLoading(isLoading);
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
  void onError(String error) {
    if (error != 'User cancelled') errorSnackBarBottom(title: tr('oops'), message: tr('somethingWentWrong'));
    isGoogleLoading(false);
    isFacebookLoading(false);
    isKakaoLoading(false);
    print(error);
  }
}