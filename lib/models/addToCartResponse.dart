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
        this.code
    });

    int status;
    String message;
    int code;

    factory AddToCartResponse.fromJson(Map<String, dynamic> json) => AddToCartResponse(
        status: json["status"],
        message: json["message"],
        code: json["code"]
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code
    };
}
