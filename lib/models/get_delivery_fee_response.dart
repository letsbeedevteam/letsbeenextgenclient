import 'dart:convert';

GetDeliveryFeeResponse getDeliveryFeeFromJson(String str) => GetDeliveryFeeResponse.fromJson(json.decode(str));

String getDeliveryFeeToJson(GetDeliveryFeeResponse data) => json.encode(data.toJson());

class GetDeliveryFeeResponse { 
  GetDeliveryFeeResponse({
    this.status,
    this.data,
    this.message
  });

  int status;
  DeliveryFeeData data;
  String message;

  factory GetDeliveryFeeResponse.fromJson(Map<String, dynamic> json) => GetDeliveryFeeResponse(
    status: json["status"],
    data: DeliveryFeeData.fromJson(json["data"]),
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
    "message": message
  };
}

class DeliveryFeeData {
  DeliveryFeeData({
    this.deliveryFee
  });

  String deliveryFee;

  factory DeliveryFeeData.fromJson(Map<String, dynamic> json) => DeliveryFeeData(
    deliveryFee: json["delivery_fee"]
  );

  Map<String, dynamic> toJson() => {
    "delivery_fee": deliveryFee
  };
}