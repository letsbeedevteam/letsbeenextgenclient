import 'dart:convert';

NumberResponse numberResponseFromJson(String str) => NumberResponse.fromJson(json.decode(str));

String numberResopnseToJson(NumberResponse data) => json.encode(data.toJson());

class NumberResponse {

  NumberResponse({
    this.message,
    this.status,
    this.data,
    this.errorMessage,
  });

  dynamic message;
  String status;
  String errorMessage;
  NumberData data;

  factory NumberResponse.fromJson(Map<String, dynamic> json) => NumberResponse(
    message: json['message'] == null || json['message'] == '' ? null : json['message'],
    status: json["status"],
    errorMessage: json["error_message"] == null || json["error_message"] == ""  ? null : json["error_message"],
    data: json["data"] == null || json["data"] == "" ? null :  NumberData.fromJson(json['data']) 
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "error_message": errorMessage,
    "data": data
  };
}

class NumberData {
  NumberData({
    this.token,
    this.sentConfirmation,
    this.cellphoneNumber,
  });

  String token;
  bool sentConfirmation;
  String cellphoneNumber;

  factory NumberData.fromJson(Map<String, dynamic> json) => NumberData(
    token: json['token'],
    sentConfirmation: json['sent_confirmation'],
    cellphoneNumber: json['cellphone_number']
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'sent_confirmation': sentConfirmation,
    'cellphone_number': cellphoneNumber
  };
}