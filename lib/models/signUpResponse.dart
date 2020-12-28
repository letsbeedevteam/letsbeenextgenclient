import 'dart:convert';

SignUpResponse signUpResponseFromJson(String str) => SignUpResponse.fromJson(json.decode(str));

class SignUpResponse {
  SignUpResponse({
    this.status,
    this.message
  });

  int status;
  String message;

  factory SignUpResponse.fromJson(Map<String, dynamic> json) => SignUpResponse(
    status: json['status'],
    message: json['message']
  );
}