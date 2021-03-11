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
        this.address,
        this.note,
        this.createdAt,
        this.isSelected
    });

    Location location;
    int id;
    int userId;
    String name;
    String address;
    String note;
    String createdAt;
    bool isSelected;

    factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
        location: Location.fromJson(json["location"]),
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        address: json["address"],
        note: json["note"],
        createdAt: json["createdAt"],
        isSelected: false
    );

    Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "id": id,
        "user_id": userId,
        "name": name,
        "address": address,
        "note": note,
        "createdAt": createdAt
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
