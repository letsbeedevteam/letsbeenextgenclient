import 'dart:convert';

class RefreshTokenResponse {

  RefreshTokenResponse({
    this.status,
    this.data,
    this.errorMessage
  });

  String status;
  RefreshTokenData data;
  String errorMessage;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) => RefreshTokenResponse(
      status: json["status"],
      data:json["data"] == null ? RefreshTokenData() : RefreshTokenData.fromJson(json["data"]),
      errorMessage: json["error_message"] == null ? null : json["error_message"]
  );

}

class RefreshTokenData{

  RefreshTokenData({
    this.accessToken,
  });

  String accessToken;

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) => RefreshTokenData(
      accessToken: json["access_token"] == null ? "" : json["access_token"],
  );
}

RefreshTokenResponse refreshTokenFromJson(String str) => RefreshTokenResponse.fromJson(json.decode(str));