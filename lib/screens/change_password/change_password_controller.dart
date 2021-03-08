
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';

class ChangePasswordController extends GetxController {


  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final repeatPassController = TextEditingController();

  final oldPassFN = FocusNode();
  final newPassFN = FocusNode();
  final repeatPassFn = FocusNode();

  var isLoading = false.obs;
  var isShowOldPass = false.obs;
  var isShowNewPass = false.obs;
  var isShowRepeatPass = false.obs;

  @override
  void onInit() {
    
    super.onInit();
  }

  void changePassword() {
    isLoading(true);
    dismissKeyboard(Get.context);
    if (oldPassController.text.isBlank || newPassController.text.isBlank || repeatPassController.text.isBlank) {

      alertSnackBarTop(title: Config.oops, message: Config.inputFields);
      isLoading(false);

    } else {

      if (newPassController.text == repeatPassController.text) {
        print('change');
      } else {
        print('repeat pass invalid');
      }

      isLoading(false);
    }
  }
}