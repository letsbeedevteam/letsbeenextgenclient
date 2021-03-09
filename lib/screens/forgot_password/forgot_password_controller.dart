import 'package:code_field/code_field.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';

class ForgotPasswordController extends GetxController {

  var isLoading = false.obs;

  final codeControl = InputCodeControl(inputRegex: r'(^\-?\d*\.?\d*)');

  final numberController = TextEditingController();
  // final codeController = TextEditingController();
  // final newPasswordController = TextEditingController();

  final numberFN = FocusNode();
  // final codeFN = FocusNode();
  // final newPasswordFN = FocusNode();

  // var isShowNewPass = false.obs;

  var isSentCode = false.obs;

  @override
  void onInit() {
    numberController.addListener(() {
      if (numberController.text.length != 10) {
        isSentCode(false);
        codeControl.clear();
      }
    });
    super.onInit();
  }

  void sendCode() {

    if (numberController.text.isEmpty) {
      errorSnackbarTop(title: Config.oops, message: Config.enterYourNumber);
    } else {

      if(numberController.text.length == 10) {
        isSentCode(true);
        dismissKeyboard(Get.context);
      } else {
        errorSnackbarTop(title: Config.oops, message: Config.invalidNumber);
      }
    }
  }

  void goToChangePassword() {

    if (codeControl.isFilled) {
      Get.toNamed(Config.CHANGE_PASS_ROUTE, arguments: Config.FORGOT_PASS_ROUTE);
    } else {
      errorSnackbarTop(title: Config.oops, message: Config.invalidCode);
    }
  }
}