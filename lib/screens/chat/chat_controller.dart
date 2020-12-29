import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/activeOrderResponse.dart';
import 'package:letsbeeclient/models/chatResponse.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/services/socket_service.dart';

class ChatController extends GetxController {
  
  final replyTF = TextEditingController();
  final scrollController = ScrollController();
  final SocketService _socketService = Get.find();
  final arguments = Get.arguments;
  
  var activeOrderData = ActiveOrderData().obs;
  var chat = RxList<ChatData>().obs;
  var message = ''.obs;

  @override
  void onInit() {
    activeOrderData(arguments);
    fetchOrderChats();
    updadateReceiveChat();
    super.onInit();
  }

  goBack() {
    DashboardController.to.isOnChat(false);
    Get.back();
  }

  sendMessageToRider() {
    if (replyTF.text.isNullOrBlank) {
      alertSnackBarTop(title: 'Oops!', message: 'Your message is empty');
    } else {
      _socketService.socket.emitWithAck('message-rider', {'order_id': activeOrderData.call().id, 'rider_user_id': activeOrderData.call().rider.userId, 'message': replyTF.text});
      replyTF.clear();
      scrollController.animateTo(1, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    }
  }

  updadateReceiveChat() {
    _socketService.socket.on('order-chat', (response) {
      print('receive message: $response');
      final test = ChatData.fromJson(response['data']);
      chat.call().add(test);
      chat.call().sort((a, b) => a.createdAt.compareTo(b.createdAt));
    });
  }

  fetchOrderChats() {
    _socketService.socket.emitWithAck('order-chats', {'order_id': activeOrderData.call().id}, ack: (response) {
      'fetch: $response'.printWrapped();
      if (response['status'] == 200) {
          
        var getResponse = ChatResponse.fromJson(response);

        chat.call().addAll(getResponse.data);
        chat.call().sort((a, b) => a.createdAt.compareTo(b.createdAt));

        if(chat.call().isEmpty) message('No Messages');

      } else {
        errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
      }
    });
  }
}