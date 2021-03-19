import 'dart:convert';

RequestForgotPassResponse requestForgotPassFromJson(String str) => RequestForgotPassResponse.fromJson(json.decode(str));

class RequestForgotPassResponse {
  RequestForgotPassResponse({
    this.status,
    this.message,
    this.data
  });

  String status;
  String message;
  RequestForgotPassData data;

  factory RequestForgotPassResponse.fromJson(Map<String, dynamic> json) => RequestForgotPassResponse(
    status: json["status"],
    message: json["message"],
    data: RequestForgotPassData.fromJson(json["data"])
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data
  };
}

class RequestForgotPassData {
  RequestForgotPassData({
    this.token
  });

  String token;

  factory RequestForgotPassData.fromJson(Map<String, dynamic> json) => RequestForgotPassData(
    token: json["token"]
  );

  Map<String, dynamic> toJson() => {
    "token": token
  };
}