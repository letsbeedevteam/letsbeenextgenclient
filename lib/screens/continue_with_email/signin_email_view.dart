import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/continue_with_email/controller/signup_controller.dart';

class SignInEmailPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetX<SignUpController>(
      builder: (_) {
        return SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Center(
                    child: SizedBox(
                      height: 180,
                      width: 180,
                      child: Image.asset(Config.PNG_PATH + 'frame_email.png'),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('What\'s your email?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20),
                    //   child: Text('We\'ll check if you have an account', style: TextStyle(fontSize: 15)),
                    // ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Container(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text('Email:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                              IgnorePointer(
                                ignoring: _.isLoading.call(),
                                child: SizedBox(
                                  height: 40,
                                  child: TextFormField(
                                    controller: _.signInEmailController,
                                    focusNode: _.signInEmailFN,
                                    onEditingComplete: () {
                                      _.signInPasswordController.selection = TextSelection.fromPosition(TextPosition(offset: _.signInPasswordController.text.length));
                                      _.signInPasswordFN.requestFocus();
                                    },
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 18),
                                    keyboardType: TextInputType.emailAddress, 
                                    textInputAction: TextInputAction.next,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    obscureText: false,
                                    cursorColor: Colors.black,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp("[ ]"))
                                    ],
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade200,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: Colors.black)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      contentPadding: EdgeInsets.only(left: 15)
                                    )
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text('Password:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                              IgnorePointer(
                                ignoring: _.isLoading.call(),
                                child: SizedBox(
                                  height: 40,
                                  child: TextFormField(
                                    controller: _.signInPasswordController,
                                    focusNode: _.signInPasswordFN,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 18),
                                    keyboardType: TextInputType.text, 
                                    textInputAction: TextInputAction.done,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    obscureText: true,
                                    cursorColor: Colors.black,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp('[ ]'))
                                    ],
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade200,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: Colors.black)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      contentPadding: EdgeInsets.only(left: 15)
                                    ), 
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 3),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Forgot Password?', style: TextStyle(fontSize: 14)),
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                                  Text('Click', style: TextStyle(fontSize: 14)),
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                                  GestureDetector(onTap: () => print('Forgot password'), child: Text('Here', style: TextStyle(color: Colors.blue, fontSize: 14)))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15, bottom: 10),
                            child: SizedBox(
                              width: 150,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                                child: _.isLoading.call() ? 
                               Container(height: 10, width: 10, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black))) : Text('LOGIN'),
                                onPressed: () => _.isLoading.call() ? null : _.signIn()
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('No account yet?', style: TextStyle(fontSize: 14)),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                              GestureDetector(onTap: () => _.changeIndex(1), child: Text('Register', style: TextStyle(color: Colors.blue, fontSize: 14))),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                              Text('here', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          // _.isLoading.call() ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black))) : Container(),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}