import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  void changeIndex(int index) {
    selectedIndex.value = index;
    tabController.index = selectedIndex.value;
    update();
  }

  void goToDashboardPage() {

    _box.write(Config.IS_SETUP_LOCATION, true);
    _box.write(Config.USER_MOBILE_NUMBER, numberController.text);
    Get.offAllNamed(Config.DASHBOARD_ROUTE);
  }
}