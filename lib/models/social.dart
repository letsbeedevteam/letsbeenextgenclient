// To parse this JSON data, do
//
//     final facebook = facebookFromJson(jsonString);

import 'dart:convert';

Social facebookFromJson(String str) => Social.fromJson(json.decode(str));

String facebookToJson(Social data) => json.encode(data.toJson());

class Social {
    Social({
        this.status,
        this.data,
    });

    int status;
    SocialData data;

    factory Social.fromJson(Map<String, dynamic> json) => Social(
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
        this.refreshToken
    });

    int id;
    String name;
    String email;
    String accessToken;
    String refreshToken;

    factory SocialData.fromJson(Map<String, dynamic> json) => SocialData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "access_token": accessToken,
        "refresh_token": refreshToken
    };
}
