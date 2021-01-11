import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/setup_location/controllers/map_controller.dart';

class MapBind extends Bindings {

  @override
  void dependencies() {
    Get.put(MapController());
  }
}