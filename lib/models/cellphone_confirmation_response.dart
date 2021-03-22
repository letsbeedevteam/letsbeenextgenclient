
import 'dart:convert';

CellphoneConfirmationResponse cellphoneConfirmationResponseFromJson(String str) => CellphoneConfirmationResponse.fromJson(json.decode(str));

class CellphoneConfirmationResponse {
  CellphoneConfirmationResponse({
    this.status,
    this.data,
    this.message,
    this.errorMessage
  });

  String status;
  String message;
  String errorMessage;
  CellphoneConfirmationData data;

  factory CellphoneConfirmationResponse.fromJson(Map<String, dynamic> json) => CellphoneConfirmationResponse(
    status: json['status'],
    message: json['message'] == null ? null : json['message'],
    errorMessage: json['error_message'] == null ? null : json['error_message'],
    data: json['data'] == null ? null : CellphoneConfirmationData.fromJson(json['data']),
  );
}

class CellphoneConfirmationData {
  CellphoneConfirmationData({
    this.id,
    this.name,
    this.email,
    this.cellphoneNumber,
    this.accessToken,
    this.address
  });

  int id;
  String name;
  String email;
  String cellphoneNumber;
  String accessToken;
  List<AddressData> address;

  factory CellphoneConfirmationData.fromJson(Map<String, dynamic> json) => CellphoneConfirmationData(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    cellphoneNumber: json['cellphone_number'],
    accessToken: json['access_token'],
    address: List<AddressData>.from(json["address"].map((x) => AddressData.fromJson(x))),

  );
}

class AddressData {
  AddressData({
    this.location,
    this.id,
    this.userId,
    this.name,
    this.address,
    this.note,
  });

  LocationData location;
  int id;
  int userId;
  String name;
  String address;
  String note;

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
    location: LocationData.fromJson(json['location']),
    id: json['id'],
    userId: json['userId'],
    name: json['name'],
    address: json["address"],
    note: json["note"],
  );
}

class LocationData {
  LocationData({
    this.lat,
    this.lng
  });

  double lat;
  double lng;

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
    lat: json['lat'],
    lng: json['lng']
  );
}