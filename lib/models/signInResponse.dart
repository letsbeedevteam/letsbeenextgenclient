import 'dart:convert';

SignInResponse signInResponseFromJson(String str) => SignInResponse.fromJson(json.decode(str));

class SignInResponse {
  SignInResponse({
    this.status,
    this.data,
    this.message
  });

  int status;
  SignInData data;
  int message;

  factory SignInResponse.fromJson(Map<String, dynamic> json) => SignInResponse(
    status: json['status'],
    data: json['data'] == null ? null : SignInData.fromJson(json['data']),
    message: json['message'] == null || json['message'] == '' ? null : json['message'],
  );
}

class SignInData {
  SignInData({
    this.token,
    this.sentConfirmation
  });

  String token;
  bool sentConfirmation;

  factory SignInData.fromJson(Map<String, dynamic> json) => SignInData(
    token: json['token'],
    sentConfirmation: json['sent_confirmation']
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'sent_confirmation': sentConfirmation
  };
}