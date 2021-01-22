import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/screens/continue_with_email/controller/signup_controller.dart';

class SignUpConfirmationPage extends GetView<SignUpController> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (controller) {
        return SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Center(
                    child: SizedBox(
                      height: 180,
                      width: 180,
                      child: Image.asset(Config.PNG_PATH + 'frame_email_sent.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('We send your confirmation code to your email.', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Please check your email address', style: TextStyle(fontSize: 15)),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 30,),
                    child: Column(
                      children: [
                        Text('Enter your confirmation code here:', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Container(
                          child: SizedBox(
                            width: 200,
                            height: 40,
                            child: TextFormField(
                              controller: controller.codeController,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                              keyboardType: TextInputType.number, 
                              textInputAction: TextInputAction.done,
                              enableSuggestions: false,
                              autocorrect: false,
                              obscureText: false,
                              cursorColor: Colors.black,
                              maxLength: 4,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'(^\-?\d*\.?\d*)'))
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                hintText: 'Code',
                                counterText: '',
                                contentPadding: EdgeInsets.symmetric(horizontal: 15)
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        Container(
                          width: 200,
                          height: 40,
                          child: RaisedButton(
                            color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(13),
                              child: Text('CONFIRM'),
                            ),
                            onPressed: () {
                              // _.validation(currentIndex: 1);
                              dismissKeyboard(context);
                              Future.delayed(Duration(seconds: 1)).then((value) => controller.goToVerifyNumber());
                            },
                          )
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5,
                                offset: Offset(0,2)
                              )
                            ]
                          ),
                          child: SizedBox(
                            height: 40,
                            child: RaisedButton(
                              color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(13),
                                child: Text('RESEND CONFIRMATION CODE'),
                              ),
                              onPressed: () {
                                dismissKeyboard(context);
                                print('Resend confirmation code');
                              },
                            ),
                            // width: Get.width * 0.80,
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '*After 1 minute if you don\'t receive your code, you can resend it again by resending the confirmation code*', 
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}