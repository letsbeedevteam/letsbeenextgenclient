import 'dart:io';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/services/api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebController extends GetxController {

  final ApiService apiService = Get.find();
  final argument = Get.arguments;

  var isLoading = true.obs;

  @override
  void onInit() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.onInit();
  }


  deleteOrderById() {

    isLoading(true);
    deleteSnackBarTop(title: 'Cancelling the payment', message: 'Please wait, and it will automatically go back.');

    apiService.deleteOrderById(orderId: argument['order_id']).then((value) {
      isLoading(false);

      if(value.status == 200) {
        Get.back(closeOverlays: true);
      } else {
        errorSnackbarTop(title: 'Oops', message: Config.SOMETHING_WENT_WRONG);
      }

    }).catchError((onError) {
      isLoading(false);
      errorSnackbarTop(title: 'Oops', message: Config.SOMETHING_WENT_WRONG);
      print('Error delete order: $onError');
    });
  }
}