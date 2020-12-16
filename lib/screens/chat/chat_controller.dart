import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/models/activeOrderResponse.dart';
import 'package:letsbeeclient/models/chatResponse.dart';
import 'package:letsbeeclient/services/socket_service.dart';

class ChatController extends GetxController {
  
  final replyTF = TextEditingController();
  final SocketService _socketService = Get.find();
  final arguments = Get.arguments;
  
  var activeOrderData = ActiveOrderData().obs;
  var chat = ChatResponse().obs;

  @override
  void onInit() {
    chat.nil();
    activeOrderData(arguments);
    fetchOrderChats();
    
    super.onInit();
  }

  sendMessageToRider() {
    _socketService.socket.emitWithAck('message-rider', {'order_id': activeOrderData.value.id, 'rider_id': activeOrderData.value.riderId}, ack: (response) {
      if (response['status'] == 200) {
        print(response);
      } else {
        print(response['message']);
      }
    });
  }

  fetchOrderChats() {
    _socketService.socket.emitWithAck('order-chats', {'order_id': activeOrderData.value.id}, ack: (response) {
      if (response['status'] == 200) {
        chat(ChatResponse.fromJson(response));
        print('Chat Response: ${chatResponseToJson(chat.value)}');
      } else {
        print(response['message']);
      }
    });
  }

  sendMessage() {
    if (replyTF.text.isNullOrBlank) {
      print('Field is empty');  
    } else {
      print(replyTF.text);
      replyTF.clear();
    }
  }
}