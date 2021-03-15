import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/edit_profile_request.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';
import 'package:easy_localization/easy_localization.dart';

class AccountInfoController extends GetxController {

  var isLoading = false.obs;

  final GetStorage _box = Get.find();
  final ApiService _apiService = Get.find();
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();

  final nameFN = FocusNode();
  final emailFN = FocusNode();
  final numberFN = FocusNode();

  @override
  void onInit() {
        
    nameController.text = _box.read(Config.USER_NAME);
    emailController.text = _box.read(Config.USER_EMAIL);
    numberController.text = _box.read(Config.USER_MOBILE_NUMBER).replaceFirst(RegExp(r'^0+'), "");

    super.onInit();
  }

  void goToChangePassword() => Get.toNamed(Config.CHANGE_PASS_ROUTE);


  void saveAccountInfo() {
    isLoading(true);
    dismissKeyboard(Get.context);
    if (nameController.text.isBlank || emailController.text.isBlank || numberController.text.isBlank) {

      isLoading(false);
      alertSnackBarTop(title: tr('oops'), message: tr('inputFields'));

    } else {

      if (GetUtils.isEmail(emailController.text)) {

        final editProfileRequest = EditProfileRequest(
          name: nameController.text,
          email: emailController.text,
          number: '0${numberController.text}'
        );

        _apiService.customerEditProfile(request: editProfileRequest).then((response) {
          
          if (response.status == 200) {
            
            successSnackBarTop(title: tr('yay'), message: tr('accountInfoUpdated'));
            _box.write(Config.USER_NAME, response.data.name);
            _box.write(Config.USER_EMAIL, response.data.email);
            _box.write(Config.USER_MOBILE_NUMBER, response.data.cellphoneNumber);
            DashboardController.to.update();
            
          } else {

            if (response.code == 2018) {
              errorSnackbarTop(title: tr('oops'), message: response.message);
            } else {
              errorSnackbarTop(title: tr('oops'), message: response.message);
            }
          }

          isLoading(false);
        }).catchError((onError) {
          errorSnackbarTop(title: tr('oops'), message: tr('somethingWentWrong'));
          isLoading(false);
        });

      } else {
        
        isLoading(false);
        errorSnackbarTop(title: tr('oops'), message: tr('emailInvalid')); 
      }
    }
  }
}