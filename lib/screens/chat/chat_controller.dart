import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/active_order_response.dart';
import 'package:letsbeeclient/models/chat_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';

class ChatController extends GetxController {
  
  final replyTF = TextEditingController();
  final scrollController = ScrollController();
  final arguments = Get.arguments;
  
  var activeOrderData = ActiveOrderData().obs;
  var chat = RxList<ChatData>().obs;
  var connectMessage = tr('connecting').obs;
  var message = ''.obs;
  var title = ''.obs;
  var isLoading = false.obs;
  var isSending = false.obs;
  var isConnected = true.obs;
  var color = Colors.orange.obs;

  final dashboardController = DashboardController.to.socketService;

  @override
  void onInit() {
    activeOrderData(arguments);

    if (activeOrderData.call().activeStore.locationName.isBlank) {
      this.title("${activeOrderData.call().activeStore.name}");
    } else {
      this.title("${activeOrderData.call().activeStore.name} (${activeOrderData.call().activeStore.locationName})");
    }
    
    dashboardController.socket?.on('connect', (_) {
      Future.delayed(Duration(seconds: 2)).then((value) => isConnected(true));
      print('Connected');
      color(Colors.green);
      connectMessage(tr('connected'));
      fetchOrderChats(orderId: activeOrderData.call().id);
      updadateReceiveChat();

      chat.call().where((data) => !data.isSent).forEach((element) {
        messageRiderRequest(element.message);
      });
    });
    dashboardController.socket?.on('connecting', (_) {
      isConnected(false);
      print('Connecting');
      color(Colors.orange);
      connectMessage(tr('connecting'));
    });
    dashboardController.socket?.on('reconnecting', (_) {
      isConnected(false);
      isSending(false);
      print('Reconnecting');
      color(Colors.orange);
      connectMessage(tr('reconnecting'));
    });
    dashboardController.socket?.on('disconnect', (_) {
      isConnected(false);
      isSending(false);
      color(Colors.red);
      connectMessage(tr('disconnected'));
      print('Disconnected');
    });
    dashboardController.socket?.on('error', (_) {
      isConnected(false);
      isSending(false);
      color(Colors.red);
      print('Error socket: $_');
      connectMessage(tr('notSent'));
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
    if (replyTF.text.trim() == null || replyTF.text.trim() == '') {
      alertSnackBarTop(title: tr('oops'), message: tr('messageEmpty'));
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
    dashboardController.socket?.emitWithAck('message-rider', {'order_id': activeOrderData.call().id, 'rider_user_id': activeOrderData.call().rider.userId, 'message': message}, ack: (response) {
      print('sent $response');
      if (response['status'] == 200) {
        final test = ChatData.fromJson(response['data']);
        chat.call().removeWhere((element) => !element.isSent);
        chat.call().add(test);
        chat.call().sort((a, b) => a.createdAt.compareTo(b.createdAt));
        replyTF.clear();
        scrollController.animateTo(1, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
      } else {
        errorSnackbarTop(title: tr('oops'), message: tr('notSent'));
      }
    });
  }

  updadateReceiveChat() {
    dashboardController.socket?.on('order-chat', (response) {
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
    message(tr('loadingConversation'));
    isLoading(true);

    dashboardController.socket?.emitWithAck('order-chats', {'order_id': orderId}, ack: (response) {
      'fetch: $response'.printWrapped();
      isLoading(false);
      if (response['status'] == 200) {

        final chatResponse = ChatResponse.fromJson(response);

        chat.call().addAll(chatResponse.data);
        chat.call().sort((a, b) => a.id.compareTo(b.id));
        if(chat.call().isEmpty) message(tr('noMessages'));

      } else {
        chat.call().clear();
        message(tr('somethingWentWrong'));
      }
    });
  }
}