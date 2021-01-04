import 'dart:convert';

NotificationData notificationDataFromJson(String str) => NotificationData.fromJson(json.decode(str));
String notificationDataToJson(NotificationData data) => json.encode(data.toJson());

class NotificationData {
  NotificationData({
    this.list
  });

  List<GetNotification> list;

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    list: List<GetNotification>.from(json["data"].map((x) => GetNotification.fromJson(x)))
  );

  Map<String, dynamic> toJson() => {
    "list": List<GetNotification>.from(list.map((x) => x.toJson()))
  };
}

class GetNotification { 

  GetNotification({
    this.message,
    this.date,
    this.status
  });

  String message;
  DateTime date;
  int status;

    factory GetNotification.fromJson(Map<String, dynamic> json) => GetNotification(
      message: json['message'],
      date: DateTime.parse(json["date"]),
      status: json["status"],
    );

    Map<String, dynamic> toJson() => {
      "message":message,
      "date":date,
      "status": status,
    };
}