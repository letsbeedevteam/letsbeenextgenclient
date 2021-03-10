import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/history/history_detail/history_detail_controller.dart';

class HistoryDetailBind extends Bindings {

  @override
  void dependencies() {
    Get.put(HistoryDetailController());
  }
}