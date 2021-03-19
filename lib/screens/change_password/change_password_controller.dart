
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/change_pass_request.dart';
import 'package:letsbeeclient/models/forgot_password_request.dart';
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
    argument != null ? isForgotPas(true) : isForgotPas(false);
    super.onInit();
  }

  void forgotPassword() {
    isLoading(true);
    dismissKeyboard(Get.context);

    if ( newPassController.text.isBlank || repeatPassController.text.isBlank) {
      alertSnackBarTop(title: tr('oops'), message: tr('inputFields'));
      isLoading(false);
    } else {

      if (newPassController.text == repeatPassController.text) {
        
      final request = ForgotPasswordRequest(
        token: argument['token'],
        code: argument['code'],
        newPassword: newPassController.text
      );

      _apiService.customerForgotPassword(request: request).then((response) {
      
        if (response.status == Config.OK) {
          _sucessPopUp();
        } else {
          errorSnackbarTop(title: tr('oops'), message: tr('somethingWentWrong'));
        }

        isLoading(false);
        
      }).catchError((onError) {
        isLoading(false);
        print('Forgot pass error: $onError');
        errorSnackbarTop(title: tr('oops'), message: tr('somethingWentWrong'));
      });

      } else {
      
        errorSnackbarTop(title: tr('oops'), message: tr('incorrectRepeatPassword'));
        repeatPassController.selection = TextSelection.fromPosition(TextPosition(offset: repeatPassController.text.length));
        repeatPassFn.requestFocus();
        isLoading(false);
      }

    }
  }

  void changePassword() {
    isLoading(true);
    dismissKeyboard(Get.context);
    if (oldPassController.text.isBlank || newPassController.text.isBlank || repeatPassController.text.isBlank) {

      alertSnackBarTop(title: tr('oops'), message: tr('inputFields'));
      isLoading(false);

    } else {

      if (newPassController.text == repeatPassController.text) {
        
        final request = ChangePasswordRequest(
          oldPassword: oldPassController.text,
          newPassword: newPassController.text,
          confirmPassword: repeatPassController.text
        );

        _apiService.customerChangePassword(request: request).then((response) {
          
          if (response.status == Config.OK) {
            successSnackBarTop(message: tr('updatedSuccessfully'));
            oldPassController.clear();
            newPassController.clear();
            repeatPassController.clear();
          } else {
            errorSnackbarTop(title: tr('oops'), message: response.message);
          }

          isLoading(false);
          
        }).catchError((onError) {
          isLoading(false);
          print('Change pass error: $onError');
          errorSnackbarTop(title: tr('oops'), message: tr('somethingWentWrong'));
        });


      } else {
        errorSnackbarTop(title: tr('oops'), message: tr('incorrectRepeatPassword'));
        isLoading(false);
      }
    }
  }

  _sucessPopUp() {
    Get.dialog(
      AlertDialog(
        content: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Config.PNG_PATH + 'verified.png'),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Text(tr('changePasswordSuccess'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.center),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              RaisedButton(
                onPressed: () => Get.offAllNamed(Config.AUTH_ROUTE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20) 
                ),
                color: Color(Config.LETSBEE_COLOR),
                child: Text(tr('dismiss'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
              )
            ]
          )
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
        )
      ),
      barrierDismissible: false
    );
  }
}