
import 'dart:convert';

CellphoneConfirmationResponse cellphoneConfirmationResponseFromJson(String str) => CellphoneConfirmationResponse.fromJson(json.decode(str));

class CellphoneConfirmationResponse {
  CellphoneConfirmationResponse({
    this.status,
    this.data,
    this.message,
    this.code,
  });

  int status;
  String message;
  int code;
  CellphoneConfirmationData data;

  factory CellphoneConfirmationResponse.fromJson(Map<String, dynamic> json) => CellphoneConfirmationResponse(
    status: json['status'],
    message: json['message'] == null ? null : json['message'],
    code: json['code'] == null ? null : json['code'],
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
    this.name,
    this.country,
    this.state,
    this.city,
    this.barangay,
    this.street,
    this.isoCode
  });

  LocationData location;
  String name;
  String country;
  String state;
  String city;
  String barangay;
  String street;
  String isoCode;

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
    location: LocationData.fromJson(json['location']),
    name: json['name'],
    country: json['country'],
    state: json['state'],
    city: json['city'],
    barangay: json['barangay'],
    street: json['street'],
    isoCode: json['isoCode'],
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