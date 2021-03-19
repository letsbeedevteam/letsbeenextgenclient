import 'dart:convert';

EditAddressResponse editAddressResponseFromJson(String str) => EditAddressResponse.fromJson(json.decode(str));

class EditAddressResponse {
    EditAddressResponse({
        this.status,
        this.message,
    });

    String status;
    String message;

    factory EditAddressResponse.fromJson(Map<String, dynamic> json) => EditAddressResponse(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}