import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/webview/webview_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends GetView<WebController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0.0,
        centerTitle: false,
        leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: controller.deleteOrderById),
        title: Text('Payment method')
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
                  controller.isLoading.value = false;
                  print('print: $url');
                 
                  if (url.contains('/payment/success-checkout')) {
                    paymentSuccessDialog();
                    // successSnackBarTop(title: 'Alert', message: 'Successful checkout!');
                  }
                },
                onWebResourceError: (error) {
                  controller.isLoading.value = false;
                  print('Webview ERROR: ${error.description}');
                },
              );
            },
          ),
          Center(child: Obx(() => controller.isLoading.value ? Text('Loading...') : Container()))
        ],
      )
    );
  }

  paymentSuccessDialog() {
    Get.defaultDialog(
      content: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.credit_card, color: Colors.green),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text('Payment Successful')
                ],
              )
            ),
            Text('Please check your order on-going')
          ],
        ),
      ),
      title: 'Success!',
      barrierDismissible: false,
      confirmTextColor: Colors.black,
      confirm: RaisedButton(
        color: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text('Go back'), 
        onPressed: () => Get.back(closeOverlays: true)
      ),
    );
  }
}