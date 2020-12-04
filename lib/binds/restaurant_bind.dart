import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/restaurant/restaurant_controller.dart';

class RestaurantBind extends Bindings {

  @override
  void dependencies() {
    Get.put(RestaurantController());
  }
}