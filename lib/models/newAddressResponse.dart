// To parse this JSON data, do
//
//     final newAddressResponse = newAddressResponseFromJson(jsonString);

import 'dart:convert';

NewAddressResponse newAddressResponseFromJson(String str) => NewAddressResponse.fromJson(json.decode(str));

String newAddressResponseToJson(NewAddressResponse data) => json.encode(data.toJson());

class NewAddressResponse {
    NewAddressResponse({
        this.status,
        this.data,
        this.message,
    });

    int status;
    Data data;
    String message;

    factory NewAddressResponse.fromJson(Map<String, dynamic> json) => NewAddressResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
    };
}

class Data {
    Data({
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
        this.createdAt,
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
    DateTime createdAt;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        createdAt: DateTime.parse(json["createdAt"]),
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
        "createdAt": createdAt.toIso8601String(),
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
