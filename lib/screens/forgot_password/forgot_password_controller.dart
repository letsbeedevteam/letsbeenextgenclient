import 'package:code_field/code_field.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/services/api_service.dart';

class ForgotPasswordController extends GetxController {

  ApiService _apiService = Get.find();

  final codeControl = InputCodeControl(inputRegex: r'(^\-?\d*\.?\d*)');

  final numberController = TextEditingController();
  final numberFN = FocusNode();

  var isLoading = false.obs;
  var isSentCode = false.obs;
  var isShowResendCode = false.obs;
  var token = ''.obs;
  var code = ''.obs;


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
    isLoading(true);
    dismissKeyboard(Get.context);
    if (numberController.text.isEmpty) {
      errorSnackbarTop(title: Config.oops, message: Config.enterYourNumber);
      isLoading(false);
    } else {

      if(numberController.text.length == 10) {
        _apiService.customerRequestForgotPassword(contactNumber: '0${numberController.text}').then((response) {
          
          if (response.status == 200) {
            token(response.data.token);
            code(response.message);
            if (Get.currentRoute == Config.FORGOT_PASS_ROUTE) Future.delayed(Duration(seconds: 5)).then((data) => isShowResendCode(true));
            isSentCode(true);
          } else {
            errorSnackbarTop(title: Config.oops, message: Config.somethingWentWrong);
          }

          isLoading(false);
        }).catchError((onError) {
          print(onError.toString());
          isLoading(false);
          errorSnackbarTop(title: Config.oops, message: Config.somethingWentWrong);
        });

      } else {
        isLoading(false);
        errorSnackbarTop(title: Config.oops, message: Config.invalidNumber);
      }
    }
  }

  void goToChangePassword() {

    if (codeControl.isFilled) {

      if (code.call() == codeControl.value) {

        Get.toNamed(Config.CHANGE_PASS_ROUTE, arguments: {
          'token': token.call(),
          'code': codeControl.value,
        }).whenComplete(() => reset());

      } else {
        errorSnackbarTop(title: Config.oops, message: Config.invalidCode);
      }

    } else {
      errorSnackbarTop(title: Config.oops, message: Config.invalidCode);
    }
  }

  void reset() {
    token.nil();
    codeControl.clear();
    numberController.clear();
    isShowResendCode(false);
    isSentCode(false);
  }
}