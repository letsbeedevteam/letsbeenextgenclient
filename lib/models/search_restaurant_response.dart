// To parse this JSON data, do
//
//     final searchRestaurantResponse = searchRestaurantResponseFromJson(jsonString);

import 'dart:convert';

import 'package:letsbeeclient/models/restaurant_dashboard_response.dart';

SearchRestaurantResponse searchRestaurantResponseFromJson(String str) => SearchRestaurantResponse.fromJson(json.decode(str));

String searchRestaurantResponseToJson(SearchRestaurantResponse data) => json.encode(data.toJson());

class SearchRestaurantResponse {
    SearchRestaurantResponse({
        this.status,
        this.data,
    });

    int status;
    List<RestaurantStores> data;

    factory SearchRestaurantResponse.fromJson(Map<String, dynamic> json) => SearchRestaurantResponse(
        status: json["status"],
        data: List<RestaurantStores>.from(json["data"].map((x) => RestaurantStores.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}