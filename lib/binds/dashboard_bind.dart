import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';

class DashboardBind extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
  }
}