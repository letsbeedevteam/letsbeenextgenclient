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
    List<ActiveOrderData> data;

    factory ActiveOrder.fromJson(Map<String, dynamic> json) => ActiveOrder(
        status: json["status"],
        data: json["data"] == null ? List<ActiveOrderData>() : List<ActiveOrderData>.from(json["data"].map((x) => ActiveOrderData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<ActiveOrderData>.from(data.map((x) => x.toJson())),
    };
}

class ActiveOrderData {
    ActiveOrderData({
        this.products,
        this.activeStore,
        this.rider,
        this.user,
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

    List<ActiveOrderMenu> products;
    ActiveStore activeStore;
    Rider rider;
    User user;
    Fee fee;
    Timeframe timeframe;
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
        products: json["products"] == null ?  List<ActiveOrderMenu>() : List<ActiveOrderMenu>.from(json["products"].map((x) => ActiveOrderMenu.fromJson(x))),
        activeStore: ActiveStore.fromJson(json["store"]),
        rider: json["rider"] == null || json["rider"] == 'null' ? null : Rider.fromJson(json['rider']),
        user: json["user"] == null || json["user"] == 'null' ? null : User.fromJson(json['user']),
        fee: Fee.fromJson(json["fee"]),
        timeframe: json["timeframe"] == null || json["timeframe"] == "" ? null : Timeframe.fromJson(json["timeframe"]),
        address: Address.fromJson(json["address"]),
        payment: Payment.fromJson(json["payment"]),
        id: json["id"],
        restaurantId: json["restaurant_id"],
        userId: json["user_id"],
        riderId: json["rider_id"] == null || json["rider_id"] == 'null' ? 0 : json["rider_id"],
        status: json["status"],
        reason: json["reason"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "menus": List<dynamic>.from(products.map((x) => x.toJson())),
        "fee": fee.toJson(),
        "timeframe": timeframe.toJson(),
        "address": address.toJson(),
        "payment": payment.toJson(),
        "id": id,
        "restaurant_id": restaurantId,
        "user_id": userId,
        "rider_id": riderId,
        "status": status,
        "reason": reason,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}

class Timeframe {
  Timeframe({
    this.restaurantPickTime,
    this.riderPickTime,
    this.riderPickUpTime,
    this.deliveredTime
  });

  String restaurantPickTime;
  String riderPickTime;
  String riderPickUpTime;
  String deliveredTime;


   factory Timeframe.fromJson(Map<String, dynamic> json) => Timeframe(
      restaurantPickTime: json['restaurant_pick_time'],
      riderPickTime: json['rider_pick_time'],
      riderPickUpTime: json['rider_pick_up_time'],
      deliveredTime: json['delivered_time']
    );

     Map<String, dynamic> toJson() => {
      "restaurant_pick_time": restaurantPickTime,
      "rider_pick_time": riderPickTime,
      "rider_pick_up_time": riderPickUpTime,
      "delivered_time": deliveredTime,
    };
}

class Address {
    Address({
        this.location,
        this.completeAddress,
        this.note,
    });

    AddressLocation location;
    String completeAddress;
    String note;

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        location: AddressLocation.fromJson(json["location"]),
        completeAddress: json["complete_address"],
        note: json["note"]
    );

    Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "complete_address": completeAddress,
        "note": note
    };
}

class AddressLocation {
  AddressLocation({
    this.lat,
    this.lng
  });

  double lat;
  double lng;

  factory AddressLocation.fromJson(Map<String, dynamic> json) => AddressLocation(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class Location {
    Location({
        this.lat,
        this.lng,
        this.name,
        this.locationName
    });

    String lat;
    String lng;
    String name;
    String locationName;

    factory Location.fromJson(Map<String, dynamic> json) => Location(
      lat: json["latitude"],
      lng: json["longitude"],
      name: json['name'],
      locationName: json["location_name"]
    );

    Map<String, dynamic> toJson() => {
      "lat": lat,
      "lng": lng,
      "name": name,
      "location_name": locationName
    };
}

class Fee {
    Fee({
        this.subTotal,
        this.delivery,
        this.discountCode,
        this.discountPrice,
        this.customerTotalPrice,
    });

    String subTotal;
    String delivery;
    String discountCode;
    String discountPrice;
    String customerTotalPrice;

    factory Fee.fromJson(Map<String, dynamic> json) => Fee(
        subTotal: json["sub_total"].toString(),
        delivery: json["delivery"].toString(),
        discountCode: json["discount_code"] == null ? '' : json["discount_code"],
        discountPrice: json["discount_price"].toString(),
        customerTotalPrice: json["customer_total_price"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "sub_total": subTotal,
        "delivery": delivery,
        "discount_code": discountCode,
        "discount_price": discountPrice,
        "customer_total_price": customerTotalPrice,
    };
}

class ActiveOrderMenu {
    ActiveOrderMenu({
        this.productId,
        this.name,
        this.price,
        this.customerPrice,
        this.quantity,
        this.choices,
        this.additionals,
        this.note,
    });

    int productId;
    String name;
    String price;
    String customerPrice;
    int quantity;
    List<Choice> choices;
    List<Additional> additionals;
    String note;

    factory ActiveOrderMenu.fromJson(Map<String, dynamic> json) => ActiveOrderMenu(
        productId: json["product_id"],
        name: json["name"],
        price: json["price"].toString(),
        customerPrice: json["customer_price"],
        quantity: json["quantity"],
        choices: List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
        additionals: List<Additional>.from(json["additionals"].map((x) => Additional.fromJson(x))),
        note: json["note"] == null ? null : json["note"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
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
      this.id,
      this.name,
      this.customerPrice,
    });

    int id;
    String name;
    String customerPrice;

    factory Additional.fromJson(Map<String, dynamic> json) => Additional(
      id: json["id"],
      name: json["name"],
      customerPrice: json["customer_price"]
    );

    Map<String, dynamic> toJson() => {
      "id": id,
      "name": name,
      "customer_price": customerPrice,
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
    String price;

    factory Pick.fromJson(Map<String, dynamic> json) => Pick(
        id: json["id"],
        name: json["name"],
        price: json["price"].toString(),
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
        this.customerPrice,
        this.pick,
    });

    String name;
    String customerPrice;
    String pick;

    factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        name: json["name"],
        customerPrice: json["customer_price"],
        pick: json["pick"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
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

class ActiveStore {

  ActiveStore({
    this.logoUrl,
    this.name,
    this.locationName,
    this.latitude,
    this.longitude,
    this.type
  });

  String logoUrl;
  String name;
  String locationName;
  String latitude;
  String longitude;
  String type;

  factory ActiveStore.fromJson(Map<String, dynamic> json) => ActiveStore(
    logoUrl: json["logo_url"] == null || json["logo_url"] == '' ? null : json["logo_url"],
    type: json["type"],
    name: json["name"],
    locationName: json['location_name'] == '' || json['location_name'] == null ? '' : json['location_name'],
    latitude: json['latitude'],
    longitude: json['longitude']
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "type": type,
    "location_name": locationName,
    "latitude": latitude,
    "longitude": longitude
  };
}

class Rider {
  Rider({
    this.userId,
    this.user,
    this.motorcycleDetails
  });

  int userId;
  MotorcycleDetails motorcycleDetails;
  RiderUser user;

  factory Rider.fromJson(Map<String, dynamic> json) => Rider(
    userId: json['user_id'],
    motorcycleDetails: json['motorcycle_details'] == null ? null : MotorcycleDetails.fromJson(json['motorcycle_details']),
    user: RiderUser.fromJson(json['user'])
  );
}

class MotorcycleDetails {

  MotorcycleDetails({
    this.brand,
    this.model,
    this.plateNumber,
    this.color
  });

  String brand;
  String model;
  String plateNumber;
  String color;  

  factory MotorcycleDetails.fromJson(Map<String, dynamic> json) => MotorcycleDetails(
    brand: json['brand'],
    model: json['model'],
    plateNumber: json['plate_number'],
    color: json['color']
  );
}

class User {
  User({
    this.name,
    this.number
  });
  
  String name;
  String number;

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    number: json['cellphone_number'] == null ? 'None' : json['cellphone_number']
  );
}

class RiderUser {
  RiderUser({
    this.name,
    this.number
  });
  
  String name;
  String number;

  factory RiderUser.fromJson(Map<String, dynamic> json) => RiderUser(
    name: json['name'],
    number: json['cellphone_number'] == null ? 'None' : json['cellphone_number']
  );
}
