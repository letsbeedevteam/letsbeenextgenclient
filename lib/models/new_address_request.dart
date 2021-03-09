// To parse this JSON data, do
//
//     final newAddressRequest = newAddressRequestFromJson(jsonString);

import 'dart:convert';

NewAddressRequest newAddressRequestFromJson(String str) => NewAddressRequest.fromJson(json.decode(str));

String newAddressRequestToJson(NewAddressRequest data) => json.encode(data.toJson());

class NewAddressRequest {
    NewAddressRequest({
        this.name,
        this.location,
        this.address,
        this.note
    });

    String name;
    AddressLocation location;
    String address;
    String note;

    factory NewAddressRequest.fromJson(Map<String, dynamic> json) => NewAddressRequest(
        name: json["name"],
        location: AddressLocation.fromJson(json["location"]),
        address: json["address"],
        note: json["note"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "location": location.toJson(),
        "address": address,
        "note": note
    };
}

class AddressLocation {
    AddressLocation({
        this.lat,
        this.lng,
    });

    double lat;
    double lng;

    factory AddressLocation.fromJson(Map<String, dynamic> json) => AddressLocation(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
    };
}
