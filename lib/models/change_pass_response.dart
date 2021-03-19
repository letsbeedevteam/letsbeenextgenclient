import 'dart:convert';

ChangePasswordResponse changePasswordResponseFromJson(String str) => ChangePasswordResponse.fromJson(json.decode(str));

class ChangePasswordResponse {
  ChangePasswordResponse({
    this.message,
    this.status,
  });

  String message;
  String status;

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) => ChangePasswordResponse(
    status: json['status'],
    message: json['message'] == null ? null : json['message'],
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
  };
}