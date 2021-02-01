import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/setup_location/controllers/setup_location_controller.dart';

class SetupLocationBind extends Bindings {
  @override
  void dependencies() {
    Get.put(SetupLocationController());
  }
}