import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/webview/webview_controller.dart';

class WebViewBind extends Bindings {

  @override
  void dependencies() {
    Get.put(WebController());
  }
}