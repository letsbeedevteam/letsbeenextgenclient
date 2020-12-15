import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/rider_location/rider_location_controller.dart';

class RiderLocationBind extends Bindings {

  @override
  void dependencies() {
    Get.put(RiderLocationController());
  }
}