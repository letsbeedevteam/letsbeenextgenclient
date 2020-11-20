import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/controllers/splash/splash_controller.dart';

class SplashBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}