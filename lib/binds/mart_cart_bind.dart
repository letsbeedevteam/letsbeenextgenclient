import 'package:get/get.dart';
import 'package:letsbeeclient/screens/grocery/mart_cart/mart_cart_controller.dart';

class StoreCartBind extends Bindings {

  @override
  void dependencies() {
    Get.put(MartCartController());
  }
}