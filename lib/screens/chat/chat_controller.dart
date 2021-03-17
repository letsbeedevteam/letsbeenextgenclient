import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/active_order_response.dart';
import 'package:letsbeeclient/models/chat_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/services/socket_service.dart';

class ChatController extends GetxController {
  
  final replyTF = TextEditingController();
  final scrollController = ScrollController();
  final arguments = Get.arguments;
  SocketService _socketService = Get.find();
  
  var activeOrderData = ActiveOrderData().obs;
  var chat = RxList<ChatData>().obs;
  var message = ''.obs;
  var title = ''.obs;
  var isLoading = false.obs;
  var isSending = false.obs;

  final dashboardController = DashboardController.to;

  @override
  void onInit() {
    activeOrderData(arguments);

    if (activeOrderData.call().activeStore.locationName.isBlank) {
      this.title("${activeOrderData.call().activeStore.name}");
    } else {
      this.title("${activeOrderData.call().activeStore.name} (${activeOrderData.call().activeStore.locationName})");
    }

    _socketService.socket?.on('connect', (_) {
      _socketService.socket.clearListeners();
      dashboardController.isConnected(true);
      dashboardController.color(Colors.green);
      dashboardController.connectMessage(tr('connected'));
      dashboardController.fetchActiveOrders();
      dashboardController.receiveUpdateOrder();
      dashboardController.receiveChat();

      print('Connected');
      fetchOrderChats(orderId: activeOrderData.call().id);
      updadateReceiveChat();
      chat.call().where((data) => !data.isSent).forEach((element) {
        messageRiderRequest(element.message);
      });
    });
    _socketService.socket?.on('connecting', (_) {
      dashboardController.isConnected(false);
      dashboardController.color(Colors.orange);
      dashboardController.connectMessage(tr('connecting'));

      print('Connecting');
    });
    _socketService.socket?.on('reconnecting', (_) {
      dashboardController.isConnected(false);
      dashboardController.color(Colors.orange);
      dashboardController.connectMessage(tr('reconnecting'));

      isSending(false);
      print('Reconnecting');
    });
    _socketService.socket?.on('disconnect', (_) {
      dashboardController.isConnected(false);
      dashboardController.color(Colors.orange);
      dashboardController.connectMessage(tr('reconnecting'));

      isSending(false);
      print('Disconnected');
    });
    _socketService.socket?.on('error', (_) {
      dashboardController.isConnected(false);
      dashboardController.color(Colors.red);
      dashboardController.connectMessage(tr('notSent'));

      isSending(false);
      print('Error socket: $_');
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
    _socketService.socket?.emitWithAck('message-rider', {'order_id': activeOrderData.call().id, 'rider_user_id': activeOrderData.call().rider.userId, 'message': message}, ack: (response) {
      print('sent $response');
      if (response['status'] == 200) {
        final test = ChatData.fromJson(response['data']);
        chat.call().removeWhere((element) => !element.isSent);
        chat.call().add(test);
        chat.call().sort((a, b) => a.createdAt.compareTo(b.createdAt));
        replyTF.clear();
        try {
          scrollController.animateTo(1, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        } catch(e) {
          print(e);
        }
      } else {
        errorSnackbarTop(title: tr('oops'), message: tr('notSent'));
      }
    });
  }

  updadateReceiveChat() {
    _socketService.socket?.on('order-chat', (response) {
      print('receive message 111: $response');
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

    _socketService.socket?.emitWithAck('order-chats', {'order_id': orderId}, ack: (response) {
      'fetch: $response'.printWrapped();
      isLoading(false);
      if (response['status'] == 200) {

        final chatResponse = ChatResponse.fromJson(response);

        chat.call().assignAll(chatResponse.data);
        chat.call().sort((a, b) => a.id.compareTo(b.id));
        if(chat.call().isEmpty) message(tr('noMessages'));

      } else {
        chat.call().clear();
        message(tr('somethingWentWrong'));
      }
    });
  }
}