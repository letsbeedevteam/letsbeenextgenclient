// To parse this JSON data, do
//
//     final addToCart = addToCartFromJson(jsonString);


class AddToCart {
    AddToCart({
        this.storeId,
        this.productId,
        this.choices,
        this.additionals,
        this.quantity,
        this.note,
    });

    int storeId;
    int productId;
    List<ChoiceCart> choices;
    List<int> additionals;
    int quantity;
    String note;


    Map<String, dynamic> toJson() => {
      "store_id": storeId,
      "product_id": productId,
      "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
      "additionals": additionals,
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

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}
