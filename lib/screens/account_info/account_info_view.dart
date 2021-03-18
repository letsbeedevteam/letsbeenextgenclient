import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/screens/account_info/account_info_controller.dart';

class AccountInfoPage extends GetView<AccountInfoController> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => dismissKeyboard(Get.context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () => Get.back()),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(tr('accountInfo'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: PreferredSize(
            child: Container(height: 1, color: Colors.grey.shade200),
            preferredSize: Size.fromHeight(4.0)
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _nameTextField(),
                _emailTextField(),
                _numberTextField(),
                Container(height: 1, color: Colors.grey.shade200),
                _changePassword(),
                Container(height: 1, color: Colors.grey.shade200),
                _saveButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _saveButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
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
              onPressed: () => controller.isLoading.call() ? null : controller.saveAccountInfo(),
            )
          );
        }),
      ),
    );
  }

  Widget _changePassword() {
    return GestureDetector(
      onTap: () => controller.goToChangePassword(),
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
        decoration: BoxDecoration(
          color: Color(Config.WHITE)
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(tr('changePass'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
                 Icon(Icons.chevron_right)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _nameTextField() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr('name'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          SizedBox(
            height: 40,
            child: Obx(() {
              return TextFormField(
                enabled: !controller.isLoading.call(),
                controller: controller.nameController,
                focusNode: controller.nameFN,
                onEditingComplete: () {
                  controller.emailController.selection = TextSelection.fromPosition(TextPosition(offset: controller.emailController.text.length));
                  controller.emailFN.requestFocus();
                },
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                textInputAction: TextInputAction.next,
                enableSuggestions: false,
                autocorrect: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(Config.PNG_PATH + 'user.png', width: 10,),
                  ),
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
                  contentPadding: EdgeInsets.only(left: 15, right: 15)
                )
              );
            }),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 15)),
        ],
      ),
    );
  }

  Widget _emailTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr('emailAddress'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          SizedBox(
            height: 40,
            child: Obx(() {
              return TextFormField(
                enabled: !controller.isLoading.call(),
                controller: controller.emailController,
                focusNode: controller.emailFN,
                onEditingComplete: () {
                  controller.numberController.selection = TextSelection.fromPosition(TextPosition(offset: controller.numberController.text.length));
                  controller.numberFN.requestFocus();
                },
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                keyboardType: TextInputType.emailAddress, 
                textInputAction: TextInputAction.next,
                enableSuggestions: false,
                autocorrect: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(Config.PNG_PATH + 'email.png', width: 10,),
                  ),
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
                  contentPadding: EdgeInsets.only(left: 15, right: 15)
                )
              );
            }),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 15)),
        ],
      ),
    );
  }

  Widget _numberTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
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
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        ],
      ),
    );
  }
}