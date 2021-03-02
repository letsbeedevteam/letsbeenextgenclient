import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/user_details/user_details_controller.dart';
class UserDetailsBind extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<UserDetailsController>(() => UserDetailsController());
  }
}