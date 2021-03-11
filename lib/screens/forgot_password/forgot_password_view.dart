import 'package:code_field/code_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/screens/forgot_password/forgot_password_controller.dart';

class ForgotPasswordPage extends GetView<ForgotPasswordController> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => dismissKeyboard(Get.context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () {
            dismissKeyboard(Get.context);
            Get.back();
          }),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(tr('forgotPassword'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: PreferredSize(
            child: Container(height: 1, color: Colors.grey.shade200),
            preferredSize: Size.fromHeight(4.0)
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _numberTextField(),
            Obx(() {
              return controller.isSentCode.call() ? _codeTextField() : Container();
            }),
            _sendCodeButton(),
            Obx(() {
             return controller.isSentCode.call() ? _footer() : Container();
           })
          ],
        ),
      ),
    );
  }

  Widget _footer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Text(tr('didntSendCode'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        GestureDetector(
          onTap: () => controller.isResendCodeLoading.call() ? null : controller.sendCode(type: 'resend_code'),
          child: Text(tr('resendCode'), style: TextStyle(fontSize: 15, color: controller.isResendCodeLoading.call() ? Color(Config.GREY_TEXT_COLOR) : Color(Config.YELLOW_TEXT_COLOR), fontWeight: FontWeight.w500))
        ),
      ],
    );
  }

  Widget _sendCodeButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Obx(() {
          return SizedBox(
            width: Get.width * 0.85,
            child: RaisedButton(
              color: Color(Config.LETSBEE_COLOR),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text(controller.isLoading.call() ? tr('loading') : controller.isSentCode.call() ?  tr('proceed') :  tr('sendCode'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
              onPressed: () => controller.isLoading.call() ? null : controller.isSentCode.call() ? controller.goToChangePassword() : controller.sendCode(),
            )
          );
        }),
      ),
    );
  }

  Widget _numberTextField() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr('contactNumber'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Obx(() {
            return SizedBox(
              height: 40,
              child: TextFormField(
                enabled: !controller.isLoading.call(),
                controller: controller.numberController,
                focusNode: controller.numberFN,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'(^\-?\d*\.?\d*)'))
                ],
                keyboardType: TextInputType.number, 
                textInputAction: TextInputAction.done,
                enableSuggestions: false,
                autocorrect: false,
                obscureText: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  prefixIcon: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                      color: Color(0xFFF5D247),
                    ),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10), 
                    margin: EdgeInsets.only(right: 10), 
                    child: Text('+63', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500))
                  ),
                  fillColor: controller.isLoading.call() ? Colors.grey.shade200 : Colors.white,
                  filled: true,
                  counterText: "",
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
                  contentPadding: EdgeInsets.only(left: 15, right: 15)
                )
              ),
            );
          }),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        ],
      ),
    );
  }


  // Widget _buildCodeAndPassword() {
  //   return Container(
  //      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         _codeTextField(),
  //         Padding(padding: EdgeInsets.symmetric(vertical: 10)),
  //         _newPasswordTextField()
  //       ],
  //     ),
  //   );
  // }

  Widget _codeTextField() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr('enterOtp'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          InputCodeField(
            control: controller.codeControl,
            count: 6,
            autofocus: true,
            inputType: TextInputType.number,
            decoration: InputCodeDecoration(
              focusColor: Colors.blueGrey,
              textStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              box: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
              ),
              focusedBox: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black, spreadRadius: 1),
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        ],
      ),
    );
  }

  // Widget _newPasswordTextField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(tr('newPassword'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
  //       Padding(padding: EdgeInsets.symmetric(vertical: 5)),
  //       SizedBox(
  //         height: 40,
  //         child: Obx(() {
  //           return TextFormField(
  //             enabled: !controller.isLoading.call(),
  //             controller: controller.newPasswordController,
  //             focusNode: controller.newPasswordFN,
  //             textAlign: TextAlign.start,
  //             // onEditingComplete: () {
  //             //   controller.repeatPassController.selection = TextSelection.fromPosition(TextPosition(offset: controller.repeatPassController.text.length));
  //             //   controller.repeatPassFn.requestFocus();
  //             // },
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
  //             textInputAction: TextInputAction.next,
  //             enableSuggestions: false,
  //             autocorrect: false,
  //             obscureText: !controller.isShowNewPass.call(),
  //             cursorColor: Colors.black,
  //             decoration: InputDecoration(
  //               prefixIcon: Padding(
  //                 padding: const EdgeInsets.all(12.0),
  //                 child: Image.asset(Config.PNG_PATH + 'password.png', width: 10,),
  //               ),
  //               suffixIcon: IconButton(
  //                 onPressed: () => controller.isShowNewPass(!controller.isShowNewPass.call()),
  //                 icon: controller.isShowNewPass.call() ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
  //               ),
  //               fillColor: !controller.isLoading.call() ? Colors.white : Colors.grey.shade200,
  //               filled: true,
  //               enabledBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //                 borderSide: BorderSide.none
  //               ),
  //               disabledBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //                 borderSide: BorderSide.none
  //               ),
  //               focusedBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //                 borderSide: BorderSide.none
  //               ),
  //               contentPadding: EdgeInsets.only(left: 15, right: 15)
  //             )
  //           );
  //         }),
  //       )
  //     ],
  //   );
  // }
}