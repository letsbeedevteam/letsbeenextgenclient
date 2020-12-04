import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';

class SignUpController extends GetxController with SingleGetTickerProviderMixin {

  GetStorage _box = Get.find();

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final codeController = TextEditingController();

  final emailFN = FocusNode();
  final nameFN = FocusNode();
  final passwordFN = FocusNode();

  TabController tabController;

  var selectedIndex = 0.obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  void goToSetupLocation() {
    _box.write(Config.SOCIAL_LOGIN_TYPE, Config.EMAIL);
    _box.write(Config.IS_LOGGED_IN, true);
    _box.write(Config.USER_NAME, nameController.text);
    _box.write(Config.USER_EMAIL, emailController.text);
    _box.write(Config.USER_TOKEN, 'token');
    Get.offAllNamed(Config.SETUP_LOCATION_ROUTE);
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
    tabController.index = selectedIndex.value;
    update();
  }

  void confirm() {
    print('Email: ${emailController.text}');
    print('Code: ${codeController.text}');
  }

  void validation({@required int currentIndex}) {
    if (currentIndex == 0) {

      if (emailController.text.isEmpty || nameController.text.isEmpty || passwordController.text.isEmpty) {
        errorSnackBarBottom(title: 'Required', message: 'Please input your required field(s)');
      } else {
        
        if (GetUtils.isEmail(emailController.text)) {
          changeIndex(1);
        } else {
          errorSnackBarBottom(title: 'Invalid', message: 'Your email is invalid');
        }
      }
      
    } else {
      
      if (codeController.text.isEmpty) {
        errorSnackBarBottom(title: 'Required', message: 'Please input your code');
      } else {
        confirm();
        print('SENT');
      }
    }
  }
}