// To parse this JSON data, do
//
//     final addToCartResponse = addToCartResponseFromJson(jsonString);

import 'dart:convert';

AddToCartResponse addToCartResponseFromJson(String str) => AddToCartResponse.fromJson(json.decode(str));

String addToCartResponseToJson(AddToCartResponse data) => json.encode(data.toJson());

class AddToCartResponse {
    AddToCartResponse({
        this.status,
        this.message,
    });

    int status;
    String message;

    factory AddToCartResponse.fromJson(Map<String, dynamic> json) => AddToCartResponse(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
