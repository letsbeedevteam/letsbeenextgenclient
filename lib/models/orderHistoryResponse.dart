// To parse this JSON data, do
//
//     final orderHistoryResponse = orderHistoryResponseFromJson(jsonString);

import 'dart:convert';

OrderHistoryResponse orderHistoryResponseFromJson(String str) => OrderHistoryResponse.fromJson(json.decode(str));

String orderHistoryResponseToJson(OrderHistoryResponse data) => json.encode(data.toJson());

class OrderHistoryResponse {
    OrderHistoryResponse({
        this.status,
        this.data,
    });

    int status;
    List<OrderHistoryData> data;

    factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) => OrderHistoryResponse(
        status: json["status"],
        data: json["data"] == null ? List<OrderHistoryData>() : List<OrderHistoryData>.from(json["data"].map((x) => OrderHistoryData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class OrderHistoryData {
    OrderHistoryData({
        this.menus,
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
        this.restaurant
    });

    List<OrderHistoryMenu> menus;
    Fee fee;
    dynamic timeframe;
    Address address;
    Payment payment;
    int id;
    int restaurantId;
    int userId;
    dynamic riderId;
    String status;
    String reason;
    DateTime createdAt;
    DateTime updatedAt;
    OrderHistoryRestaurant restaurant;

    factory OrderHistoryData.fromJson(Map<String, dynamic> json) => OrderHistoryData(
        menus: List<OrderHistoryMenu>.from(json["menus"].map((x) => OrderHistoryMenu.fromJson(x))),
        fee: Fee.fromJson(json["fee"]),
        timeframe: json["timeframe"],
        address: Address.fromJson(json["address"]),
        payment: Payment.fromJson(json["payment"]),
        id: json["id"],
        restaurantId: json["restaurant_id"],
        userId: json["user_id"],
        riderId: json["rider_id"],
        status: json["status"],
        reason: json["reason"] == null ? null : json["reason"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        restaurant: OrderHistoryRestaurant.fromJson(json['restaurant'])
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
        "reason": reason == null ? null : reason,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "restaurant": restaurant.toJson()
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
    String street;
    String country;
    String isoCode;
    String state;
    String city;
    String barangay;

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        location: Location.fromJson(json["location"]),
        street: json["street"],
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
        discountCode: json["discount_code"] == null || json["discount_code"] == '' ? null : json["discount_code"],
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

class OrderHistoryMenu {
    OrderHistoryMenu({
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
    String price;
    int quantity;
    List<Choice> choices;
    List<Additional> additionals;
    String note;

    factory OrderHistoryMenu.fromJson(Map<String, dynamic> json) => OrderHistoryMenu(
        menuId: json["menu_id"],
        name: json["name"],
        price: json["price"].toString(),
        quantity: json["quantity"],
        choices: List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
        additionals: List<Additional>.from(json["additionals"].map((x) => Additional.fromJson(x))),
        note: json["note"] == null ? null : json["note"],
    );

    Map<String, dynamic> toJson() => {
        "menu_id": menuId,
        "name": name,
        "price": price,
        "quantity": quantity,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
        "additionals": List<dynamic>.from(additionals.map((x) => x.toJson())),
        "note": note == null ? null : note,
    };
}

class OrderHistoryRestaurant {
  OrderHistoryRestaurant({
    this.locationName,
    this.photoUrl,
    this.name,
    this.logoUrl
  });

  String photoUrl;
  String name;
  String locationName;
  String logoUrl;

  factory OrderHistoryRestaurant.fromJson(Map<String, dynamic> json) => OrderHistoryRestaurant(
    photoUrl: json["photo_url"],
    name: json['name'],
    locationName: json['location_name'],
    logoUrl: json['logo_url']  
  );

  Map<String, dynamic> toJson() => {
    'location_name': locationName,
    'photo_url': photoUrl,
    'name': name,
    'logo_url': logoUrl
  };
}

class Slider {
  Slider({
    this.url,
    this.show
  });

  String url;
  bool show;

  factory Slider.fromJson(Map<String, dynamic> json) => Slider(
    url: json['url'],
    show: json['show']  
  );

  Map<String, dynamic> toJson() => {
    'url': url,
    'show': show
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
        method: json["method"] == 'cod' ? 'cash on delivery' : json["method"],
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
    Details();

    factory Details.fromJson(Map<String, dynamic> json) => Details(
    );

    Map<String, dynamic> toJson() => {
    };
}

class TimeframeClass {
    TimeframeClass({
        this.restaurantPickTime,
        this.riderPickTime,
        this.riderPickUpTime,
        this.deliveredTime,
    });

    DateTime restaurantPickTime;
    dynamic riderPickTime;
    dynamic riderPickUpTime;
    dynamic deliveredTime;

    factory TimeframeClass.fromJson(Map<String, dynamic> json) => TimeframeClass(
        restaurantPickTime: DateTime.parse(json["restaurant_pick_time"]),
        riderPickTime: json["rider_pick_time"],
        riderPickUpTime: json["rider_pick_up_time"],
        deliveredTime: json["delivered_time"],
    );

    Map<String, dynamic> toJson() => {
        "restaurant_pick_time": restaurantPickTime.toIso8601String(),
        "rider_pick_time": riderPickTime,
        "rider_pick_up_time": riderPickUpTime,
        "delivered_time": deliveredTime,
    };
}
