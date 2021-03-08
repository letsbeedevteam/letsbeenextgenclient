import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/signInResponse.dart';
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

  @override
  void onInit() {
    _presenter = AuthPresenter(controller: this);

    if (_box.hasData(Config.LANGUAGE)) {
      language(_box.read(Config.LANGUAGE));
    } else {
      language('EN');
    }
    super.onInit();
  }

  // void clear() {
  //   _box.erase();
  //   Get.context.deleteSaveLocale();
  // }

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

      errorSnackbarTop(title: Config.oops, message: Config.inputFields);
      isLoading(false);
    } else {
      if(GetUtils.isEmail(emailController.text)) {
        
        _apiService.customerSignIn(email: emailController.text, password: passwordController.text).then((response) {
          if (response.status == 200) {
            
            _box.write(Config.SOCIAL_LOGIN_TYPE, Config.EMAIL);
            Get.toNamed(Config.VERIFY_NUMBER_ROUTE, arguments: response.data.toJson()).whenComplete(() {
              emailController.clear();
              passwordController.clear();
              dismissKeyboard(Get.context);
            });

          } else {

            if (response.code != 2012) {
              alertSnackBarTop(title: Config.oops, message: Config.signInFailed);
            } else {
              alertSnackBarTop(title: Config.oops, message: Config.accountNotExist);
            }
          }
          isLoading(false);

        }).catchError((onError) {
          print('Sign In: $onError');
          alertSnackBarTop(title: Config.oops, message: Config.somethingWentWrong);
          isLoading(false);
        });

      } else {
        errorSnackbarTop(title: Config.oops, message: Config.emailInvalid);
        isLoading(false);
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
    if (error != 'User cancelled') errorSnackBarBottom(title: Config.oops, message: Config.somethingWentWrong);
    isGoogleLoading(false);
    isFacebookLoading(false);
    isKakaoLoading(false);
    print(error);
  }
}