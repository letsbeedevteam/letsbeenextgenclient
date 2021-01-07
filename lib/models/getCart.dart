// To parse this JSON data, do
//
//     final getCart = getCartFromJson(jsonString);

import 'dart:convert';

GetCart getCartFromJson(String str) => GetCart.fromJson(json.decode(str));

String getCartToJson(GetCart data) => json.encode(data.toJson());

class GetCart {
    GetCart({
        this.status,
        this.total,
        this.data,
        this.deliveryFee
    });

    int status;
    double deliveryFee;
    int total;
    List<CartData> data;

    factory GetCart.fromJson(Map<String, dynamic> json) => GetCart(
        status: json["status"],
        total: json["total"],
        deliveryFee: json['deliveryFee'].toDouble(),
        data: json["data"] == null ? List<CartData>() : List<CartData>.from(json["data"].map((x) => CartData.fromJson(x)))
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "total": total,
        "deliveryFee": deliveryFee,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CartData {
    CartData({
        this.menuDetails,
        this.totalPrice,
        this.choices,
        this.additionals,
        this.id,
        this.restaurantId,
        this.userId,
        this.restaurantMenuId,
        this.quantity,
        this.note,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    MenuDetails menuDetails;
    double totalPrice;
    List<Choice> choices;
    List<Additional> additionals;
    int id;
    int restaurantId;
    int userId;
    int restaurantMenuId;
    int quantity;
    String note;
    String status;
    DateTime createdAt;
    DateTime updatedAt;

    factory CartData.fromJson(Map<String, dynamic> json) => CartData(
        menuDetails: MenuDetails.fromJson(json["menu_details"]),
        totalPrice: json["total_price"].toDouble(),
        choices: List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
        additionals: List<Additional>.from(json["additionals"].map((x) => Additional.fromJson(x))),
        id: json["id"],
        restaurantId: json["restaurant_id"],
        userId: json["user_id"],
        restaurantMenuId: json["restaurant_menu_id"],
        quantity: json["quantity"],
        note: json["note"] == null ? 'N/A' : json["note"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "menu_details": menuDetails.toJson(),
        "total_price": totalPrice,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
        "additionals": List<dynamic>.from(additionals.map((x) => x.toJson())),
        "id": id,
        "restaurant_id": restaurantId,
        "user_id": userId,
        "restaurant_menu_id": restaurantMenuId,
        "quantity": quantity,
        "note": note,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}

class Additional {
    Additional({
        this.id,
        this.name,
        this.picks,
    });

    int id;
    String name;
    List<Pick> picks;

    factory Additional.fromJson(Map<String, dynamic> json) => Additional(
        id: json["id"],
        name: json["name"],
        picks: List<Pick>.from(json["picks"].map((x) => Pick.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "picks": List<dynamic>.from(picks.map((x) => x.toJson())),
    };
}

class Pick {
    Pick({
        this.id,
        this.name,
        this.price,
    });

    int id;
    String name;
    double price;

    factory Pick.fromJson(Map<String, dynamic> json) => Pick(
        id: json["id"],
        name: json["name"],
        price: json["price"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
    };
}

class Choice {
    Choice({
        this.id,
        this.pickId,
        this.name,
        this.price,
        this.pick,
    });

    int id;
    int pickId;
    String name;
    double price;
    String pick;

    factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        id: json["id"],
        pickId: json["pick_id"],
        name: json["name"],
        price: json["price"].toDouble(),
        pick: json["pick"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "pick_id": pickId,
        "name": name,
        "price": price,
        "pick": pick,
    };
}

class MenuDetails {
    MenuDetails({
        this.name,
        this.price,
    });

    String name;
    double price;

    factory MenuDetails.fromJson(Map<String, dynamic> json) => MenuDetails(
        name: json["name"],
        price: json["price"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
    };
}
