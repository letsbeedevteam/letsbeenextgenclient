// To parse this JSON data, do
//
//     final deleteCartResponse = deleteCartResponseFromJson(jsonString);

import 'dart:convert';

CancelOrderResponse cancelOrderResponseFromJson(String str) => CancelOrderResponse.fromJson(json.decode(str));

String cancelOrderResponseToJson(CancelOrderResponse data) => json.encode(data.toJson());

class CancelOrderResponse {
    CancelOrderResponse({
      this.status,
      this.message,
      this.errorMessage
    });

    String status;
    String message;
    String errorMessage;

    factory CancelOrderResponse.fromJson(Map<String, dynamic> json) => CancelOrderResponse(
        status: json["status"],
        message: json["message"],
        errorMessage: json["error_message"]
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "error_message": errorMessage
    };
}
