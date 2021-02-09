// To parse this JSON data, do
//
//     final activeCartResponse = activeCartResponseFromJson(jsonString);

import 'dart:convert';

ActiveCartResponse activeCartResponseFromJson(String str) => ActiveCartResponse.fromJson(json.decode(str));

String activeCartResponseToJson(ActiveCartResponse data) => json.encode(data.toJson());

class ActiveCartResponse {
    ActiveCartResponse({
        this.status,
        this.total,
        this.data,
        this.deliveryFee,
    });

    int status;
    double total;
    List<ActiveCartData> data;
    double deliveryFee;

    factory ActiveCartResponse.fromJson(Map<String, dynamic> json) => ActiveCartResponse(
        status: json["status"],
        total: json["total"].toDouble(),
        data: List<ActiveCartData>.from(json["data"].map((x) => ActiveCartData.fromJson(x))),
        deliveryFee: json["deliveryFee"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "total": total,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "deliveryFee": deliveryFee,
    };
}

class ActiveCartData {
    ActiveCartData({
        this.productDetails,
        this.totalPrice,
        this.customerTotalPrice,
        this.sellerTotalPrice,
        this.choices,
        this.additionals,
        this.id,
        this.storeId,
        this.userId,
        this.storeProductId,
        this.quantity,
        this.note,
        this.status,
        this.createdAt
    });

    ProductDetails productDetails;
    double totalPrice;
    double customerTotalPrice;
    double sellerTotalPrice;
    List<ActiveCartChoice> choices;
    List<ActiveCartAdditional> additionals;
    int id;
    int storeId;
    int userId;
    int storeProductId;
    int quantity;
    String note;
    String status;
    DateTime createdAt;

    factory ActiveCartData.fromJson(Map<String, dynamic> json) => ActiveCartData(
        productDetails: ProductDetails.fromJson(json["product_details"]),
        totalPrice: json["total_price"].toDouble(),
        customerTotalPrice: json["customer_total_price"].toDouble(),
        sellerTotalPrice: json["seller_total_price"].toDouble(),
        choices: List<ActiveCartChoice>.from(json["choices"].map((x) => ActiveCartChoice.fromJson(x))),
        additionals: List<ActiveCartAdditional>.from(json["additionals"].map((x) => ActiveCartAdditional.fromJson(x))),
        id: json["id"],
        storeId: json["store_id"],
        userId: json["user_id"],
        storeProductId: json["store_product_id"],
        quantity: json["quantity"],
        note: json["note"] == null || json["note"] == 'null' ? null : json["note"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "product_details": productDetails.toJson(),
        "total_price": totalPrice,
        "customer_total_price": customerTotalPrice,
        "seller_total_price": sellerTotalPrice,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
        "additionals": List<dynamic>.from(additionals.map((x) => x.toJson())),
        "id": id,
        "store_id": storeId,
        "user_id": userId,
        "store_product_id": storeProductId,
        "quantity": quantity,
        "note": note == null ? null : note,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
    };
}

class ActiveCartAdditional {
    ActiveCartAdditional({
        this.id,
        this.name,
        this.price,
        this.customerPrice,
        this.sellerPrice,
    });

    int id;
    String name;
    String price;
    String customerPrice;
    String sellerPrice;

    factory ActiveCartAdditional.fromJson(Map<String, dynamic> json) => ActiveCartAdditional(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        customerPrice: json["customer_price"],
        sellerPrice: json["seller_price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "customer_price": customerPrice,
        "seller_price": sellerPrice,
    };
}

class ActiveCartChoice {
    ActiveCartChoice({
        this.id,
        this.pickId,
        this.name,
        this.price,
        this.customerPrice,
        this.sellerPrice,
        this.pick,
    });

    int id;
    int pickId;
    String name;
    String price;
    String customerPrice;
    String sellerPrice;
    String pick;

    factory ActiveCartChoice.fromJson(Map<String, dynamic> json) => ActiveCartChoice(
        id: json["id"],
        pickId: json["pick_id"],
        name: json["name"],
        price: json["price"],
        customerPrice: json["customer_price"],
        sellerPrice: json["seller_price"],
        pick: json["pick"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "pick_id": pickId,
        "name": name,
        "price": price,
        "customer_price": customerPrice,
        "seller_price": sellerPrice,
        "pick": pick,
    };
}

class ProductDetails {
    ProductDetails({
        this.name,
        this.price,
        this.customerPrice,
        this.sellerPrice,
        this.image
    });

    String name;
    String price;
    String customerPrice;
    String sellerPrice;
    String image;

    factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
        name: json["name"],
        price: json["price"],
        customerPrice: json["customer_price"],
        sellerPrice: json["seller_price"],
        image: json["image"]
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "customer_price": customerPrice,
        "seller_price": sellerPrice,
        "image":image
    };
}
