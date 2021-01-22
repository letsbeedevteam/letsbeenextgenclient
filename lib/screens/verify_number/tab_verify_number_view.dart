import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/screens/verify_number/controller/verify_number_controller.dart';
import 'package:letsbeeclient/screens/verify_number/confirm_code_view.dart';
import 'package:letsbeeclient/screens/verify_number/contact_number_view.dart';
import 'dart:math' as math;

class VerifyNumberPage extends GetView<VerifyNumberController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GestureDetector(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: GetX<VerifyNumberController>(
              builder: (_) {
                return _.selectedIndex.call() == 0 ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: IconButton(icon: Icon(Icons.logout), onPressed: () => _willPopCallback()),
                ) : IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => _willPopCallback());
              },
            ),
          ),
          body: GetBuilder<VerifyNumberController>(
            builder: (_) {
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _.tabController,
                children: [
                  ContactNumberPage(),
                  ConfirmCodePage()
                ]
              );
            },
          )
        ),
        onTap: () => dismissKeyboard(context),
      ),
      onWillPop: _willPopCallback,
    );
  }

  Future<bool> _willPopCallback() async {
    dismissKeyboard(Get.context);
    if (controller.selectedIndex.call() == 0) {
      controller.logout();
      return true;
    } else {
      controller.changeIndex(0);
      return false;
    }
  }
}