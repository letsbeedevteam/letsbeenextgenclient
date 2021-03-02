import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/screens/auth/signUp/controller/signup_controller.dart';
import 'package:letsbeeclient/screens/user_details/user_details_controller.dart';

class UserDetailsPage extends GetView<UserDetailsController> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => dismissKeyboard(Get.context),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('User Details', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
          leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () {
            SignUpController.to.clear();
            Get.back();
          }),
          centerTitle: true,
          bottom: PreferredSize(
            child: Container(height: 2, color: Colors.grey.shade200),
            preferredSize: Size.fromHeight(3.0)
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _nameTextField(),
              Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              _numberTextField(),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Obx(() {
                return SizedBox(
                  width: Get.width * 0.85,
                  child: RaisedButton(
                    color: Color(Config.LETSBEE_COLOR),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(controller.isLoading.call() ? 'Loading...' : 'Next', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                    onPressed: () => controller.isLoading.call() ? null : controller.sendCode(),
                  )
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _nameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        SizedBox(
          height: 40,
          child: Obx(() {
            return TextFormField(
              enabled: !controller.isLoading.call(),
              controller: controller.nameController,
              focusNode: controller.nameFN,
              onEditingComplete: () {
                controller.numberController.selection = TextSelection.fromPosition(TextPosition(offset: controller.numberController.text.length));
                controller.numberFN.requestFocus();
              },
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18),
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
                contentPadding: EdgeInsets.only(left: 15)
              )
            );
          }),
        )
      ],
    );
  }

  Widget _numberTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Contact Number', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        Obx(() {
          return SizedBox(
            height: 40,
            child: TextFormField(
              enabled: !controller.isLoading.call(),
              controller: controller.numberController,
              focusNode: controller.numberFN,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18),
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
                contentPadding: EdgeInsets.only(left: 15)
              )
            ),
          );
        })
      ],
    );
  }
}