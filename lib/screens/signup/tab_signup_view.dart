import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/screens/signup/controller/signup_controller.dart';
import 'package:letsbeeclient/screens/signup/signin_email_view.dart';
import 'package:letsbeeclient/screens/signup/signup_confirmation_view.dart';
import 'package:letsbeeclient/screens/signup/signup_email_view.dart';

class SignUpPage extends GetView<SignUpController>  {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (_) {
        return WillPopScope(
          child: GestureDetector(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: _.willPopCallback),
                actions: [
                  _.tabController.index == 0 ? FlatButton(
                    child: Text('Next', style: TextStyle(fontSize: 18)), color: Colors.white, highlightColor: Colors.transparent,
                    onPressed: () => _.signIn() 
                  ) : Container()
                ],
              ),
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _.tabController,
                children: [
                  SignInEmailPage(),
                  SignUpEmailPage(),
                  SignUpConfirmationPage()
                ]
              )
            ),
            onTap: () => dismissKeyboard(context),
          ),
          onWillPop: _.willPopCallback,
        );
      },
    );
  }
}