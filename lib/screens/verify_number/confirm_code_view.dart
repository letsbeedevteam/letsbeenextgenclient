import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/controllers/verify_number/verify_number_controller.dart';

class ConfirmCodePage extends StatelessWidget {

  final VerifyNumberController _ = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyNumberController>(
      builder: (controller) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                    contentPadding: EdgeInsets.all(0)
                  ),
                  maxLength: 5,
                  cursorColor: Colors.black,
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
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
                      child: Text('CONFIRM'),
                    ),
                    onPressed: () {
                      // if (_.codeController.text.isEmpty) {
                      //   customSnackbar(title: 'Required', message: 'Please input your code');
                      // } else {
                      //   dismissKeyboard(context);
                      //   _.goToDashboardPage();
                      // }
                      dismissKeyboard(context);
                       _.goToDashboardPage();
                    },
                  ),
                  width: Get.width * 0.80,
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
                  width: Get.width * 0.80,
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 30)),
            ],
          ),
        );
      },
    );
  }
}