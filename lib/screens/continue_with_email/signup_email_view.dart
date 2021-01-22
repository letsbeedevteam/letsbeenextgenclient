import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/continue_with_email/controller/signup_controller.dart';

class SignUpEmailPage extends StatelessWidget {

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
                      height: 150,
                      width: 150,
                      child: Image.asset(Config.PNG_PATH + 'sign_up.png'),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Center(child: Text('Register your email as an account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Container(
                      padding: EdgeInsets.only(left: 30, right: 30, top: 10),
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
                              SizedBox(
                                height: 40,
                                child: TextFormField(
                                  controller: _.emailController,
                                  focusNode: _.emailFN,
                                  onEditingComplete: () => _.nameFN.requestFocus(),
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
                                child: Text('Name:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                              SizedBox(
                                height: 40,
                                child: TextFormField(
                                  controller: _.nameController,
                                  focusNode: _.nameFN,
                                  onEditingComplete: () => _.passwordFN.requestFocus(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 18),
                                  keyboardType: TextInputType.text, 
                                  textInputAction: TextInputAction.next,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  obscureText: false,
                                  cursorColor: Colors.black,
                                  // inputFormatters: [
                                  //   FilteringTextInputFormatter.allow(RegExp("[a-z \s]"))
                                  // ],
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
                              SizedBox(
                                height: 40,
                                child: TextFormField(
                                  controller: _.passwordController,
                                  focusNode: _.passwordFN,
                                  onEditingComplete: () => _.signUpConfirmPasswordFN.requestFocus(),
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
                            ],
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text('Confirm Password:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                              SizedBox(
                                height: 40,
                                child: TextFormField(
                                  controller: _.confirmPasswordController,
                                  focusNode: _.signUpConfirmPasswordFN,
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
                            ],
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          SizedBox(
                            width: Get.width,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                              child: _.isLoading.call() ? 
                               Container(height: 10, width: 10, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black)))
                              : Text('Register', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              onPressed: () {
                                if(!_.isLoading.call()) _.register();
                              },
                            ),
                          )
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