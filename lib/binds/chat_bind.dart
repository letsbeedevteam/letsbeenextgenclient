import 'package:get/instance_manager.dart';
import 'package:letsbeeclient/screens/chat/chat_controller.dart';

class ChatBind extends Bindings {

  @override
  void dependencies() {
    Get.put(ChatController());
  }
}