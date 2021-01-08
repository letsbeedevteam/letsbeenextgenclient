
import 'dart:convert';

String chatResponseToJson(ChatResponse data) => json.encode(data.toJson());

class ChatResponse {

  ChatResponse({
    this.status,
    this.data
  });

  int status;
  List<ChatData> data;
  
  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
      status: json["status"],
      data: json["data"] == null ? List<ChatData>() : List<ChatData>.from(json["data"].map((x) => ChatData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<ChatData>.from(data.map((x) => x)),
  };
}

class ChatData {

  ChatData({
    this.id,
    this.orderId,
    this.userId,
    this.message,
    this.createdAt,
    this.isSent
  });

  int id;
  int orderId;
  int userId;
  String message;
  DateTime createdAt;
  bool isSent;

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
    id: json["id"],
    orderId: json["order_id"],
    userId: json["user_id"],
    message: json["message"],
    createdAt: DateTime.parse(json["createdAt"]),
    isSent: true
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    // "updatedAt": updatedAt,
    "createdAt": createdAt,
    "user_id": userId,
    "message": message
  };
}