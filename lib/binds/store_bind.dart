import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/mart/store/store_controller.dart';

class StoreBind extends Bindings {

  @override
  void dependencies() {
    Get.put(StoreController());
  }
}