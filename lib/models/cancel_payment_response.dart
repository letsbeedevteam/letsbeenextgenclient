// To parse this JSON data, do
//
//     final deleteCartResponse = deleteCartResponseFromJson(jsonString);

import 'dart:convert';

CancelPaymentResponse cancelPaymentResponseFromJson(String str) => CancelPaymentResponse.fromJson(json.decode(str));

String cancelPaymentResponseToJson(CancelPaymentResponse data) => json.encode(data.toJson());

class CancelPaymentResponse {
    CancelPaymentResponse({
      this.status,
      this.message,
      this.errorMessage
    });

    String status;
    String message;
    String errorMessage;

    factory CancelPaymentResponse.fromJson(Map<String, dynamic> json) => CancelPaymentResponse(
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
