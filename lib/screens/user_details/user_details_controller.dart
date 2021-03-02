import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/signInResponse.dart';
import 'package:letsbeeclient/services/api_service.dart';

class UserDetailsController extends GetxController {

  final ApiService _apiService = Get.find();

  final nameController = TextEditingController();
  final numberController = TextEditingController();

  final nameFN = FocusNode();
  final numberFN = FocusNode();

  var isLoading = false.obs;
  var signInData = SignInData().obs;

  @override
  void onInit() {
    signInData(SignInData.fromJson(Get.arguments));

    nameController.text = 'None';
    numberController.text = signInData.call().cellphoneNumber;
    super.onInit();
  }

  void goBackToSignIn() => Get.offAllNamed(Config.AUTH_ROUTE);

  void sendCode() {
    isLoading(true);

    if (signInData.call().cellphoneNumber != null) {
      Get.toNamed(Config.VERIFY_NUMBER_ROUTE, arguments: signInData.call().toJson());
    } else {

      _apiService.updateCellphoneNumber(token: signInData.call().token, number: '+63${numberController.text}').then((response) {
        if (response.status == 200) {
          Get.toNamed(Config.VERIFY_NUMBER_ROUTE, arguments: response.data.toJson());
        } else {

          if (response.code == 2018) {
            errorSnackBarBottom(title: 'Oops!', message: 'Cellphone number is already in use');
          } else if (response.code == 2012) {
            errorSnackBarBottom(title: 'Oops!', message: 'User not found');
          } else {
            errorSnackBarBottom(title: 'Oops!', message: 'Invalid contact number');
          }
        }

        isLoading(false);

      }).catchError((onError) {
        isLoading(false);
        print(onError);
        errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
      });
    }
  }
}