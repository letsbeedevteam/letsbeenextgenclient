import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/signInResponse.dart';
import 'package:letsbeeclient/screens/auth/social/controller/auth_contract.dart';
import 'package:letsbeeclient/screens/auth/social/controller/auth_presenter.dart';
import 'package:letsbeeclient/services/api_service.dart';

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

  void signIn() {

    isLoading(true);
    dismissKeyboard(Get.context);
    
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {

      errorSnackbarTop(title: 'Oops!', message: 'Please input your required field(s)');
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
              alertSnackBarTop(title: 'Oops!', message: 'Sign In Failed. Please try again.');
            } else {
              alertSnackBarTop(title: 'Oops!', message: 'Your Let\'s Bee Account doesn\'t exist.');
            }
          }
          isLoading(false);

        }).catchError((onError) {
          print('Sign In: $onError');
          alertSnackBarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
          isLoading(false);
        });

      } else {
        errorSnackbarTop(title: 'Oops!', message: 'Your email address is invalid');
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
  void onInit() {
    _presenter = AuthPresenter(controller: this);
    super.onInit();
  }

  @override
  void setLoading(bool isLoading) {
    this.isLoading(isLoading);
  }

  @override
  void onSocialSignInSuccess(String social, SignInData data) {
    _box.write(Config.SOCIAL_LOGIN_TYPE, social);
    Get.toNamed(Config.USER_DETAILS_ROUTE, arguments: data.toJson()).whenComplete(() {
      isGoogleLoading(false);
      isFacebookLoading(false);
      isKakaoLoading(false);
    });
  }

  @override
  void onError(String error) {
    if (error != 'User cancelled') errorSnackBarBottom(title: 'Error', message: error);
    isGoogleLoading(false);
    isFacebookLoading(false);
    isKakaoLoading(false);
    print(error);
  }
}