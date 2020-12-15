
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
      data: json["data"] == null ? List<ChatData>() : List<ChatData>.from(json["data"].map((x) => x.toJson())),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}

class ChatData {

  ChatData({
    this.id
  });

  int id;

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
    id: json["id"] == null ? 0 : json["id"]
  );

  Map<String, dynamic> toJson() => {
    "id": id
  };
}