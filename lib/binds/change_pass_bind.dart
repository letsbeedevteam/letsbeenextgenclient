import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/change_password/change_password_controller.dart';

class ChangePassBind extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
  }
}