import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/forgot_password/forgot_password_controller.dart';

class ForgotPassBind extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}