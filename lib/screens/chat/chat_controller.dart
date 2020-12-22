import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/activeOrderResponse.dart';
import 'package:letsbeeclient/models/chatResponse.dart';
import 'package:letsbeeclient/services/socket_service.dart';

class ChatController extends GetxController {
  
  final replyTF = TextEditingController();
  final scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );
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

  sendMessageToRider() {
    if (replyTF.text.isNullOrBlank) {
      alertSnackBarTop(title: 'Oops!', message: 'Your message is empty');
    } else {
      _socketService.socket.emitWithAck('message-rider', {'order_id': activeOrderData.call().id, 'rider_user_id': activeOrderData.call().rider.userId, 'message': replyTF.text});
      replyTF.clear();
    }
  }

  updadateReceiveChat() {
    _socketService.socket.on('order-chat', (response) {
      print('receive message: $response');
      final test = ChatData.fromJson(response['data']);
      chat.call().add(test);
    });
  }

  fetchOrderChats() {
    _socketService.socket.emitWithAck('order-chats', {'order_id': activeOrderData.call().id}, ack: (response) {
      print('fetch: $response');
      if (response['status'] == 200) {
          
        var getResponse = ChatResponse.fromJson(response);

        chat.call().addAll(getResponse.data);

        if(chat.call().isEmpty) message('No Messages');

      } else {
        errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
      }
    });
  }
}