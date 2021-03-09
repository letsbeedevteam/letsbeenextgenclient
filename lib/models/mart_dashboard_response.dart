
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
    // this.recentStores
  });

  List<MartStores> stores;
  // List<MartStores> recentStores;

  factory MartData.fromJson(Map<String, dynamic> json) => MartData(
    stores: json["stores"] == null ? List<MartStores>() : List<MartStores>.from(json["stores"].map((x) => MartStores.fromJson(x))),
    // recentStores: json["recent_stores"] == null ? List<MartStores>() : List<MartStores>.from(json["recent_stores"].map((store) => MartStores.fromJson(store))),
  );

  Map<String, dynamic> toJson() => {
    "stores": List<MartStores>.from(stores.map((store) => store.toJson())),
    // "recent_stores": List<MartStores>.from(stores.map((store) => store.toJson())),
  };
}

class MartStores {
  MartStores({
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
  MartLocation location;
  String status;
  String type;
  String category;
  String logoUrl;
  String photoUrl;
  double distance;
  MartAddress address;

  factory MartStores.fromJson(Map<String, dynamic> json) => MartStores(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    location: MartLocation.fromJson(json["location"]),
    status: json["status"],
    type: json["type"],
    category: json["category"],
    logoUrl: json["logo_url"],
    photoUrl: json["photo_url"],
    distance: json["distance"],
    address: MartAddress.fromJson(json["address"])
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

class MartLocation {
  MartLocation({
    this.lat,
    this.lng,
    this.name
  });

  double lat;
  double lng;
  String name;

  factory MartLocation.fromJson(Map<String, dynamic> json) => MartLocation(
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

class MartAddress {
  MartAddress({
    this.country,
    this.state,
    this.city,
    this.barangay
  });

  String country;
  String state;
  String city;
  String barangay;

  factory MartAddress.fromJson(Map<String, dynamic> json) => MartAddress(
    country: json["country"],
    state: json["state"],
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

