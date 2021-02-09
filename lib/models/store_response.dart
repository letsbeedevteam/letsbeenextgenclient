// To parse this JSON data, do
//
//     final storeResponse = storeResponseFromJson(jsonString);

import 'dart:convert';

StoreResponse storeResponseFromJson(String str) => StoreResponse.fromJson(json.decode(str));

String storeResponseToJson(StoreResponse data) => json.encode(data.toJson());

class StoreResponse {
  StoreResponse({
    this.status,
    this.data,
  });

  int status;
  Data data;

  factory StoreResponse.fromJson(Map<String, dynamic> json) => StoreResponse(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.name,
    this.location,
    this.status,
    this.type,
    this.category,
    this.logoUrl,
    this.photoUrl,
    this.address,
    this.categorized,
  });

  int id;
  String name;
  Location location;
  String status;
  String type;
  String category;
  String logoUrl;
  String photoUrl;
  Address address;
  List<Categorized> categorized;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    location: Location.fromJson(json["location"]),
    status: json["status"],
    type: json["type"],
    category: json["category"],
    logoUrl: json["logo_url"],
    photoUrl: json["photo_url"],
    address: Address.fromJson(json["address"]),
    categorized: List<Categorized>.from(json["categorized"].map((x) => Categorized.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location": location.toJson(),
    "status": status,
    "type": type,
    "category": category,
    "logo_url": logoUrl,
    "photo_url": photoUrl,
    "address": address.toJson(),
    "categorized": List<dynamic>.from(categorized.map((x) => x.toJson())),
  };
}

class Address {
  Address({
    this.country,
    this.state,
    this.city,
    this.barangay,
  });

  String country;
  String state;
  String city;
  String barangay;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    country: json["country"],
    state: json["state"],
    city: json["city"],
    barangay: json["barangay"],
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "state": state,
    "city": city,
    "barangay": barangay,
  };
}

class Categorized {
  Categorized({
    this.name,
    this.products,
  });

  String name;
  List<Product> products;

  factory Categorized.fromJson(Map<String, dynamic> json) => Categorized(
    name: json["name"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  Product({
    this.choices,
    this.additionals,
    this.id,
    this.storeId,
    this.name,
    this.description,
    this.image,
    this.price,
    this.customerPrice,
    this.sellerPrice,
    this.quantity,
    this.maxOrder,
    this.category,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  List<Choice> choices;
  List<Additional> additionals;
  int id;
  int storeId;
  String name;
  String description;
  String image;
  String price;
  String customerPrice;
  String sellerPrice;
  int quantity;
  int maxOrder;
  String category;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    choices: List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
    additionals: List<Additional>.from(json["additionals"].map((x) => Additional.fromJson(x))),
    id: json["id"],
    storeId: json["store_id"],
    name: json["name"],
    description: json["description"],
    image: json["image"],
    price: json["price"],
    customerPrice: json["customer_price"],
    sellerPrice: json["seller_price"],
    quantity: json["quantity"],
    maxOrder: json["max_order"],
    category: json["category"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
    "additionals": List<dynamic>.from(additionals.map((x) => x.toJson())),
    "id": id,
    "store_id": storeId,
    "name": name,
    "description": description,
    "image": image,
    "price": price,
    "customer_price": customerPrice,
    "seller_price": sellerPrice,
    "quantity": quantity,
    "max_order": maxOrder,
    "category": category,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class Additional {
    Additional({
      this.id,
      this.name,
      this.price,
      this.customerPrice,
      this.sellerPrice,
      this.status,
    });

    int id;
    String name;
    int price;
    String customerPrice;
    String sellerPrice;
    bool status;

    factory Additional.fromJson(Map<String, dynamic> json) => Additional(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      customerPrice: json["customer_price"],
      sellerPrice: json["seller_price"],
      status: json["status"],
    );

    Map<String, dynamic> toJson() => {
      "id": id,
      "name": name,
      "price": price,
      "customer_price": customerPrice,
      "seller_price": sellerPrice,
      "status": status,
    };
}

class Choice {
  Choice({
    this.id,
    this.name,
    this.options,
    this.status,
    this.choiceDefault,
  });

  int id;
  String name;
  List<Option> options;
  bool status;
  String choiceDefault;

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
    id: json["id"],
    name: json["name"],
    options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    status: json["status"],
    choiceDefault: json["default"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
    "status": status,
    "default": choiceDefault,
  };
}

class Option {
  Option({
    this.id,
    this.name,
    this.price,
    this.customerPrice,
    this.sellerPrice,
    this.status,
  });

  int id;
  String name;
  int price;
  dynamic customerPrice;
  dynamic sellerPrice;
  bool status;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    customerPrice: json["customer_price"],
    sellerPrice: json["seller_price"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "customer_price": customerPrice,
    "seller_price": sellerPrice,
    "status": status,
  };
}

class Location {
  Location({
    this.lat,
    this.lng,
    this.name,
  });

  double lat;
  double lng;
  String name;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
    "name": name,
  };
}