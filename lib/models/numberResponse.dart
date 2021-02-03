import 'dart:convert';

NumberResponse numberResponseFromJson(String str) => NumberResponse.fromJson(json.decode(str));

String numberResopnseToJson(NumberResponse data) => json.encode(data.toJson());

class NumberResponse {

  NumberResponse({
    this.message,
    this.status,
    this.data
  });

  int message;
  int status;
  NumberData data;

  factory NumberResponse.fromJson(Map<String, dynamic> json) => NumberResponse(
    message: json['message'] == null || json['message'] == '' ? null : json['message'],
    status: json["status"],
    data: NumberData.fromJson(json['data'])
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data
  };
}

class NumberData {
  NumberData({
    this.token,
    this.sentConfirmation
  });

  String token;
  bool sentConfirmation;

  factory NumberData.fromJson(Map<String, dynamic> json) => NumberData(
    token: json['token'],
    sentConfirmation: json['sent_confirmation']
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'sent_confirmation': sentConfirmation
  };
}