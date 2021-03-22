import 'dart:convert';

SignInResponse signInResponseFromJson(String str) => SignInResponse.fromJson(json.decode(str));

class SignInResponse {
  SignInResponse({
    this.status,
    this.data,
    this.message,
    this.errorMessage
  });

  String status;
  SignInData data;
  dynamic message;
  String errorMessage;

  factory SignInResponse.fromJson(Map<String, dynamic> json) => SignInResponse(
    status: json['status'],
    data: json['data'] == null ? null : SignInData.fromJson(json['data']),
    message: json['message'] == null || json['message'] == '' ? null : json['message'],
    errorMessage: json['error_message'] == null || json['error_message'] == '' ? null : json['error_message']
  );
}

class SignInData {
  SignInData({
    this.token,
    this.cellphoneNumber
  });

  String token;
  String cellphoneNumber;

  factory SignInData.fromJson(Map<String, dynamic> json) => SignInData(
    token: json['token'],
    cellphoneNumber: json['cellphone_number'] == '0' ? null : json['cellphone_number']
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'cellphone_number': cellphoneNumber
  };
}