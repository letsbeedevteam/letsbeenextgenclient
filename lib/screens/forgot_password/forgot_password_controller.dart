import 'dart:async';

import 'package:code_field/code_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/request_forgot_pass_response.dart';
import 'package:letsbeeclient/models/signin_response.dart';
import 'package:letsbeeclient/services/api_service.dart';

class ForgotPasswordController extends GetxController {

  ApiService _apiService = Get.find();

  final codeControl = InputCodeControl(inputRegex: r'(^\-?\d*\.?\d*)');

  final numberController = TextEditingController();
  final numberFN = FocusNode();

  var isLoading = false.obs;
  var isSentCode = false.obs;
  var isResendCodeLoading = false.obs;
  var token = ''.obs;
  var code = ''.obs;

  StreamSubscription<RequestForgotPassResponse> forogtSub;
  StreamSubscription<SignInResponse> resendOtpSub;

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

  @override
  void onClose() {
    forogtSub?.cancel();
    resendOtpSub?.cancel();
    super.onClose();
  }

  void sendCode({String type}) {
    type == 'resend_code' ? isResendCodeLoading(true) : isLoading(true);
    dismissKeyboard(Get.context);
    if (numberController.text.isEmpty) {
      errorSnackbarTop(title: tr('oops'), message: tr('enterYourNumber'));
      type == 'resend_code' ? isResendCodeLoading(false) : isLoading(false);
    } else {

      if(numberController.text.length == 10) {

        forogtSub = _apiService.customerRequestForgotPassword(contactNumber: '0${numberController.text}').asStream().listen((response) {

          if (response.status == Config.OK) {
            token(response.data.token);
            code(response.message);
            if (type == 'resend_code') {
              Future.delayed(Duration(seconds: 30)).then((data) => isResendCodeLoading(false));
              successSnackBarTop(message: tr('resendCodeSuccess'));
            }
            isSentCode(true);
          } else {
            errorSnackbarTop(title: tr('oops'), message: tr('somethingWentWrong'));
          }

          isLoading(false);

        })..onError((onError) {
            print(onError.toString());
            type == 'resend_code' ? isResendCodeLoading(false) : isLoading(false);
            errorSnackbarTop(title: tr('oops'), message: tr('somethingWentWrong'));
        });

      } else {
        type == 'resend_code' ? isResendCodeLoading(false) : isLoading(false);
        errorSnackbarTop(title: tr('oops'), message: tr('invalidNumber'));
      }
    }
  }

  void resendOtp() {

    print(token.call());
    isResendCodeLoading(true);
    resendOtpSub = _apiService.resendOtp(token: token.call()).asStream().listen((response) {

      if (response.status == Config.OK) {
        token(response.data.token);
        Future.delayed(Duration(seconds: 60)).then((data) => isResendCodeLoading(false));
        successSnackBarTop(message: tr('resendCodeSuccess'));

      } else {
        isResendCodeLoading(false);
        errorSnackbarTop(title: tr('oops'), message: tr('somethingWentWrong'));
      }

    })..onError((onError) {
      isResendCodeLoading(false);
      errorSnackbarTop(title: tr('oops'), message: tr('somethingWentWrong'));
    });
  }

  void goToChangePassword() {

    if (codeControl.isFilled) {

      if (code.call() == codeControl.value) {

        Get.toNamed(Config.CHANGE_PASS_ROUTE, arguments: {
          'token': token.call(),
          'code': codeControl.value,
        }).whenComplete(() => reset());

      } else {
        errorSnackbarTop(title: tr('oops'), message: tr('invalidCode'));
      }

    } else {
      errorSnackbarTop(title: tr('oops'), message: tr('invalidCode'));
    }
  }

  void reset() {
    token.nil();
    codeControl.clear();
    numberController.clear();
    isSentCode(false);
  }
}