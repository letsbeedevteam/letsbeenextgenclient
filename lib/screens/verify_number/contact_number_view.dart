import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/controllers/verify_number/verify_number_controller.dart';

class ContactNumberPage extends StatelessWidget {

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
                    prefixIcon: SizedBox(
                      child: Center(
                        widthFactor: 1.2,
                        child: Padding(padding: EdgeInsets.only(left: 20), child: Text('+63', style: TextStyle(fontSize: 18)),),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    counterText: "",
                    contentPadding: EdgeInsets.all(0)
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
                  child: RaisedButton(
                    color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(13),
                      child: Text('SEND CONFIRMATION CODE'),
                    ),
                    onPressed: () {
                      // if (_.numberController.text.isEmpty) {
                      //   customSnackbar(title: 'Required', message: 'Please input your mobile number');
                      // } else {
                      //   dismissKeyboard(context);
                      //   _.changeIndex(1);
                      // }
                      dismissKeyboard(context);
                       _.changeIndex(1);
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