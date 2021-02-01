import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/services/api_service.dart';

class SignUpController extends GetxController with SingleGetTickerProviderMixin {

  GetStorage _box = Get.find();
  ApiService _apiService = Get.find();

  final signInEmailController = TextEditingController();
  final signInPasswordController = TextEditingController();
  final signInEmailFN = FocusNode();
  final signInPasswordFN = FocusNode();

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final emailFN = FocusNode();
  final nameFN = FocusNode();
  final passwordFN = FocusNode();
  final confirmPasswordFN = FocusNode();

  final codeController = TextEditingController();

  var selectedIndex = 0.obs;
  var isLoading = false.obs;
  
  TabController tabController;

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }

  void signIn() {
    isLoading(true);
    dismissKeyboard(Get.context);
    
    if (signInEmailController.text.isEmpty || signInPasswordController.text.isEmpty) {

      errorSnackbarTop(title: 'Oops!', message: 'Please input your required field(s)');
      isLoading(false);
    } else {
      if(GetUtils.isEmail(signInEmailController.text)) {

        _apiService.customerSignIn(email: signInEmailController.text, password: signInPasswordController.text).then((response) {
          
          if (response.status == 200) {
            _box.write(Config.USER_NAME, response.data.name);
            _box.write(Config.USER_EMAIL, response.data.email);
            _box.write(Config.USER_MOBILE_NUMBER, response.data.cellphoneNumber);
            _box.write(Config.USER_TOKEN, response.data.accessToken);
            _box.write(Config.IS_LOGGED_IN, true);
            _box.write(Config.SOCIAL_LOGIN_TYPE, Config.EMAIL);
            // changeIndex(2);
            reset();
            Get.offAndToNamed(Config.VERIFY_NUMBER_ROUTE);
            // if (response.data.cellphoneNumber == null || response.data.cellphoneNumber == '') {
            //   Get.offAndToNamed(Config.VERIFY_NUMBER_ROUTE);
            // } else {
            //   _box.write(Config.USER_MOBILE_NUMBER, response.data.cellphoneNumber);
            //   Get.offAndToNamed(Config.SETUP_LOCATION_ROUTE);
            // }

          } else {

            if (response.code == 2000) {
              alertSnackBarTop(title: 'Oops!', message: 'Sign In Failed. Please try again.');
            } else {
              alertSnackBarTop(title: 'Oops!', message: 'Your Let\'s Bee Account doesn\'t exist.');
              // changeIndex(1);
            }
          }

          isLoading(false);
        }).catchError((onError) {
          alertSnackBarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
          isLoading(false);
        });

      } else {
        errorSnackbarTop(title: 'Oops!', message: 'Your email address is invalid');
        isLoading(false);
      }
    }
  }

  void register() {
    isLoading(true);
    dismissKeyboard(Get.context);

    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      isLoading(false);
      errorSnackbarTop(title: 'Oops!', message: 'Please input your required field(s)');

    } else {
      
      if(GetUtils.isEmail(emailController.text)) {

        if (confirmPasswordController.text == passwordController.text) {
          _apiService.customerSignUp(name: nameController.text, email: emailController.text, password: passwordController.text).then((response) {
            if (response.status == 200) {

              reset();
              changeIndex(2);

              isLoading(false);
            }
          }).catchError((onError) {
            alertSnackBarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
            isLoading(false);
          });
        } else {
          isLoading(false);
          errorSnackbarTop(title: 'Oops!', message: 'Your confirm password is incorrect.');
        }

      } else {
        errorSnackbarTop(title: 'Oops!', message: 'Your email address is invalid.');
        isLoading(false);
      }
    }
  }

  void goToVerifyNumber() {
     successSnackBarTop(title: 'Yay!', message: 'Registered successfully! Please sign in your account.');
     changeIndex(0);
    // _box.write(Config.SOCIAL_LOGIN_TYPE, Config.EMAIL);
    // _box.write(Config.IS_LOGGED_IN, true);
    // Get.offAllNamed(Config.VERIFY_NUMBER_ROUTE);
  }

  void changeIndex(int index) {
    dismissKeyboard(Get.context);
    selectedIndex(index);
    tabController.index = selectedIndex.call();
    update();
  }

  void reset() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    signInEmailController.clear();
    signInPasswordController.clear();
  }

  void confirm() {
    print('Email: ${emailController.text}');
    print('Code: ${codeController.text}');
  }

  Future<bool> willPopCallback() async {
    dismissKeyboard(Get.context);
    if (selectedIndex.call() == 0) {
      Get.back(closeOverlays: true);
      return true;
    } else {
      selectedIndex.call() == 2 ? changeIndex(1) : changeIndex(0);
      // if (selectedIndex.call() == 2) {
      //   changeIndex(1);
      // } else {
      //   changeIndex(0);
      // }
      return false;
    }
  }
}