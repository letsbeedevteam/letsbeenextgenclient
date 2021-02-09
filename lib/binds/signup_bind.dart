import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/auth/continue_with_email/controller/signup_controller.dart';

class SignUpBind extends Bindings {

  @override
  void dependencies() {
    Get.put(SignUpController());
  }
}