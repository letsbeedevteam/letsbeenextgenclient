import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/screens/verify_number/controller/verify_number_controller.dart';

class ContactNumberPage extends StatelessWidget {

  final VerifyNumberController _ = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetX<VerifyNumberController>(
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
                    child: Image.asset(Config.PNG_PATH + 'frame_number.png'),
                  ),
                ),
              ),
              Center(child: Text('Please verify your contact number.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              SizedBox(
                width: Get.width * 0.70,
                height: 40,
                child: TextField(
                  controller: _.numberController,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.number, 
                  maxLength: 10,
                  cursorColor: Colors.black,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'(^\-?\d*\.?\d*)'))
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: Padding(padding: EdgeInsets.only(left: 10, right: 5), child: Text(' +63', style: TextStyle(color: Colors.black, fontSize: 18))),
                    prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    // prefixStyle: TextStyle(color: Colors.black, fontSize: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintText: '(Ex: 9061234567)',
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    counterText: "",
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)
                  ),
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
                  width: 280,
                  child: RaisedButton(
                    color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(13),
                      child: _.isLoading.call() ? 
                      Container(height: 10, width: 10, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black))) : Text('SEND CONFIRMATION CODE', style: TextStyle(fontSize: 15)),
                    ),
                    onPressed: () {
                      if (_.numberController.text.isEmpty) {
                        errorSnackBarBottom(title: 'Required', message: 'Please input your mobile number');
                      } else {
                        dismissKeyboard(context);
                        _.sendCode();
                      }
                    },
                  ),
                  // width: Get.width * 0.80,
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