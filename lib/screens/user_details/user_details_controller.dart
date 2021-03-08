import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/signInResponse.dart';
import 'package:letsbeeclient/models/signup_request.dart';
import 'package:letsbeeclient/models/social_signup_request.dart';
import 'package:letsbeeclient/screens/auth/signUp/controller/signup_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';

class UserDetailsController extends GetxController {

  final ApiService _apiService = Get.find();

  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final argument = Get.arguments;

  final nameFN = FocusNode();
  final numberFN = FocusNode();

  var isLoading = false.obs;

  var data = SignInData().obs;

  @override
  void onInit() {
    if (argument != null) {
      data(SignInData.fromJson(argument));
    }
    super.onInit();
  }

  @override
  void onClose() {
    data.nil();
    super.onClose();
  }

  void goBackToSignIn() => Get.offAllNamed(Config.AUTH_ROUTE);

  void sendCode() {
    isLoading(true);
    
    if (argument != null) {
      socialSignUp();
    } else {
      signUp();
    }
  }

  void socialSignUp() {
    final request = SocialSignUpRequest(
      token: data.call().token,
      name: nameController.text,
      cellphoneNumber: '0${numberController.text}'
    );

    _apiService.customerSocialSignUp(socialSignUp: request).then((response) {
      if (response.status == 200) {
        final data = SignInData(
          token: response.data.token,
          cellphoneNumber: '0${numberController.text}'
        );
        Get.toNamed(Config.VERIFY_NUMBER_ROUTE, arguments: data.toJson());
        dismissKeyboard(Get.context);
      } else {
        alertSnackBarTop(title: Config.oops, message: Config.somethingWentWrong);
      }
      isLoading(false);
    }).catchError((onError) {
      alertSnackBarTop(title: Config.oops, message: Config.somethingWentWrong);
      isLoading(false);
    });
  }

  void signUp() {

    final request = SignUpRequest(
      name: nameController.text,
      email: SignUpController.to.signUpEmail.call(),
      password: SignUpController.to.signUpPassword.call(),
      confirmPassword: SignUpController.to.signUpPassword.call(),
      cellphoneNumber: '0${numberController.text}'
    );

    _apiService.customerSignUp(signUp: request).then((response) {
      if (response.status == 200) {
        final data = SignInData(
          token: response.data.token,
          cellphoneNumber: '0${numberController.text}'
        );
        Get.toNamed(Config.VERIFY_NUMBER_ROUTE, arguments: data.toJson());
        dismissKeyboard(Get.context);
      } else {
        alertSnackBarTop(title: Config.oops, message: Config.somethingWentWrong);
      }
      isLoading(false);
    }).catchError((onError) {
      alertSnackBarTop(title: Config.oops, message: Config.somethingWentWrong);
      isLoading(false);
    });
  }
}