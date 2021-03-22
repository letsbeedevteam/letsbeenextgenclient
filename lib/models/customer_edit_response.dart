// To parse this JSON data, do
//
//     final customerEditResponse = customerEditResponseFromJson(jsonString);

import 'dart:convert';

CustomerEditResponse customerEditResponseFromJson(String str) => CustomerEditResponse.fromJson(json.decode(str));

String customerEditResponseToJson(CustomerEditResponse data) => json.encode(data.toJson());

class CustomerEditResponse {
    CustomerEditResponse({
        this.status,
        this.data,
        this.message,
        this.errorMessage
    });

    String status;
    Data data;
    String message;
    String errorMessage;

    factory CustomerEditResponse.fromJson(Map<String, dynamic> json) => CustomerEditResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
        errorMessage: json["code"] == null || json["code"] == '' ? null : json["code"]
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
    };
}

class Data {
    Data({
        this.name,
        this.email,
        this.cellphoneNumber,
    });

    String name;
    String email;
    String cellphoneNumber;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        email: json["email"],
        cellphoneNumber: json["cellphone_number"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "cellphone_number": cellphoneNumber,
    };
}
