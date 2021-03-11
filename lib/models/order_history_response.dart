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
        this.products,
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
        this.store
    });

    List<OrderHistoryMenu> products;
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
    OrderHistoryRestaurant store;

    factory OrderHistoryData.fromJson(Map<String, dynamic> json) => OrderHistoryData(
        products: List<OrderHistoryMenu>.from(json["products"].map((x) => OrderHistoryMenu.fromJson(x))),
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
        store: OrderHistoryRestaurant.fromJson(json['store'])
    );

    Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
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
        "store": store.toJson()
    };
}

class Address {
    Address({
        this.location,
        this.completeAddress,
        this.note,
    });

    Location location;
    String completeAddress;
    String note;

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        location: Location.fromJson(json["location"]),
        completeAddress: json["complete_address"],
        note: json["note"]
    );

    Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "complete_address": completeAddress,
        "note": note
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
        this.customerTotalPrice,
        this.totalPrice,
    });

    String subTotal;
    String delivery;
    String discountCode;
    String totalPrice;
    int discountPrice;
    String customerTotalPrice;

    factory Fee.fromJson(Map<String, dynamic> json) => Fee(
      subTotal: json["sub_total"],
      delivery: json["delivery"],
      discountCode: json["discount_code"] == null || json["discount_code"] == '' ? null : json["discount_code"],
      discountPrice: json["discount_price"],
      totalPrice: json["total_price"],
      customerTotalPrice: json["customer_total_price"]
    );

    Map<String, dynamic> toJson() => {
      "sub_total": subTotal,
      "delivery": delivery,
      "discount_code": discountCode,
      "discount_price": discountPrice,
      "total_price": totalPrice,
      "customer_total_price": customerTotalPrice
    };
}

class OrderHistoryMenu {
    OrderHistoryMenu({
        this.productId,
        this.name,
        this.price,
        this.quantity,
        this.variants,
        this.additionals,
        this.note,
        this.customerPrice,
    });

    int productId;
    String name;
    String price;
    int quantity;
    String customerPrice;
    List<Variants> variants;
    List<Additional> additionals;
    String note;

    factory OrderHistoryMenu.fromJson(Map<String, dynamic> json) => OrderHistoryMenu(
        productId: json["product_id"],
        name: json["name"],
        price: json["price"].toString(),
        quantity: json["quantity"],
        customerPrice: json["customer_price"],
        variants: List<Variants>.from(json["variants"].map((x) => Variants.fromJson(x))),
        additionals: List<Additional>.from(json["additionals"].map((x) => Additional.fromJson(x))),
        note: json["note"] == null ? null : json["note"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "name": name,
        "price": price,
        "customer_price": customerPrice,
        "quantity": quantity,
        "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
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
      this.customerPrice,
    });

    String name;
    String customerPrice;

    factory Additional.fromJson(Map<String, dynamic> json) => Additional(
      name: json["name"],
      customerPrice: json["customer_price"]
    );

    Map<String, dynamic> toJson() => {
      "name": name,
      "customer_price": customerPrice
    };
}

// class Pick {
//     Pick({
//         this.id,
//         this.name,
//         this.price,
//     });

//     int id;
//     String name;
//     String price;

//     factory Pick.fromJson(Map<String, dynamic> json) => Pick(
//         id: json["id"],
//         name: json["name"],
//         price: json["price"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "price": price,
//     };
// }

class Variants {
    Variants({
        this.type,
        this.customerPrice,
        this.pick,
    });

    String type;
    String customerPrice;
    String pick;

    factory Variants.fromJson(Map<String, dynamic> json) => Variants(
        type: json["type"],
        customerPrice: json["customer_price"],
        pick: json["pick"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "customer_price": customerPrice,
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
