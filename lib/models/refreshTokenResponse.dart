import 'dart:convert';

class RefreshTokenResponse {

  RefreshTokenResponse({
    this.status,
    this.data
  });

  int status;
  RefreshTokenData data;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) => RefreshTokenResponse(
      status: json["status"],
      data:json["data"] == null ? RefreshTokenData() : RefreshTokenData.fromJson(json["data"]),
  );

}

class RefreshTokenData{

  RefreshTokenData({
    this.accessToken,
    this.refreshToken
  });

  String accessToken;
  String refreshToken;

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) => RefreshTokenData(
      accessToken: json["access_token"] == null ? "" : json["access_token"],
      refreshToken: json["refresh_token"] == null ? "" : json["refresh_token"],
  );
}

RefreshTokenResponse refreshTokenFromJson(String str) => RefreshTokenResponse.fromJson(json.decode(str));