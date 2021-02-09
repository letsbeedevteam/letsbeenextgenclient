
import 'dart:convert';

MartDashboardResponse martDashboardFromJson(String str) => MartDashboardResponse.fromJson(json.decode(str));

String martDashboardToJson(MartDashboardResponse data) => json.encode(data.toJson());

class MartDashboardResponse {
  MartDashboardResponse({
    this.status,
    this.data
  });

  int status;
  MartData data;

  factory MartDashboardResponse.fromJson(Map<String, dynamic> json) => MartDashboardResponse(
      status: json["status"] == null ? 0 : json["status"],
      data: MartData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
      "status": status,
      "data": data.toJson(),
  };
}

class MartData {
  MartData({
    this.stores,
    this.recentStores
  });

  List<MartStores> stores;
  List<MartStores> recentStores;

  factory MartData.fromJson(Map<String, dynamic> json) => MartData(
    stores: json["stores"] == null ? List<MartStores>() : List<MartStores>.from(json["stores"].map((x) => MartStores.fromJson(x))),
    recentStores: json["recent_stores"] == null ? List<MartStores>() : List<MartStores>.from(json["recent_stores"].map((store) => MartStores.fromJson(store))),
  );

  Map<String, dynamic> toJson() => {
      "stores": List<MartStores>.from(stores.map((store) => store.toJson())),
      "recent_stores": List<MartStores>.from(stores.map((store) => store.toJson())),
  };
}

class MartStores {
  MartStores({
    this.id,
    this.name,
    this.description,
    this.location,
    this.logoUrl,
    this.photoUrl,
    this.status,
    this.category,
    this.type
  });

  int id;
  String name;
  String description;
  RestaurantLocation location;
  String logoUrl;
  String photoUrl;
  String status;
  String category;
  String type;

  factory MartStores.fromJson(Map<String, dynamic> json) => MartStores(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    location: RestaurantLocation.fromJson(json["location"]),
    logoUrl: json["logo_url"],
    photoUrl: json["photo_url"],
    status: json["status"],
    category: json["category"],
    type: json["type"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "location": location.toJson()
  };
}

class RestaurantLocation {
  RestaurantLocation({
    this.lat,
    this.lng,
    this.name
  });

  double lat;
  double lng;
  String name;

  factory RestaurantLocation.fromJson(Map<String, dynamic> json) => RestaurantLocation(
    lat: json["lat"],
    lng: json["lng"],
    name: json["name"]
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
    "name": name,
  };
}
