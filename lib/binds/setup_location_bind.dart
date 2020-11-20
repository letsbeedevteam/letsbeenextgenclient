import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/controllers/setup_location/setup_location_controller.dart';

class SetupLocationBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetupLocationController>(() => SetupLocationController());
  }
}