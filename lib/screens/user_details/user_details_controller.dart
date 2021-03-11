import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/signin_response.dart';
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

    if (nameController.text.isNotEmpty || numberController.text.isNotEmpty) {

      if (numberController.text.length == 10) {

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
            _signedUpPopUp(data);
            dismissKeyboard(Get.context);
          } else {
            alertSnackBarTop(title: tr('oops'), message: tr('somethingWentWrong'));
          }
          isLoading(false);
        }).catchError((onError) {
          alertSnackBarTop(title: tr('oops'), message: tr('somethingWentWrong'));
          isLoading(false);
        });

      } else {
        errorSnackbarTop(title: tr('oops'), message: tr('invalidNumber'));
      }

    } else {
      errorSnackbarTop(title: tr('oops'), message: tr('inputFields'));
    }
  }

  void signUp() {

    if (nameController.text.isNotEmpty || numberController.text.isNotEmpty) {

      if (numberController.text.length == 10) {
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
            _signedUpPopUp(data);
            dismissKeyboard(Get.context);
          } else {
            alertSnackBarTop(title: tr('oops'), message: tr('somethingWentWrong'));
          }
          isLoading(false);
        }).catchError((onError) {
          alertSnackBarTop(title: tr('oops'), message: tr('somethingWentWrong'));
          isLoading(false);
        });

      } else {
        errorSnackbarTop(title: tr('oops'), message: tr('invalidNumber'));
      }
    

    } else {
      errorSnackbarTop(title: tr('oops'), message: tr('inputFields'));
    }
  }

  _signedUpPopUp(SignInData data) {
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
              Text(tr('signedUp'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.center),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              RaisedButton(
                onPressed: () {
                  if (Get.isDialogOpen) Get.back(closeOverlays: true);
                  Get.toNamed(Config.VERIFY_NUMBER_ROUTE, arguments: data.toJson());
                },
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