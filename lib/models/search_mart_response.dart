// To parse this JSON data, do
//
//     final searchRestaurantResponse = searchRestaurantResponseFromJson(jsonString);

import 'dart:convert';

import 'package:letsbeeclient/models/mart_dashboard_response.dart';

SearchMartResponse searchMartResponseFromJson(String str) => SearchMartResponse.fromJson(json.decode(str));

String searchMartResponseToJson(SearchMartResponse data) => json.encode(data.toJson());

class SearchMartResponse {
    SearchMartResponse({
        this.status,
        this.data,
    });

    String status;
    List<MartStores> data;

    factory SearchMartResponse.fromJson(Map<String, dynamic> json) => SearchMartResponse(
        status: json["status"],
        data: List<MartStores>.from(json["data"].map((x) => MartStores.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}