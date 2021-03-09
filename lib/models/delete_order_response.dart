// To parse this JSON data, do
//
//     final deleteCartResponse = deleteCartResponseFromJson(jsonString);

import 'dart:convert';

DeleteOrderResponse deleteOrderResponseFromJson(String str) => DeleteOrderResponse.fromJson(json.decode(str));

String deleteOrderResponseToJson(DeleteOrderResponse data) => json.encode(data.toJson());

class DeleteOrderResponse {
    DeleteOrderResponse({
        this.status,
        this.message,
    });

    int status;
    String message;

    factory DeleteOrderResponse.fromJson(Map<String, dynamic> json) => DeleteOrderResponse(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
