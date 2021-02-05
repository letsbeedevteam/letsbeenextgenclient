import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/screens/verify_number/controller/verify_number_controller.dart';

class ConfirmCodePage extends StatelessWidget {

  final VerifyNumberController _ = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyNumberController>(
      builder: (controller) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Center(
                  child: SizedBox(
                    height: 180,
                    width: 180,
                    child: Image.asset(Config.PNG_PATH + 'frame_number_sent.png'),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Center(
                  child: Text('We send confirmation code to this number: +63${controller.numberController.text}.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))
                )
              ),
              // Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Center(child: Text('Please enter your confirmation code.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              SizedBox(
                width: Get.width * 0.50,
                height: 40,
                child: TextField(
                  controller: _.codeController,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'(^\-?\d*\.?\d*)'))
                  ],
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black)
                    ),
                    hintText: 'Code',
                    counterText: "",
                    contentPadding: EdgeInsets.all(0),
                    fillColor: Colors.grey.shade200,
                    filled: true
                  ),
                  maxLength: 6,
                  cursorColor: Colors.black,
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 15)),
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
                    color: Color(Config.LETSBEE_COLOR),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(13),
                      child: _.isLoading.call() ? Container(height: 10, width: 10, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black))) : Text('CONFIRM', style: TextStyle(color: Colors.black, fontSize: 15)),
                    ),
                    onPressed: () {
                      // if (_.codeController.text.isEmpty) {
                      //   customSnackbar(title: 'Required', message: 'Please input your code');
                      // } else {
                      //   dismissKeyboard(context);
                      //   _.goToDashboardPage();
                      // }
                      dismissKeyboard(context);
                       _.confirmCode();
                    },
                  ),
                  width: 200,
                ),
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
                    color: Color(Config.LETSBEE_COLOR),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(13),
                      child: Text('RESEND CONFIRMATION CODE', style: TextStyle(color: Colors.black, fontSize: 15)),
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
        );
      },
    );
  }
}