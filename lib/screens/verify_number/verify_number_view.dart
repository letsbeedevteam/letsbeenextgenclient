import 'package:code_field/code_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/screens/verify_number/controller/verify_number_controller.dart';
import 'package:easy_localization/easy_localization.dart';

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
          title: Text(tr('verification'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text(tr('enterCode'), style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Obx(() {
              return Text(
                '${tr('enterOtp')} +63${controller.signInData.call().cellphoneNumber == null ? '' : controller.signInData.call().cellphoneNumber.replaceFirst(RegExp(r'^0+'), "")}', 
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Text(tr('didntSendCode'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        Obx(() {
          return GestureDetector(
            onTap: () => controller.isResendCodeLoading.call() ? null : controller.resendOtp(),
            child: Text(tr('resendCode'), style: TextStyle(fontSize: 15, color: controller.isResendCodeLoading.call() ? Color(Config.GREY_TEXT_COLOR) : Color(Config.YELLOW_TEXT_COLOR), fontWeight: FontWeight.w500))
          );
        })
      ],
    );
  }

  Widget _getInputField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        return InputCodeField(
          control: controller.codeControl,
          count: 6,
          autofocus: true,
          inputType: TextInputType.number,
          decoration: InputCodeDecoration(
            focusColor: Colors.blueGrey,
            textStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            box: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: controller.isLoading.call() ? Colors.grey.shade200 : Colors.white
            ),
            focusedBox: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: controller.isLoading.call() ? Colors.grey.shade200 : Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black, spreadRadius: 1),
              ],
            ),
          ),
        );
      }),
    );
  }
}