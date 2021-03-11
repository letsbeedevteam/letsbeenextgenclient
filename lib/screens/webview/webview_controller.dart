import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
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

    Future.delayed(Duration(seconds: 1)).then((value) {
      apiService.deleteOrderById(orderId: argument['order_id']).then((value) {
        isLoading(false);

        if(value.status == 200) {
          DashboardController.to.fetchActiveOrders();
          Get.back(closeOverlays: true);
          Future.delayed(Duration(seconds: 1));
          Get.back();
        } else {
          errorSnackbarTop(title: 'Oops', message: tr('somethingWentWrong'));
        }

      }).catchError((onError) {
        isLoading(false);
        errorSnackbarTop(title: 'Oops', message: tr('somethingWentWrong'));
        print('Error delete order: $onError');
      });
    });
  }
}