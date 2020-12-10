// To parse this JSON data, do
//
//     final createOrderResponse = createOrderResponseFromJson(jsonString);

import 'dart:convert';

CreateOrderResponse createOrderResponseFromJson(String str) => CreateOrderResponse.fromJson(json.decode(str));

String createOrderResponseToJson(CreateOrderResponse data) => json.encode(data.toJson());

class CreateOrderResponse {
    CreateOrderResponse({
      this.status,
      this.data,
      this.paymentUrl,
      this.code
    });

    int status;
    String paymentUrl;
    RestaurantData data;
    int code;

    factory CreateOrderResponse.fromJson(Map<String, dynamic> json) => CreateOrderResponse(
        status: json["status"],
        data: json["data"] == null ? RestaurantData(id: 0) : RestaurantData.fromJson(json["data"]),
        paymentUrl: json["payment_url"],
        code: json["code"]
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data,
        "payment_url": paymentUrl,
        "code": code
    };
}

class RestaurantData {
  RestaurantData({
    this.id,
  });

  int id;

  factory RestaurantData.fromJson(Map<String, dynamic> json) => RestaurantData(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}