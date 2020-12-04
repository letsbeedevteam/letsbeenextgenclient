// To parse this JSON data, do
//
//     final createOrderResponse = createOrderResponseFromJson(jsonString);

import 'dart:convert';

CreateOrderResponse createOrderResponseFromJson(String str) => CreateOrderResponse.fromJson(json.decode(str));

String createOrderResponseToJson(CreateOrderResponse data) => json.encode(data.toJson());

class CreateOrderResponse {
    CreateOrderResponse({
        this.status,
        this.data,
        this.paymentUrl,
    });

    int status;
    Data data;
    String paymentUrl;

    factory CreateOrderResponse.fromJson(Map<String, dynamic> json) => CreateOrderResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        paymentUrl: json["payment_url"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "payment_url": paymentUrl,
    };
}

class Data {
    Data({
        this.menus,
        this.fee,
        this.timeframe,
        this.address,
        this.payment,
        this.id,
        this.restaurantId,
        this.userId,
        this.status,
        this.updatedAt,
        this.createdAt,
    });

    List<OrderMenu> menus;
    Fee fee;
    String timeframe;
    Address address;
    Payment payment;
    int id;
    int restaurantId;
    int userId;
    String status;
    DateTime updatedAt;
    DateTime createdAt;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        menus: json["menus"] == null ? List<OrderMenu>() : List<OrderMenu>.from(json["menus"].map((x) => OrderMenu.fromJson(x))),
        fee: Fee.fromJson(json["fee"]),
        timeframe: json["timeframe"],
        address: Address.fromJson(json["address"]),
        payment: Payment.fromJson(json["payment"]),
        id: json["id"],
        restaurantId: json["restaurant_id"],
        userId: json["user_id"],
        status: json["status"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdAt: DateTime.parse(json["createdAt"]),
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
        "status": status,
        "updatedAt": updatedAt.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
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
    });

    double lat;
    double lng;

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
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
    int discountPrice;
    double total;

    factory Fee.fromJson(Map<String, dynamic> json) => Fee(
        subTotal: json["sub_total"].toDouble(),
        delivery: json["delivery"],
        discountCode: json["discount_code"],
        discountPrice: json["discount_price"],
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

class OrderMenu {
    OrderMenu({
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

    factory OrderMenu.fromJson(Map<String, dynamic> json) => OrderMenu(
        menuId: json["menu_id"],
        name: json["name"],
        price: json["price"].toDouble(),
        quantity: json["quantity"],
        choices: List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
        additionals: List<Additional>.from(json["additionals"].map((x) => Additional.fromJson(x))),
        note: json["note"],
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
        price: json["price"],
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
