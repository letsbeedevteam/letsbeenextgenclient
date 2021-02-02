import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/history/history_controller.dart';

class HistoryBind extends Bindings {

  @override
  void dependencies() {
    Get.put(HistoryController());
  }
}