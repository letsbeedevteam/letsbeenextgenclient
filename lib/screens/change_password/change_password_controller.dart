
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/change_pass_request.dart';
import 'package:letsbeeclient/services/api_service.dart';

class ChangePasswordController extends GetxController {

  final ApiService _apiService = Get.find();

  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final repeatPassController = TextEditingController();

  final oldPassFN = FocusNode();
  final newPassFN = FocusNode();
  final repeatPassFn = FocusNode();

  final argument = Get.arguments;

  var isLoading = false.obs;
  var isShowOldPass = false.obs;
  var isShowNewPass = false.obs;
  var isShowRepeatPass = false.obs;

  var isForgotPas = false.obs;

  @override
  void onInit() {
    if (argument != null) {
      if (argument == Config.FORGOT_PASS_ROUTE) isForgotPas(true);
    }
    super.onInit();
  }

  void forgotPassword() {
     isLoading(true);
     dismissKeyboard(Get.context);

      if ( newPassController.text.isBlank || repeatPassController.text.isBlank) {

      } else {

      }
  }

  void changePassword() {
    isLoading(true);
    dismissKeyboard(Get.context);
    if (oldPassController.text.isBlank || newPassController.text.isBlank || repeatPassController.text.isBlank) {

      alertSnackBarTop(title: Config.oops, message: Config.inputFields);
      isLoading(false);

    } else {

      if (newPassController.text == repeatPassController.text) {
        
        final request = ChangePasswordRequest(
          oldPassword: oldPassController.text,
          newPassword: newPassController.text,
          confirmPassword: repeatPassController.text
        );

        _apiService.customerChangePassword(request: request).then((response) {
          
          if (response.status == 200) {
            successSnackBarTop(message: response.message);
            oldPassController.clear();
            newPassController.clear();
            repeatPassController.clear();
          } else {
            errorSnackbarTop(title: Config.oops, message: response.message);
          }

          isLoading(false);
          
        }).catchError((onError) {
          isLoading(false);
          print('Change pass error: $onError');
          errorSnackbarTop(title: Config.oops, message: Config.somethingWentWrong);
        });


      } else {
        errorSnackbarTop(title: Config.oops, message: Config.incorrectRepeatPassword);
        isLoading(false);
      }
    }
  }
}