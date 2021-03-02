// To parse this JSON data, do
//
//     final addToCart = addToCartFromJson(jsonString);

import 'dart:convert';

String listCartsToJson(List<AddToCart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<AddToCart> listCartsFromJson(String str) => List<AddToCart>.from(json.decode(str).map((x) => AddToCart.fromJson(x)));


class AddToCart {
    AddToCart({
        this.productId,
        this.choices,
        this.additionals,
        this.quantity,
        this.note,
    });

    int productId;
    List<ChoiceCart> choices;
    List<int> additionals;
    int quantity;
    String note;

    factory AddToCart.fromJson(Map<String, dynamic> json) => AddToCart(
      productId: json["product_id"],
      choices: json["choices"],
      additionals: json["additionals"],
      quantity: json["quantity"],
      note: json["note"]
    );

    Map<String, dynamic> toJson() => {
      "product_id": productId,
      "choices": choices == null ? List<dynamic>() : List<dynamic>.from(choices.map((x) => x.toJson())),
      "additionals": choices == null ? List<dynamic>() : List<dynamic>.from(additionals.map((x) => x)),
      "quantity": quantity,
      "note": note,
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
    optionId: json["option_id"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "option_id": optionId,
  };
}

class AdditionalCart {
    AdditionalCart({
      this.id,
    });

    List<int> id;

    factory AdditionalCart.fromJson(Map<String, dynamic> json) => AdditionalCart(
      id: json["id"] == null ? [] : List<int>.from(json["id"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
      "id": id,
    };
}
