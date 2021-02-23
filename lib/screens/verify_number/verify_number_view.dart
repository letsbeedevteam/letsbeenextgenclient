import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/screens/verify_number/controller/verify_number_controller.dart';
// import 'dart:math' as math;

class VerifyNumberPage extends GetView<VerifyNumberController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () => Get.back()),
          title: Text('Verification', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text('Enter the code', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Obx(() {
              return Text(
                'Enter the OTP code sent to your number +63${controller.signInData.call().cellphoneNumber.replaceFirst(RegExp(r'^0+'), "")}', 
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,);
            }),
            Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            _getInputField(),
            Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            _footer()
          ]
        )
      ),
      onTap: () => dismissKeyboard(context),
    );
  }

  Widget _footer() {
    return Column(
      children: [
        Text('Didn\'t received any code?', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
        Padding(padding: EdgeInsets.symmetric(vertical: 8)),
        GestureDetector(
          onTap: () => print('Renew code'),
          child: Text('Resend a new code', style: TextStyle(fontSize: 15, color: Color(Config.YELLOW_TEXT_COLOR), fontWeight: FontWeight.w500))
        ),
      ],
    );
  }

  Widget _getInputField() {
    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _otpTextField(controller.firstDigit.call(), controller.first, controller.firstFN, 1),
            _otpTextField(controller.secondDigit.call(), controller.second, controller.secondFN, 2),
            _otpTextField(controller.thirdDigit.call(), controller.third, controller.thirdFN, 3),
            _otpTextField(controller.fourthDigit.call(), controller.fourth, controller.fourthFN, 4),
            _otpTextField(controller.fifthDigit.call(), controller.fifth, controller.fifthFN, 5),
            _otpTextField(controller.sixthDigit.call(), controller.sixth, controller.sixthFN, 6),
          ],
        ),
      );
    });
  }

  Widget _otpTextField(String digit, TextEditingController textController, FocusNode focusNode, int numDigit) {
    return Container(
      width: 50.0,
      height: 45.0,
      alignment: Alignment.center,
      child: Obx(() {
        return TextField(
          enabled: !controller.isLoading.call(),
          controller: textController,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
          onTap: () => textController.clear(),
          onChanged: (value) {
            if (1 == numDigit) {
              textController.value = TextEditingValue(text: value);
              if (value == '') {
                controller.first.selection = TextSelection.fromPosition(TextPosition(offset: controller.first.text.length));
              } else {
                controller.second.clear();
                controller.secondFN.requestFocus();
              }
            
            } else if (2 == numDigit) {

              if (value == '') {
                controller.first.selection = TextSelection.fromPosition(TextPosition(offset: controller.first.text.length));
                controller.firstFN.requestFocus();
              } else {
                controller.third.clear();
                controller.thirdFN.requestFocus();
              } 
            } else if (3 == numDigit) {

              if (value == '') {
                controller.second.selection = TextSelection.fromPosition(TextPosition(offset: controller.second.text.length));
                controller.secondFN.requestFocus();
              } else {
                controller.fourth.clear();
                controller.fourthFN.requestFocus();
              } 
            } else if (4 == numDigit) {

              if (value == '') {
                controller.third.selection = TextSelection.fromPosition(TextPosition(offset: controller.third.text.length));
                controller.thirdFN.requestFocus();
              } else {
                controller.fifth.clear();
                controller.fifthFN.requestFocus();
              }
            } else if (5 == numDigit) {

              if (value == '') {
                controller.fourth.selection = TextSelection.fromPosition(TextPosition(offset: controller.fourth.text.length));
                controller.fourthFN.requestFocus();
              } else {
                controller.sixth.clear();
                controller.sixthFN.requestFocus();
              }
            } else if (6 == numDigit) {

              if (value == '') {
                controller.fifth.selection = TextSelection.fromPosition(TextPosition(offset: controller.fifth.text.length));
                controller.fifthFN.requestFocus();
              } else {
                controller.confirmCode();
              }
            }
          },
          maxLength: 1,
          keyboardType: TextInputType.number, 
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            fillColor: controller.isLoading.call() ? Colors.grey.shade200 : Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none
            ),
            contentPadding: EdgeInsets.only(bottom: 15),
            counterText: "",
          )
        );
      }),
    );
  }
}