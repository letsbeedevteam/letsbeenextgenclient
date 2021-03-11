import 'dart:convert';

SignUpResponse signUpResponseFromJson(String str) => SignUpResponse.fromJson(json.decode(str));

class SignUpResponse {
  SignUpResponse({
    this.status,
    this.message,
    this.data
  });

  int status;
  String message;
  SignUpData data;

  factory SignUpResponse.fromJson(Map<String, dynamic> json) => SignUpResponse(
    status: json['status'],
    message: json['message'],
    data: SignUpData.fromJson(json['data'])
  );
}

class SignUpData {
  SignUpData({
    this.token
  });

  String token;

  factory SignUpData.fromJson(Map<String, dynamic> json) => SignUpData(
    token: json['token'],
  );
}