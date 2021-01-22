import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart';
import 'package:letsbeeclient/_utils/config.dart';

class VerifyNumberController extends GetxController with SingleGetTickerProviderMixin {

  final GetStorage _box = Get.find();

  TabController tabController;

  var selectedIndex = 0.obs;

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