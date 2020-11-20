import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

extension StringExtension on String {

  String uppercase() => this.toUpperCase();

  Future copyText() => Clipboard.setData(ClipboardData(text: this));
}

void customSnackbar(String error) => Get.snackbar('Error', error, snackPosition: SnackPosition.BOTTOM, icon: Icon(Icons.error, color: Colors.red), margin: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0));