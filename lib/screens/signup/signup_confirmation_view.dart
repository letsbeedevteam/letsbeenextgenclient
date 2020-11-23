import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/controllers/signup/signup_controller.dart';

class SignUpConfirmationPage extends StatelessWidget {

  final SignUpController _ = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (controller) {
        return Center(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('We send your confirmation code to your email.', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Please check your email address', style: TextStyle(fontSize: 18)),
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
                                controller: _.codeController,
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
                                  // filled: true,
                                  // fillColor: Color(Config.LETSBEE_COLOR).withOpacity(0.5),
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
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
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
                                _.goToSetupLocation();
                              },
                            )
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}