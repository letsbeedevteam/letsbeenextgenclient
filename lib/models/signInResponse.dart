import 'dart:convert';

SignInResponse signInResponseFromJson(String str) => SignInResponse.fromJson(json.decode(str));

class SignInResponse {
  SignInResponse({
    this.status,
    this.data,
    this.message
  });

  int status;
  String message;
  SignInData data;

  factory SignInResponse.fromJson(Map<String, dynamic> json) => SignInResponse(
    status: json['status'],
    message: json['message'] == null ? null : json['message'],
    data: json['data'] == null ? null : SignInData.fromJson(json['data'])
  );
}

class SignInData {
  SignInData({
    this.id,
    this.name,
    this.email,
    this.cellphoneNumber,
    this.accessToken
  });

  int id;
  String name;
  String email;
  String cellphoneNumber;
  String accessToken;

  factory SignInData.fromJson(Map<String, dynamic> json) => SignInData(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    cellphoneNumber: json['cellphone_number'],
    accessToken: json['access_token']
  );
}