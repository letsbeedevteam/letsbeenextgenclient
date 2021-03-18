import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';
import 'package:letsbeeclient/screens/grocery/mart_cart/mart_cart_controller.dart';
import 'package:letsbeeclient/screens/webview/webview_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends GetView<WebController> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.back(),
      child: Scaffold(
        backgroundColor: Color(Config.WHITE),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0.0,
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () => controller.back()),
          title: Text(tr('paymentMethod'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
          bottom: PreferredSize(
            child: Container(height: 1, color: Colors.grey.shade200),
            preferredSize: Size.fromHeight(4.0)
          ),
          actions: [
            Obx(() {
              return controller.isPaymentSuccess.call() ? Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
                child: RaisedButton(
                  color: Color(Config.LETSBEE_COLOR),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  onPressed: () => controller.goBackToRestoPage(),
                  child: Text(tr('done'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                ),
              ) : Container();
            })
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            GetBuilder<WebController>(
              builder: (controller) {
                return WebView(
                  initialUrl: controller.argument['url'],
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureNavigationEnabled: true,
                  onPageFinished: (url) {
                    print('print: $url');
                   
                    if (url.contains('payment') || url.contains('https://bux.ph/test/xendit/')) {
                      controller..isPaymentSuccess(true)..update();
                      DashboardController.to.fetchActiveOrders();
                      if (controller.argument['type'] == Config.RESTAURANT) {
                        CartController.to.clearCart(controller.storeId.call());
                      } else {
                        MartCartController.to.clearCart(controller.storeId.call());
                      }
                    }
                    controller..isLoading(false);
                  },
                  onWebResourceError: (error) {
                    controller..isLoading(false);
                    print('Webview ERROR: ${error.description}');
                  },
                );
              },
            ),
            Center(
              child: Obx(() => controller.isLoading.call() ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(top: 20)),
                  CupertinoActivityIndicator(),
                  Text(tr('loadingPayment'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                ],
              ) : Container())
            )
          ],
        )
      ),
    );
  }

  // paymentSuccessDialog() {
  //   Get.defaultDialog(
  //     content: Container(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Center(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Icon(Icons.credit_card, color: Colors.green),
  //                 Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
  //                 Text('Payment Successful')
  //               ],
  //             )
  //           ),
  //           Text('Please check your order on-going')
  //         ],
  //       ),
  //     ),
  //     title: 'Success!',
  //     barrierDismissible: false,
  //     confirmTextColor: Colors.black,
  //     confirm: RaisedButton(
  //       color: Colors.green,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //       child: Text('Go back'), 
  //       onPressed: () {
  //         Get.back(closeOverlays: true);
  //         Future.delayed(Duration(seconds: 1));
  //         Get.back();
  //       }
  //     ),
  //   );
  // }
}