import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/address/address_controller.dart';
class AddressBind extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AddressController>(() => AddressController());
  }
}