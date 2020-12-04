// To parse this JSON data, do
//
//     final deleteCartResponse = deleteCartResponseFromJson(jsonString);

import 'dart:convert';

DeleteCartResponse deleteCartResponseFromJson(String str) => DeleteCartResponse.fromJson(json.decode(str));

String deleteCartResponseToJson(DeleteCartResponse data) => json.encode(data.toJson());

class DeleteCartResponse {
    DeleteCartResponse({
        this.status,
        this.message,
    });

    int status;
    String message;

    factory DeleteCartResponse.fromJson(Map<String, dynamic> json) => DeleteCartResponse(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
