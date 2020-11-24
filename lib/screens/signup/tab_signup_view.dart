import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/controllers/signup/signup_controller.dart';
import 'package:letsbeeclient/screens/signup/signup_confirmation_view.dart';
import 'package:letsbeeclient/screens/signup/signup_email_view.dart';

class SignUpPage extends StatelessWidget  {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GetBuilder<SignUpController>(builder: (_) => IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () {
            dismissKeyboard(context);
            if (_.selectedIndex.value == 0) {
              Get.back(closeOverlays: true);
            } else {
              _.changeIndex(0);
            }
          })),
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
    );
  }
}