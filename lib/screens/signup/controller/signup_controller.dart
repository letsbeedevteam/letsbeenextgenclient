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

  final signUpEmailFN = FocusNode();
  final signUpPasswordFN = FocusNode();

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final codeController = TextEditingController();

  final emailFN = FocusNode();
  final nameFN = FocusNode();
  final passwordFN = FocusNode();

  TabController tabController;

  var selectedIndex = 0.obs;
  var isLoading = false.obs;

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
            changeIndex(2);
          } else {

            if (response.code == 2000) {
              alertSnackBarTop(title: 'Oops!', message: 'Your password is invalid.');
            } else {
              alertSnackBarTop(title: 'Oops!', message: 'You don\'t have an account, Please create a new one.');
              changeIndex(1);
            }
          }

          isLoading(false);

        }).catchError((onError) {
          isLoading(false);
          print('Sign in error: $onError');
        });
      } else {
        errorSnackbarTop(title: 'Oops!', message: 'Your email address is invalid');
        isLoading(false);
      }
    }
  }

  void signUp() {
    isLoading(true);
    dismissKeyboard(Get.context);

    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      isLoading(false);
      errorSnackbarTop(title: 'Oops!', message: 'Please input your required field(s)');

    } else {
      
      if(GetUtils.isEmail(emailController.text)) {
        _apiService.customerSignUp(name: nameController.text, email: emailController.text, password: passwordController.text).then((response) {
        
          if (response.status == 200) {
            successSnackBarTop(title: 'Registered SuccessFully', message: 'Please sign in with your email');
            changeIndex(0);
            nameController.clear();
            emailController.clear();
            passwordController.clear();

            signInEmailController.clear();
            signInPasswordController.clear();

            isLoading(false);
          }

        }).catchError((onError) {
          isLoading(false);
          print('Sign up error: $onError');
        });
      } else {
        errorSnackbarTop(title: 'Oops!', message: 'Your email address is invalid.');
        isLoading(false);
      }
    }
  }

  void goToSetupLocation() {
    _box.write(Config.SOCIAL_LOGIN_TYPE, Config.EMAIL);
    _box.write(Config.IS_LOGGED_IN, true);
    Get.offAllNamed(Config.SETUP_LOCATION_ROUTE);
  }

  void changeIndex(int index) {
    selectedIndex(index);
    tabController.index = selectedIndex.call();
    update();
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
      changeIndex(0);
      return false;
    }
  }
}