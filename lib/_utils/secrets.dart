import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Secrets {

  final String nativeAppKey;
  final String googleMapKey;

  Secrets({this.nativeAppKey, this.googleMapKey});

  factory Secrets.fromJson(Map<String, dynamic> json) => Secrets(
    nativeAppKey: json['native_app_key'],
    googleMapKey: json['google_map_key']
  );
}


class SecretLoader {

  final String jsonPath;

  SecretLoader({this.jsonPath});

  Future<Secrets> loadKey() async {
    String data = await rootBundle.loadString(jsonPath);
    return Secrets.fromJson(json.decode(data));
  }
}