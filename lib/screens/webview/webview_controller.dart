import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/active_order_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';
import 'package:letsbeeclient/services/socket_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebController extends GetxController {

  final ApiService apiService = Get.find();
  final SocketService socketService = Get.find();
  final argument = Get.arguments;

  WebViewController webViewController;

  var isLoading = true.obs;
  var isCancelPaymentLoading = false.obs;
  
  var isPaymentSuccess = false.obs;

  var orderId = 0.obs;
  var storeId = 0.obs;

  var hasError = false.obs;

  final dashboard = DashboardController.to;

  @override
  void onInit() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    orderId(argument['order_id']);
    storeId(argument['store_id']);

    socketService.socket?.on('order', (response) {
      if (response['status'] == Config.OK) {
        if(response['code'] == 'paid') {
          dashboard.activeOrderData(ActiveOrderData.fromJson(response['data']));
          goBackToRestoPage();
          dashboard.goToActiveOrder();
        }
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    isPaymentSuccess(false);
    socketService.socket.off('order');
    super.onClose();
  }

  Future<Null> back() async => isPaymentSuccess.call() ? Get.back() : await cancelOrderPayment();

  cancelOrderPayment() {
    
    isCancelPaymentLoading(true);
    alertSnackBarTop(message: tr('pleaseWait'));

    Future.delayed(Duration(seconds: 1)).then((value) {
      apiService.cancelOnlinePayment(orderId: orderId.call()).then((response) {
        isCancelPaymentLoading(false);

        if(response.status == Config.OK) {
          DashboardController.to.fetchActiveOrders();
        } 

        Get.back();


      }).catchError((onError) {
        isCancelPaymentLoading(false);
        Get.back();
        print('Error delete order: $onError');
      });
    });
  }

  goBackToRestoPage() {
    Get.back();
    Future.delayed(Duration(milliseconds: 500));
    Get.back();
  }
}