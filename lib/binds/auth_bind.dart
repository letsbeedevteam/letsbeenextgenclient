import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/auth/controller/auth_controller.dart';
import 'package:letsbeeclient/screens/auth/controller/auth_model.dart';

class AuthBind extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<AuthModel>(() => AuthModel());
  }
}