import 'dart:convert';

NumberResponse numberResponseFromJson(String str) => NumberResponse.fromJson(json.decode(str));

String numberResopnseToJson(NumberResponse data) => json.encode(data.toJson());

class NumberResponse {

  NumberResponse({
    this.message,
    this.status
  });

  String message;
  int status;

  factory NumberResponse.fromJson(Map<String, dynamic> json) => NumberResponse(
    message: json["message"],
    status: json["status"]
  );

  Map<String, dynamic> toJson() => {
      "status": status,
      "message": message,
  };
}