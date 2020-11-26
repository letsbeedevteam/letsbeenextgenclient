import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/verify_number/controller/verify_number_controller.dart';

class VerifyNumberBind extends Bindings {

  @override
  void dependencies() {
    Get.put(VerifyNumberController());
  }
}