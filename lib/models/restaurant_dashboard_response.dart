
import 'dart:convert';

RestaurantDashboardResponse restaurantDashboardFromJson(String str) => RestaurantDashboardResponse.fromJson(json.decode(str));

String restaurantDashboardToJson(RestaurantDashboardResponse data) => json.encode(data.toJson());

class RestaurantDashboardResponse {
  RestaurantDashboardResponse({
    this.status,
    this.data
  });

  int status;
  RestaurantData data;

  factory RestaurantDashboardResponse.fromJson(Map<String, dynamic> json) => RestaurantDashboardResponse(
      status: json["status"] == null ? 0 : json["status"],
      data: RestaurantData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
      "status": status,
      "data": data.toJson(),
  };
}

class RestaurantData {
  RestaurantData({
    this.stores,
    this.recentStores
  });

  List<RestaurantStores> stores;
  List<RestaurantStores> recentStores;

  factory RestaurantData.fromJson(Map<String, dynamic> json) => RestaurantData(
    stores: json["stores"] == null ? List<RestaurantStores>() : List<RestaurantStores>.from(json["stores"].map((x) => RestaurantStores.fromJson(x))),
    recentStores: json["recent_stores"] == null ? List<RestaurantStores>() : List<RestaurantStores>.from(json["recent_stores"].map((store) => RestaurantStores.fromJson(store))),
  );

  Map<String, dynamic> toJson() => {
      "stores": List<RestaurantStores>.from(stores.map((store) => store.toJson())),
      "recent_stores": List<RestaurantStores>.from(stores.map((store) => store.toJson())),
  };
}

class RestaurantStores {
  RestaurantStores({
    this.id,
    this.name,
    this.description,
    this.location,
    this.status,
    this.type,
    this.category,
    this.logoUrl,
    this.photoUrl,
    this.distance,
    this.address
  });

  int id;
  String name;
  String description;
  RestaurantLocation location;
  String status;
  String type;
  String category;
  String logoUrl;
  String photoUrl;
  double distance;
  RestaurantAddress address;

  factory RestaurantStores.fromJson(Map<String, dynamic> json) => RestaurantStores(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    location: RestaurantLocation.fromJson(json["location"]),
    status: json["status"],
    type: json["type"],
    category: json["category"],
    logoUrl: json["logo_url"],
    photoUrl: json["photo_url"],
    distance: json["distance"],
   address: RestaurantAddress.fromJson(json["address"])
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "location": location.toJson(),
    "status": status,
    "type": type,
    "category": category,
    "logo_url": logoUrl,
    "photo_url": photoUrl,
    "distance": distance,
    "address": address.toJson()
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

class RestaurantAddress {
  RestaurantAddress({
    this.country,
    this.state,
    this.city,
    this.barangay
  });

  String country;
  String state;
  String city;
  String barangay;

  factory RestaurantAddress.fromJson(Map<String, dynamic> json) => RestaurantAddress(
    country: json["country"],
    state: json["lng"],
    city: json["city"],
    barangay: json["barangay"]
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "state": state,
    "city": city,
    "barangay": barangay
  };
}
