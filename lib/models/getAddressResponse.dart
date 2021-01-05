// To parse this JSON data, do
//
//     final getAllAddressResponse = getAllAddressResponseFromJson(jsonString);

import 'dart:convert';

GetAllAddressResponse getAllAddressResponseFromJson(String str) => GetAllAddressResponse.fromJson(json.decode(str));

String getAllAddressResponseToJson(GetAllAddressResponse data) => json.encode(data.toJson());

class GetAllAddressResponse {
    GetAllAddressResponse({
        this.status,
        this.data,
    });

    int status;
    List<AddressData> data;

    factory GetAllAddressResponse.fromJson(Map<String, dynamic> json) => GetAllAddressResponse(
        status: json["status"],
        data: List<AddressData>.from(json["data"].map((x) => AddressData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class AddressData {
    AddressData({
        this.location,
        this.id,
        this.userId,
        this.name,
        this.country,
        this.state,
        this.city,
        this.barangay,
        this.street,
        this.isoCode,
    });

    Location location;
    int id;
    int userId;
    String name;
    String country;
    String state;
    String city;
    String barangay;
    String street;
    String isoCode;

    factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
        location: Location.fromJson(json["location"]),
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        barangay: json["barangay"],
        street: json["street"],
        isoCode: json["iso_code"],
    );

    Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "id": id,
        "user_id": userId,
        "name": name,
        "country": country,
        "state": state,
        "city": city,
        "barangay": barangay,
        "street": street,
        "iso_code": isoCode,
    };
}

class Location {
    Location({
        this.lat,
        this.lng,
    });

    double lat;
    double lng;

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
    };
}
