// To parse this JSON data, do
//
//     final storeResponse = storeResponseFromJson(jsonString);

import 'dart:convert';

import 'add_to_cart.dart';

StoreResponse storeResponseFromJson(String str) => StoreResponse.fromJson(json.decode(str));

String storeResponseToJson(StoreResponse data) => json.encode(data.toJson());

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

List<Product> listProductFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String listProductToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String choicesToJson(List<Variants> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String choicesToJson2(List<ChoiceCart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String additionalsToJson2(List<int> data) => json.encode(List<int>.from(data.map((x) => x)));

String additionalsToJson(List<Additional> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreResponse {
  StoreResponse({
    this.status,
    this.data,
  });

  int status;
  List<Data> data;

  factory StoreResponse.fromJson(Map<String, dynamic> json) => StoreResponse(
    status: json["status"],
    data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Data {

  Data({
    this.name,
    this.products
  });

  String name;
  List<Product> products;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    this.id,
    this.name,
    this.description,
    this.image,
    this.customerPrice,
    this.quantity,
    this.maxOrder,
    this.category,
    this.status,
    this.variants,
    this.additionals,
    this.choiceCart,
    this.additionalCart,
    this.type,
    this.note,
    this.uniqueId,
    this.storeId,
    this.isRemove,
    this.userId,
    this.removable
  });

  int id;
  String name;
  String description;
  String image;
  String customerPrice;
  int quantity;
  int maxOrder;
  String category;
  String status;
  List<Variants> variants;
  List<Additional> additionals;

  List<ChoiceCart> choiceCart;
  List<int> additionalCart;
  String type;
  String note;
  String uniqueId;
  int storeId;
  bool isRemove;
  int userId;
  bool removable;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    description: json["description"] == null || json["description"] == '' ? 'No Description' : json["description"],
    image: json["image"] == null ? '' : json["image"],
    customerPrice: json["customer_price"],
    quantity: json["quantity"],
    maxOrder: json["max_order"],
    category: json["category"],
    status: json["status"],
    variants: List<Variants>.from(json["variants"].map((x) => Variants.fromJson(x))),
    additionals: List<Additional>.from(json["additionals"].map((x) => Additional.fromJson(x))),
    choiceCart: json["choiceCart"] == null ? [] : List<ChoiceCart>.from(json["choiceCart"].map((x) => ChoiceCart.fromJson(x))),
    additionalCart: json["additionalCart"] == null ? [] : json["additionalCart"].cast<int>(),
    type: json["type"],
    note: json["note"],
    uniqueId: json["uniqueId"],
    storeId: json["storeId"],
    isRemove: json["isRemove"] == null ? false : json["isRemove"],
    userId: json["userId"],
    removable: json["removable"] == null ? false : json["removable"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "image": image,
    "customer_price": customerPrice,
    "quantity": quantity,
    "max_order": maxOrder,
    "category": category,
    "status": status,
    "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
    "additionals": List<dynamic>.from(additionals.map((x) => x.toJson())),
    "choiceCart": List<dynamic>.from(choiceCart.map((x) => x.toJson())),
    "additionalCart": List<int>.from(additionalCart.map((x) => x)),
    "type": type,
    "note": note,
    "uniqueId": uniqueId,
    "storeId": storeId,
    "isRemove": isRemove,
    "userId": userId,
    "removable": removable
  };
}

class Additional {
    Additional({
      this.id,
      this.name,
      this.customerPrice,
      this.status,
      this.selectedValue,
    });

    int id;
    String name;
    dynamic customerPrice;
    bool status;
    bool selectedValue;

    factory Additional.fromJson(Map<String, dynamic> json) => Additional(
      id: json["id"],
      name: json["name"],
      customerPrice: json["customer_price"],
      status: json["status"],
      selectedValue: json["selectedValue"] == null ? true : json["selectedValue"]
    );

    Map<String, dynamic> toJson() => {
      "id": id,
      "name": name,
      "customer_price": customerPrice,
      "status": status,
      "selectedValue":selectedValue
    };
}

class Variants {
  Variants({
    this.id,
    this.type,
    this.options,
    this.status,
  });

  int id;
  String type;
  List<Option> options;
  bool status;

  factory Variants.fromJson(Map<String, dynamic> json) => Variants(
    id: json["id"],
    type: json["type"],
    status: json["status"],
    options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
    "status": status,
  };
}

class Option {
  Option({
    this.id,
    this.name,
    this.customerPrice,
    this.status,
    this.selectedValue,
  });

  int id;
  String name;
  dynamic customerPrice;
  bool status;
  String selectedValue;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json["id"],
    name: json["name"],
    customerPrice: json["customer_price"],
    status: json["status"],
    selectedValue: json["selectedValue"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "customer_price": customerPrice,
    "status": status,
    "selectedValue":selectedValue
  };
}