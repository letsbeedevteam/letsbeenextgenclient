class EditAddressRequest {
    EditAddressRequest({
        this.addressId,
        this.name,
        this.location,
        this.address,
        this.note
    });

    int addressId;
    String name;
    EditAddressLocation location;
    String address;
    String note;

    factory EditAddressRequest.fromJson(Map<String, dynamic> json) => EditAddressRequest(
        addressId: json["address_id"],
        name: json["name"],
        location: EditAddressLocation.fromJson(json["location"]),
        address: json["address"],
        note: json["note"],
    );

    Map<String, dynamic> toJson() => {
        "address_id": addressId,
        "name": name,
        "location": location.toJson(),
        "address": address,
        "note": note
    };
}

class EditAddressLocation {
    EditAddressLocation({
        this.lat,
        this.lng,
    });

    double lat;
    double lng;

    factory EditAddressLocation.fromJson(Map<String, dynamic> json) => EditAddressLocation(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
    };
}
