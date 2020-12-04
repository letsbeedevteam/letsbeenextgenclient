import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/menu/menu_controller.dart';

class MenuBind extends Bindings {

  @override
  void dependencies() {
    Get.put(MenuController());
  }
}