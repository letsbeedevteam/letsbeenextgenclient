import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/account_info/account_info_controller.dart';
class AccountInfoBind extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AccountInfoController>(() => AccountInfoController());
  }
}