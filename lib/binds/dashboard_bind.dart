import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/controllers/dashboard/dashboard_controller.dart';

class DashboardBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}