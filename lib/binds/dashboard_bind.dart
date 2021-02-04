import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';

class DashboardBind extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(CartController());
  }
}