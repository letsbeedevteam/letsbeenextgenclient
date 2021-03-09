import 'dart:convert';

ChangePasswordResponse changePasswordResponseFromJson(String str) => ChangePasswordResponse.fromJson(json.decode(str));

class ChangePasswordResponse {
  ChangePasswordResponse({
    this.message,
    this.status,
    this.code
  });

  String message;
  int status;
  int code;

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) => ChangePasswordResponse(
    status: json['status'],
    message: json['message'] == null ? null : json['message'],
    code: json['code'] == null ? null : json['code'],
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'code': code
  };
}