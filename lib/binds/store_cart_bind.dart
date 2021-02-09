import 'package:get/get.dart';
import 'package:letsbeeclient/screens/mart/store_cart/store_cart_controller.dart';

class StoreCartBind extends Bindings {

  @override
  void dependencies() {
    Get.put(StoreCartController());
  }
}