// To parse this JSON data, do
//
//     final activeOrder = activeOrderFromJson(jsonString);

import 'dart:convert';

ActiveOrder activeOrderFromJson(String str) => ActiveOrder.fromJson(json.decode(str));

String activeOrderToJson(ActiveOrder data) => json.encode(data.toJson());

class ActiveOrder {
    ActiveOrder({
        this.status,
        this.data,
    });

    int status;
    ActiveOrderData data;

    factory ActiveOrder.fromJson(Map<String, dynamic> json) => ActiveOrder(
        status: json["status"],
        data: ActiveOrderData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class ActiveOrderData {
    ActiveOrderData({
        this.menus,
        this.activeRestaurant,
        this.fee,
        this.timeframe,
        this.address,
        this.payment,
        this.id,
        this.restaurantId,
        this.userId,
        this.riderId,
        this.status,
        this.reason,
        this.createdAt,
        this.updatedAt,
    });

    List<Menu> menus;
    ActiveRestaurant activeRestaurant;
    Fee fee;
    String timeframe;
    Address address;
    Payment payment;
    int id;
    int restaurantId;
    int userId;
    int riderId;
    String status;
    dynamic reason;
    DateTime createdAt;
    DateTime updatedAt;

    factory ActiveOrderData.fromJson(Map<String, dynamic> json) => ActiveOrderData(
        menus: json["menus"] == null ?  List<Menu>() : List<Menu>.from(json["menus"].map((x) => Menu.fromJson(x))),
        activeRestaurant: ActiveRestaurant.fromJson(json["restaurant"]),
        fee: Fee.fromJson(json["fee"]),
        timeframe: json["timeframe"],
        address: Address.fromJson(json["address"]),
        payment: Payment.fromJson(json["payment"]),
        id: json["id"],
        restaurantId: json["restaurant_id"],
        userId: json["user_id"],
        riderId: json["rider_id"],
        status: json["status"],
        reason: json["reason"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "menus": List<dynamic>.from(menus.map((x) => x.toJson())),
        "fee": fee.toJson(),
        "timeframe": timeframe,
        "address": address.toJson(),
        "payment": payment.toJson(),
        "id": id,
        "restaurant_id": restaurantId,
        "user_id": userId,
        "rider_id": riderId,
        "status": status,
        "reason": reason,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}

class Address {
    Address({
        this.location,
        this.street,
        this.country,
        this.isoCode,
        this.state,
        this.city,
        this.barangay,
    });

    Location location;
    double street;
    String country;
    String isoCode;
    String state;
    String city;
    String barangay;

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        location: Location.fromJson(json["location"]),
        street: json["street"].toDouble(),
        country: json["country"],
        isoCode: json["iso_code"],
        state: json["state"],
        city: json["city"],
        barangay: json["barangay"],
    );

    Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "street": street,
        "country": country,
        "iso_code": isoCode,
        "state": state,
        "city": city,
        "barangay": barangay,
    };
}

class Location {
    Location({
        this.lat,
        this.lng,
        this.name
    });

    double lat;
    double lng;
    String name;

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        name: json["name"]
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
        "name": name
    };
}

class Fee {
    Fee({
        this.subTotal,
        this.delivery,
        this.discountCode,
        this.discountPrice,
        this.total,
    });

    double subTotal;
    int delivery;
    String discountCode;
    double discountPrice;
    double total;

    factory Fee.fromJson(Map<String, dynamic> json) => Fee(
        subTotal: json["sub_total"].toDouble(),
        delivery: json["delivery"],
        discountCode: json["discount_code"],
        discountPrice: json["discount_price"].toDouble(),
        total: json["total"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "sub_total": subTotal,
        "delivery": delivery,
        "discount_code": discountCode,
        "discount_price": discountPrice,
        "total": total,
    };
}

class Menu {
    Menu({
        this.menuId,
        this.name,
        this.price,
        this.quantity,
        this.choices,
        this.additionals,
        this.note,
    });

    int menuId;
    String name;
    double price;
    int quantity;
    List<Choice> choices;
    List<Additional> additionals;
    dynamic note;

    factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        menuId: json["menu_id"],
        name: json["name"],
        price: json["price"].toDouble(),
        quantity: json["quantity"],
        choices: List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
        additionals: List<Additional>.from(json["additionals"].map((x) => Additional.fromJson(x))),
        note: json["note"] == null ? 'N/A' : json["note"],
    );

    Map<String, dynamic> toJson() => {
        "menu_id": menuId,
        "name": name,
        "price": price,
        "quantity": quantity,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
        "additionals": List<dynamic>.from(additionals.map((x) => x.toJson())),
        "note": note,
    };
}

class Additional {
    Additional({
        this.name,
        this.picks,
    });

    String name;
    List<Pick> picks;

    factory Additional.fromJson(Map<String, dynamic> json) => Additional(
        name: json["name"],
        picks: List<Pick>.from(json["picks"].map((x) => Pick.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
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
        this.name,
        this.price,
        this.pick,
    });

    String name;
    double price;
    String pick;

    factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        name: json["name"],
        price: json["price"].toDouble(),
        pick: json["pick"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "pick": pick,
    };
}

class Payment {
    Payment({
        this.method,
        this.status,
        this.details,
    });

    String method;
    String status;
    Details details;

    factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        method: json["method"],
        status: json["status"],
        details: Details.fromJson(json["details"]),
    );

    Map<String, dynamic> toJson() => {
        "method": method,
        "status": status,
        "details": details.toJson(),
    };
}

class Details {
    Details({
        this.id,
    });

    String id;

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}

class ActiveRestaurant {

  ActiveRestaurant({
    this.location,
    this.name
  });

  Location location;
  String name;

  factory ActiveRestaurant.fromJson(Map<String, dynamic> json) => ActiveRestaurant(
      location: Location.fromJson(json["location"]),
      name: json["name"]
  );
}
