
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
      "stores": List<dynamic>.from(stores.map((store) => store.toJson())),
      "recent_stores": List<dynamic>.from(stores.map((store) => store.toJson())),
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
    this.address,
    this.workingDays,
    this.stature
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
  RestaurantWorkingDays workingDays;
  String stature;

  factory RestaurantStores.fromJson(Map<String, dynamic> json) => RestaurantStores(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    location: RestaurantLocation.fromJson(json["location"]),
    status: json["status"],
    type: json["type"],
    category: json["category"],
    logoUrl: json["logo_url"],
    photoUrl: json["photo_url"] == null ? '' : json["photo_url"],
    distance: json["distance"],
    address: RestaurantAddress.fromJson(json["address"]),
    workingDays: json["working_days"] == null ? null : RestaurantWorkingDays.fromJson(json["working_days"]),
    stature: json["stature"]
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
    "address": address.toJson(),
    "working_days": workingDays == null ? null : workingDays.toJson(),
    "stature": stature
  };
}

class RestaurantLocation {
  RestaurantLocation({
    this.lat,
    this.lng,
    this.name
  });

  dynamic lat;
  dynamic lng;
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

class RestaurantWorkingDays {
    RestaurantWorkingDays({
        this.sunday,
        this.monday,
        this.tuesday,
        this.wednesday,
        this.thursday,
        this.friday,
        this.saturday,
    });

    RestaurantDay sunday;
    RestaurantDay monday;
    RestaurantDay tuesday;
    RestaurantDay wednesday;
    RestaurantDay thursday;
    RestaurantDay friday;
    RestaurantDay saturday;

    factory RestaurantWorkingDays.fromJson(Map<String, dynamic> json) => RestaurantWorkingDays(
      sunday: RestaurantDay.fromJson(json["sunday"]),
      monday: RestaurantDay.fromJson(json["monday"]),
      tuesday: RestaurantDay.fromJson(json["tuesday"]),
      wednesday: RestaurantDay.fromJson(json["wednesday"]),
      thursday: RestaurantDay.fromJson(json["thursday"]),
      friday: RestaurantDay.fromJson(json["friday"]),
      saturday: RestaurantDay.fromJson(json["saturday"]),
    );

    Map<String, dynamic> toJson() => {
      "sunday": sunday.toJson(),
      "monday": monday.toJson(),
      "tuesday": tuesday.toJson(),
      "wednesday": wednesday.toJson(),
      "thursday": thursday.toJson(),
      "friday": friday.toJson(),
      "saturday": saturday.toJson(),
    };
}

class RestaurantDay {
    RestaurantDay({
        this.status,
        this.openingTime,
        this.closingTime,
    });

    bool status;
    String openingTime;
    String closingTime;

    factory RestaurantDay.fromJson(Map<String, dynamic> json) => RestaurantDay(
        status: json["status"],
        openingTime: json["opening_time"],
        closingTime: json["closing_time"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "opening_time": openingTime,
        "closing_time": closingTime,
    };
}

