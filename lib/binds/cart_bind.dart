import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';

class CartBind extends Bindings {

  @override
  void dependencies() {
    Get.put(CartController());
  }
}