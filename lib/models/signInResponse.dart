import 'dart:convert';

SignInResponse signInResponseFromJson(String str) => SignInResponse.fromJson(json.decode(str));

class SignInResponse {
  SignInResponse({
    this.status,
    this.data,
    this.message,
    this.code
  });

  int status;
  SignInData data;
  dynamic message;
  int code;

  factory SignInResponse.fromJson(Map<String, dynamic> json) => SignInResponse(
    status: json['status'],
    data: json['data'] == null ? null : SignInData.fromJson(json['data']),
    message: json['message'] == null || json['message'] == '' ? null : json['message'],
    code: json['code'] == null || json['code'] == '' ? null : json['code']
  );
}

class SignInData {
  SignInData({
    this.token,
    this.cellphoneNumber
  });

  String token;
  bool sentConfirmation;
  String cellphoneNumber;

  factory SignInData.fromJson(Map<String, dynamic> json) => SignInData(
    token: json['token'],
    cellphoneNumber: json['cellphone_number']
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'cellphone_number': cellphoneNumber
  };
}