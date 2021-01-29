import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/services/api_service.dart';

class VerifyNumberController extends GetxController with SingleGetTickerProviderMixin {

  final ApiService _apiService = Get.find();
  final GetStorage _box = Get.find();

  TabController tabController;

  var selectedIndex = 0.obs;
  var isLoading = false.obs;

  var numberController = TextEditingController();
  var codeController = TextEditingController();

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  getUserNumber() => numberController.text;

  void changeIndex(int index) {
    selectedIndex(index);
    tabController.index = selectedIndex.call();
    update();
  }

  void sendCode() {
    isLoading(true);
    _apiService.addCellphoneNumber(number: '+63${numberController.text}').then((response) {
      if (response.status == 200) {
        changeIndex(1);
      } else {
        errorSnackBarBottom(title: 'Oops!', message: 'Invalid contact number');
      }

      isLoading(false);

    }).catchError((onError) {
      isLoading(false);
      errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
    });
    // changeIndex(1);
  }

  void goToSetupLocation() {
    _box.write(Config.IS_VERIFY_NUMBER, true);
    _box.write(Config.USER_MOBILE_NUMBER, numberController.text);
    Get.offAllNamed(Config.SETUP_LOCATION_ROUTE);
  }

  void logout() {
    _box.write(Config.IS_LOGGED_IN, false);
    Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
  }
}