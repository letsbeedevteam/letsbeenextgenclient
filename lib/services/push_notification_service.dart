import 'dart:io';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/models/active_order_response.dart';
import 'package:letsbeeclient/models/chat_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';

class PushNotificationService extends GetxService {

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializesationSettings;

  initialise() async {
    if (Platform.isIOS) {
      _requestIOSPermission();
    }

    _init();
  }

  _requestIOSPermission() {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  _init() {
    initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = IOSInitializationSettings();
    initializesationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializesationSettings, onSelectNotification: onSelectionNotification);
  }

  Future onSelectionNotification(String payload) async {
    
    if (payload != null) {

      try {

        final activeOrderData = activeOrderDataFromJson(payload);
        final data = DashboardController.to.activeOrders.call().data.singleWhere((data) => data.id == activeOrderData.id);
        DashboardController.to.activeOrderData(data);
        if (data.status == 'rider-picked-up') {
          DashboardController.to.goToRiderLocationPage();     
        } else {
          DashboardController.to.goToActiveOrder();     
        }

      } catch (e) {
        
        final chatData = chatDataFromJson(payload);
        DashboardController.to.goToChatPage(fromNotificartion: true, data: chatData);   

      } 
    } 
  }

  Future<void> showNotification({@required String title, @required String body, String payload}) async {
    var androidPlatformChannel = AndroidNotificationDetails(
        'Customer Channel ID', 'Customer App', 'Customer Notification', importance: Importance.max, priority: Priority.high, ticker: 'test ticker');

    var iosPlatform = IOSNotificationDetails();
    var platform = NotificationDetails(android: androidPlatformChannel, iOS: iosPlatform);
    await _flutterLocalNotificationsPlugin.show(Random().nextInt(pow(2, 31) - 1), title, body, platform, payload: payload);
  }
}