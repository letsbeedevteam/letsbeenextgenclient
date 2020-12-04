// To parse this JSON data, do
//
//     final addToCart = addToCartFromJson(jsonString);

import 'dart:convert';

AddToCart addToCartFromJson(String str) => AddToCart.fromJson(json.decode(str));

String addToCartToJson(AddToCart data) => json.encode(data.toJson());

class AddToCart {
    AddToCart({
        this.restaurantId,
        this.menuId,
        this.choices,
        this.additionals,
        this.quantity,
        this.note,
    });

    int restaurantId;
    int menuId;
    List<ChoiceCart> choices;
    List<AdditionalCart> additionals;
    int quantity;
    String note;

    factory AddToCart.fromJson(Map<String, dynamic> json) => AddToCart(
        restaurantId: json["restaurant_id"],
        menuId: json["menu_id"],
        choices: List<ChoiceCart>.from(json["choices"].map((x) => ChoiceCart.fromJson(x))),
        additionals: List<AdditionalCart>.from(json["additionals"].map((x) => AdditionalCart.fromJson(x))),
        quantity: json["quantity"],
        note: json["note"],
    );

    Map<String, dynamic> toJson() => {
        "restaurant_id": restaurantId,
        "menu_id": menuId,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
        "additionals": List<dynamic>.from(additionals.map((x) => x.toJson())),
        "quantity": quantity,
        "note": note,
    };
}

class AdditionalCart {
    AdditionalCart({
        this.id,
        this.optionIds,
    });

    int id;
    List<int> optionIds;

    factory AdditionalCart.fromJson(Map<String, dynamic> json) => AdditionalCart(
        id: json["id"],
        optionIds: List<int>.from(json["option_ids"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "option_ids": List<dynamic>.from(optionIds.map((x) => x)),
    };
}

class ChoiceCart {
    ChoiceCart({
        this.id,
        this.optionId,
    });

    int id;
    int optionId;

    factory ChoiceCart.fromJson(Map<String, dynamic> json) => ChoiceCart(
        id: json["id"],
        optionId: json["option_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "option_id": optionId,
    };
}
