import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';

extension StringExtension on String {

  String uppercase() => this.toUpperCase();
}

extension IntExtension on String {
  double toDouble() {
    return double.parse(this);
  }
}

void errorSnackBarBottom({String title ,String message}) {
  if (Get.isSnackbarOpen) Get.back();
  Get.snackbar(title, message, boxShadows: [BoxShadow(color: Colors.black, blurRadius: 2)], backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, icon: Icon(Icons.error, color: Colors.red), margin: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0));
}

void alertSnackBarTop({String title ,String message}) {
  if (Get.isSnackbarOpen) Get.back();
  Get.snackbar(title, message, boxShadows: [BoxShadow(color: Colors.black, blurRadius: 2)], backgroundColor: Colors.white, snackPosition: SnackPosition.TOP, icon: Icon(Icons.warning, color: Colors.orange), margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0));
}

void errorSnackbarTop({String title ,String message}) {
  if (Get.isSnackbarOpen) Get.back();
  Get.snackbar(title, message, boxShadows: [BoxShadow(color: Colors.black, blurRadius: 2)], backgroundColor: Colors.white, snackPosition: SnackPosition.TOP, icon: Icon(Icons.error, color: Colors.red), margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0));
}

void successSnackBarTop({String title , String message, SnackbarStatusCallback status}) {
  if (Get.isSnackbarOpen) Get.back();
  Get.snackbar(title, message, boxShadows: [BoxShadow(color: Colors.black, blurRadius: 2)], backgroundColor: Colors.white, snackPosition: SnackPosition.TOP, icon: Icon(Icons.check_box, color: Colors.green), margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0), snackbarStatus: status);
}

void deleteSnackBarTop({String title , String message, SnackbarStatusCallback status}) {
  if (Get.isSnackbarOpen) Get.back();
  Get.snackbar(title, message, boxShadows: [BoxShadow(color: Colors.black, blurRadius: 2)], backgroundColor: Colors.white, snackPosition: SnackPosition.TOP, icon: Icon(Icons.delete, color: Colors.red), margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0), snackbarStatus: status, duration: Duration(seconds: 10));
}

void paymentSnackBarTop({String title , String message, SnackbarStatusCallback status}) {
  if (Get.isSnackbarOpen) Get.back();
  Get.snackbar(title, message, boxShadows: [BoxShadow(color: Colors.black, blurRadius: 2)], backgroundColor: Colors.white, snackPosition: SnackPosition.TOP, icon: Icon(Icons.payment, color: Color(Config.LETSBEE_COLOR).withOpacity(1.0)), margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0), snackbarStatus: status);
}

void dismissKeyboard(BuildContext context) => FocusScope.of(context).requestFocus(FocusNode());

void copyText(String value) => Clipboard.setData(ClipboardData(text: value));