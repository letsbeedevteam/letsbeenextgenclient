import 'dart:convert';

List<SearchHistory> searchHistoryFromJson(String str) => List<SearchHistory>.from(json.decode(str).map((x) => SearchHistory.fromJson(x)));

String searchHistoryToJson(List<SearchHistory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchHistory {
  SearchHistory({
    this.name,
    this.type,
    this.date
  });

  String name;
  String type;
  DateTime date;

  factory SearchHistory.fromJson(Map<String, dynamic> json) => SearchHistory(
    name: json["name"],
    type: json["type"],
    date: DateTime.parse(json["date"])
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "name": name,
    "date": date.toIso8601String()
  };
}