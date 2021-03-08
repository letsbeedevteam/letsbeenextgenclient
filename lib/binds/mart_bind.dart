import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/grocery/mart/mart_controller.dart';

class StoreBind extends Bindings {

  @override
  void dependencies() {
    Get.put(MartController());
  }
}