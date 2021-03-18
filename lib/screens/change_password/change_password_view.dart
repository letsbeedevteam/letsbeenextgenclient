import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/screens/change_password/change_password_controller.dart';

class ChangePasswordPage extends GetView<ChangePasswordController> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => dismissKeyboard(Get.context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () => Get.back()),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(tr('changePass'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: PreferredSize(
            child: Container(height: 1, color: Colors.grey.shade200),
            preferredSize: Size.fromHeight(4.0)
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => controller.isForgotPas.call() ? Container() : _oldPasswordTextField()),
                Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                _newPasswordTextField(),
                Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                _repeatPasswordTextField(),
                Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                Obx(() => controller.isForgotPas.call() ? _changePasswordButton() : _saveButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _changePasswordButton() {
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
              child: Text(controller.isLoading.call() ? tr('loading') : tr('changePass'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
              onPressed: () => controller.isLoading.call() ? null : controller.forgotPassword(),
            )
          );
        }),
      ),
    );
  }

  Widget _saveButton() {
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
              child: Text(controller.isLoading.call() ? tr('loading') : tr('save'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
              onPressed: () => controller.isLoading.call() ? null : controller.changePassword(),
            )
          );
        }),
      ),
    );
  }

  Widget _oldPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('oldPassword'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        SizedBox(
          height: 40,
          child: Obx(() {
            return TextFormField(
              enabled: !controller.isLoading.call(),
              controller: controller.oldPassController,
              focusNode: controller.oldPassFN,
              textAlign: TextAlign.start,
              onEditingComplete: () {
                controller.newPassController.selection = TextSelection.fromPosition(TextPosition(offset: controller.newPassController.text.length));
                controller.newPassFN.requestFocus();
              },
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              textInputAction: TextInputAction.next,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: !controller.isShowOldPass.call(),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(Config.PNG_PATH + 'password.png', width: 10,),
                ),
                suffixIcon: IconButton(
                  onPressed: () => controller.isShowOldPass(!controller.isShowOldPass.call()),
                  icon: controller.isShowOldPass.call() ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                ),
                fillColor: !controller.isLoading.call() ? Colors.white : Colors.grey.shade200,
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
                contentPadding: EdgeInsets.only(left: 15, right: 15)
              )
            );
          }),
        )
      ],
    );
  }

  Widget _newPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('newPassword'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        SizedBox(
          height: 40,
          child: Obx(() {
            return TextFormField(
              enabled: !controller.isLoading.call(),
              controller: controller.newPassController,
              focusNode: controller.newPassFN,
              textAlign: TextAlign.start,
              onEditingComplete: () {
                controller.repeatPassController.selection = TextSelection.fromPosition(TextPosition(offset: controller.repeatPassController.text.length));
                controller.repeatPassFn.requestFocus();
              },
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              textInputAction: TextInputAction.next,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: !controller.isShowNewPass.call(),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(Config.PNG_PATH + 'password.png', width: 10,),
                ),
                suffixIcon: IconButton(
                  onPressed: () => controller.isShowNewPass(!controller.isShowNewPass.call()),
                  icon: controller.isShowNewPass.call() ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                ),
                fillColor: !controller.isLoading.call() ? Colors.white : Colors.grey.shade200,
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
                contentPadding: EdgeInsets.only(left: 15, right: 15)
              )
            );
          }),
        )
      ],
    );
  }

  Widget _repeatPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('repeatPassword'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        SizedBox(
          height: 40,
          child: Obx(() {
            return TextFormField(
              enabled: !controller.isLoading.call(),
              controller: controller.repeatPassController,
              focusNode: controller.repeatPassFn,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              textInputAction: TextInputAction.done,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: !controller.isShowRepeatPass.call(),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(Config.PNG_PATH + 'password.png', width: 10,),
                ),
                suffixIcon: IconButton(
                  onPressed: () => controller.isShowRepeatPass(!controller.isShowRepeatPass.call()),
                  icon: controller.isShowRepeatPass.call() ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                ),
                fillColor: !controller.isLoading.call() ? Colors.white : Colors.grey.shade200,
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
                contentPadding: EdgeInsets.only(left: 15, right: 15)
              )
            );
          }),
        )
      ],
    );
  }
}