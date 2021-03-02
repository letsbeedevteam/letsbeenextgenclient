import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/signInResponse.dart';
import 'package:letsbeeclient/models/signup_request.dart';
import 'package:letsbeeclient/screens/auth/signUp/controller/signup_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';

class UserDetailsController extends GetxController {

  final ApiService _apiService = Get.find();

  final nameController = TextEditingController();
  final numberController = TextEditingController();

  final nameFN = FocusNode();
  final numberFN = FocusNode();

  var isLoading = false.obs;

  @override
  void onInit() {
    print(SignUpController.to.signUpEmail.call());
    print(SignUpController.to.signUpPassword.call());
    super.onInit();
  }

  void goBackToSignIn() => Get.offAllNamed(Config.AUTH_ROUTE);

  void sendCode() {
    isLoading(true);

    final request = SignUpRequest(
      name: nameController.text,
      email: SignUpController.to.signUpEmail.call(),
      password: SignUpController.to.signUpPassword.call(),
      confirmPassword: SignUpController.to.signUpPassword.call(),
      cellphoneNumber: '0${numberController.text}'
    );

    _apiService.customerSignUp(signUpRequest: request).then((response) {
      if (response.status == 200) {
        final data = SignInData(
          token: response.data.token,
          cellphoneNumber: '0${numberController.text}'
        );
        Get.toNamed(Config.VERIFY_NUMBER_ROUTE, arguments: data.toJson());
        dismissKeyboard(Get.context);
      } else {
        alertSnackBarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
      }
      isLoading(false);
    }).catchError((onError) {
      alertSnackBarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
      isLoading(false);
    });
  }
}