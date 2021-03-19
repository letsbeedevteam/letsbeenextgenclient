import 'dart:convert';

ForgotPassResponse forgotPassFromJson(String str) => ForgotPassResponse.fromJson(json.decode(str));

class ForgotPassResponse {
  ForgotPassResponse({
    this.status,
    this.message
  });

  String status;
  String message;

  factory ForgotPassResponse.fromJson(Map<String, dynamic> json) => ForgotPassResponse(
    status: json["status"],
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message
  };
}