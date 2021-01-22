// To parse this JSON data, do
//
//     final facebook = facebookFromJson(jsonString);

import 'dart:convert';

SocialLoginResponse socialFromJson(String str) => SocialLoginResponse.fromJson(json.decode(str));

String socialToJson(SocialLoginResponse data) => json.encode(data.toJson());

class SocialLoginResponse {
    SocialLoginResponse({
        this.status,
        this.data,
    });

    int status;
    SocialData data;

    factory SocialLoginResponse.fromJson(Map<String, dynamic> json) => SocialLoginResponse(
        status: json["status"],
        data: SocialData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class SocialData {
    SocialData({
      this.id,
      this.name,
      this.email,
      this.accessToken,
      this.cellphoneNumber
    });

    int id;
    String name;
    String email;
    String accessToken;
    String cellphoneNumber;

    factory SocialData.fromJson(Map<String, dynamic> json) => SocialData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        accessToken: json["access_token"],
        cellphoneNumber: json["cellphone_number"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "access_token": accessToken,
        "cellphone_number": cellphoneNumber
    };
}
