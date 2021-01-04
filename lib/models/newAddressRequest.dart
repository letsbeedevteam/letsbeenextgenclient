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
        this.country,
        this.state,
        this.city,
        this.barangay,
    });

    String name;
    AddressLocation location;
    String country;
    String state;
    String city;
    String barangay;

    factory NewAddressRequest.fromJson(Map<String, dynamic> json) => NewAddressRequest(
        name: json["name"],
        location: AddressLocation.fromJson(json["location"]),
        country: json["country"],
        state: json["state"],
        city: json["city"],
        barangay: json["barangay"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "location": location.toJson(),
        "country": country,
        "state": state,
        "city": city,
        "barangay": barangay,
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
