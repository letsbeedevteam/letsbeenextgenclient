import 'package:get/get.dart';
import 'package:letsbeeclient/screens/food/store_menu/store_menu_controller.dart';

class StoreMenuBind extends Bindings {

  @override
  void dependencies() {
    Get.put(StoreMenuController());
  }
}