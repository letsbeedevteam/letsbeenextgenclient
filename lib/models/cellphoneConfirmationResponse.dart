
import 'dart:convert';

CellphoneConfirmationResponse cellphoneConfirmationResponseFromJson(String str) => CellphoneConfirmationResponse.fromJson(json.decode(str));

class CellphoneConfirmationResponse {
  CellphoneConfirmationResponse({
    this.status,
    this.data,
    this.message,
    this.code
  });

  int status;
  String message;
  int code;
  CellphoneConfirmationData data;

  factory CellphoneConfirmationResponse.fromJson(Map<String, dynamic> json) => CellphoneConfirmationResponse(
    status: json['status'],
    message: json['message'] == null ? null : json['message'],
    code: json['code'] == null ? null : json['code'],
    data: json['data'] == null ? null : CellphoneConfirmationData.fromJson(json['data'])
  );
}

class CellphoneConfirmationData {
  CellphoneConfirmationData({
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

  factory CellphoneConfirmationData.fromJson(Map<String, dynamic> json) => CellphoneConfirmationData(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    cellphoneNumber: json['cellphone_number'],
    accessToken: json['access_token']
  );
}