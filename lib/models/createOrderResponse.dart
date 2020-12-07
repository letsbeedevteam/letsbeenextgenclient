// To parse this JSON data, do
//
//     final createOrderResponse = createOrderResponseFromJson(jsonString);

import 'dart:convert';

CreateOrderResponse createOrderResponseFromJson(String str) => CreateOrderResponse.fromJson(json.decode(str));

String createOrderResponseToJson(CreateOrderResponse data) => json.encode(data.toJson());

class CreateOrderResponse {
    CreateOrderResponse({
      this.status,
      this.paymentUrl,
    });

    int status;
    String paymentUrl;

    factory CreateOrderResponse.fromJson(Map<String, dynamic> json) => CreateOrderResponse(
        status: json["status"],
        paymentUrl: json["payment_url"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "payment_url": paymentUrl,
    };
}