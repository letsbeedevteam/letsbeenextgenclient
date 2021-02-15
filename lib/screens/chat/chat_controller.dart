import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/activeOrderResponse.dart';
import 'package:letsbeeclient/models/chatResponse.dart';
// import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/services/socket_service.dart';

class ChatController extends GetxController {
  
  final replyTF = TextEditingController();
  final scrollController = ScrollController();
  final SocketService _socketService = Get.find();
  final arguments = Get.arguments;
  
  var activeOrderData = ActiveOrderData().obs;
  var chat = RxList<ChatData>().obs;
  var connectMessage = 'Connecting'.obs;
  var message = ''.obs;
  var title = ''.obs;
  var isLoading = false.obs;
  var isSending = false.obs;
  var isConnected = true.obs;
  var color = Colors.orange.obs;

  @override
  void onInit() {
    activeOrderData(arguments);

    if (activeOrderData.call().activeStore.locationName.isBlank) {
      this.title("${activeOrderData.call().activeStore.name}");
    } else {
      this.title("${activeOrderData.call().activeStore.name} (${activeOrderData.call().activeStore.locationName})");
    }

    _socketService.socket
    ..on('connect', (_) {
      Future.delayed(Duration(seconds: 2)).then((value) => isConnected(true));
      print('Connected');
      color(Colors.green);
      connectMessage('Connected');
      fetchOrderChats(orderId: activeOrderData.call().id);

      chat.call().where((data) => !data.isSent).forEach((element) {
        messageRiderRequest(element.message);
      });
    })
    ..on('connecting', (_) {
      isConnected(false);
      print('Connecting');
      color(Colors.orange);
      connectMessage('Connecting');
    })
    ..on('reconnecting', (_) {
      isConnected(false);
      isSending(false);
      print('Reconnecting');
      color(Colors.orange);
      connectMessage('Reconnecting');
    })
    ..on('disconnect', (_) {
      isConnected(false);
      isSending(false);
      color(Colors.red);
      connectMessage('Disconnected');
      print('Disconnected');
    })
    ..on('error', (_) {
      isConnected(false);
      isSending(false);
      color(Colors.red);
      print('Error socket: $_');
      connectMessage('Your message can\'t be sent. Please try again');
    });

    fetchOrderChats(orderId: activeOrderData.call().id);
    updadateReceiveChat();
    super.onInit();
  }

  goBack() {
    // DashboardController.to.isOnChat(false);
    Get.back();
  }

  sendMessageToRider() {
    if (replyTF.text == null) {
      alertSnackBarTop(title: 'Oops!', message: 'Your message is empty');
    } else {

      String sendMessage = replyTF.text;

      chat.call().add(ChatData(
        id: chat.call().last.id + 1,
        orderId: activeOrderData.call().id,
        userId: activeOrderData.call().userId,
        message: replyTF.text,
        createdAt: DateTime.now(),
        isSent: false
      ));

      replyTF.clear();
      messageRiderRequest(sendMessage);
    }
  }

  messageRiderRequest(String message) {
    _socketService.socket.emitWithAck('message-rider', {'order_id': activeOrderData.call().id, 'rider_user_id': activeOrderData.call().rider.userId, 'message': message}, ack: (response) {
      print('sent $response');
      if (response['status'] == 200) {
        final test = ChatData.fromJson(response['data']);
        chat.call().removeWhere((element) => !element.isSent);
        chat.call().add(test);
        chat.call().sort((a, b) => a.createdAt.compareTo(b.createdAt));
        replyTF.clear();
        scrollController.animateTo(1, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
      } else {
        errorSnackbarTop(title: 'Oops!', message: 'Your message cannot be sent. Please try again');
      }
    });
  }

  updadateReceiveChat() {
    _socketService.socket.on('order-chat', (response) {
      print('receive message: $response');
      final orderChat = ChatData.fromJson(response['data']);
      if (activeOrderData.call() != null) {
        if (orderChat.orderId == activeOrderData.call().id) {
          chat.call().add(orderChat);
          chat.call().sort((a, b) => a.createdAt.compareTo(b.createdAt));
        }
      }
    });
  }

  fetchOrderChats({int orderId}) {
    message('Loading conversation...');
    isLoading(true);

    _socketService.socket.emitWithAck('order-chats', {'order_id': orderId}, ack: (response) {
      'fetch: $response'.printWrapped();
      isLoading(false);
      if (response['status'] == 200) {

        final chatResponse = ChatResponse.fromJson(response);

        chat.call().addAll(chatResponse.data);
        chat.call().sort((a, b) => a.id.compareTo(b.id));
        if(chat.call().isEmpty) message('No Messages');

      } else {
        chat.call().clear();
        message(Config.SOMETHING_WENT_WRONG);
      }
    });
  }
}