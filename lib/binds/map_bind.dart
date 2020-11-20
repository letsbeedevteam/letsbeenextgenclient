import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/controllers/map/map_controller.dart';

class MapBind extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<MapController>(() => MapController());
  }
}