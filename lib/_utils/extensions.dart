import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';

extension StringExtension on String {

  String uppercase() => this.toUpperCase();

  TimeOfDay tod() {
    final format = DateFormat.jm();
    return TimeOfDay.fromDateTime(format.parse(this));
  }
  
  void printWrapped()  {
      final pattern = RegExp('.{1,800}');
      pattern.allMatches(this).forEach((match) => print(match.group(0)));
  }
}

extension IntExtension on String {
  double toDouble() {
    return double.parse(this);
  }
}

extension TextFieldExtension on TextEditingController {

  selectedText() => this.selection = TextSelection.fromPosition(TextPosition(offset: this.text.length));
} 

void errorSnackBarBottom({String title ,String message}) {
  if (!Get.isSnackbarOpen)
    Get.snackbar(title, message, boxShadows: [BoxShadow(color: Colors.black, blurRadius: 1)], backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, icon: Icon(Icons.error, color: Colors.red), margin: EdgeInsets.all(5), borderRadius: 4, duration: Duration(milliseconds: 800));
}

void alertSnackBarTop({String title ,String message}) {
  if (!Get.isSnackbarOpen)
    Get.snackbar(title, message, boxShadows: [BoxShadow(color: Colors.black, blurRadius: 1)], backgroundColor: Colors.white, snackPosition: SnackPosition.TOP, icon: Icon(Icons.warning, color: Colors.orange), margin: EdgeInsets.all(5), borderRadius: 4, duration: Duration(milliseconds: 800));
}

void errorSnackbarTop({String title ,String message}) {
  if (!Get.isSnackbarOpen) 
    Get.snackbar(title, message, boxShadows: [BoxShadow(color: Colors.black, blurRadius: 1)], backgroundColor: Colors.white, snackPosition: SnackPosition.TOP, icon: Icon(Icons.error, color: Colors.red), margin: EdgeInsets.all(5), borderRadius: 4, duration: Duration(milliseconds: 800));
}

void successSnackBarTop({String title , String message, int seconds, SnackbarStatusCallback status}) {
  if (!Get.isSnackbarOpen)
    Get.snackbar(title, message, boxShadows: [BoxShadow(color: Colors.black, blurRadius: 1)], backgroundColor: Colors.white, snackPosition: SnackPosition.TOP, icon: Icon(Icons.check_box, color: Colors.green), margin: EdgeInsets.all(5), borderRadius: 4, snackbarStatus: status, duration: Duration(seconds: seconds == null ? 2 : seconds));
}

void deleteSnackBarTop({String title , String message, int seconds, SnackbarStatusCallback status}) {
  if (!Get.isSnackbarOpen)
    Get.snackbar(title, message, boxShadows: [BoxShadow(color: Colors.black, blurRadius: 1)], backgroundColor: Colors.white, snackPosition: SnackPosition.TOP, icon: Icon(Icons.delete, color: Colors.red), margin: EdgeInsets.all(5), borderRadius: 4, snackbarStatus: status, duration: Duration(seconds: seconds == null ? 2 : seconds));
}

void paymentSnackBarTop({String title , String message, SnackbarStatusCallback status}) {
  if (!Get.isSnackbarOpen)
    Get.snackbar(title, message, boxShadows: [BoxShadow(color: Colors.black, blurRadius: 1)], backgroundColor: Colors.white, snackPosition: SnackPosition.TOP, icon: Icon(Icons.payment, color: Color(Config.LETSBEE_COLOR)), margin: EdgeInsets.all(5), borderRadius: 4, snackbarStatus: status, duration: Duration(milliseconds: 800));
}

void dismissKeyboard(BuildContext context) {
  final currentFocus = FocusScope.of(context);
  currentFocus.requestFocus(FocusNode());
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.focusedChild.unfocus();
  }
}

void copyText(String value) => Clipboard.setData(ClipboardData(text: value));

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
}