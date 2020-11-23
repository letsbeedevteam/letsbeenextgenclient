import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/controllers/signup/signup_controller.dart';

class SignUpBind extends Bindings {

  @override
  void dependencies() {
    Get.put(SignUpController());
  }
}