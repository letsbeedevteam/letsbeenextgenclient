import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/screens/signup/controller/signup_controller.dart';
import 'package:letsbeeclient/screens/signup/signup_confirmation_view.dart';
import 'package:letsbeeclient/screens/signup/signup_email_view.dart';

class SignUpPage extends GetView<SignUpController>  {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => _willPopCallback()),
            actions: [
              GetBuilder<SignUpController>(
                builder: (_) {
                  return _.tabController.index == 0 ? FlatButton(
                    child: Text('Next', style: TextStyle(fontSize: 18)), color: Colors.white, highlightColor: Colors.transparent,
                    onPressed: () {
                      dismissKeyboard(context);
                      // _.validation(currentIndex: 0);
                      _.changeIndex(1);
                    }, 
                  ) : Container();
                },
              )
            ],
          ),
          body: GetBuilder<SignUpController>(
            builder: (_) {
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _.tabController,
                children: [
                  SignUpEmailPage(),
                  SignUpConfirmationPage()
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
    if (controller.selectedIndex.value == 0) {
      Get.back(closeOverlays: true);
      return true;
    } else {
      controller.changeIndex(0);
      return false;
    }
  }
}