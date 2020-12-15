// To parse this JSON data, do
//
//     final restaurant = restaurantFromJson(jsonString);

import 'dart:convert';

Restaurant restaurantFromJson(String str) => Restaurant.fromJson(json.decode(str));

String restaurantToJson(Restaurant data) => json.encode(data.toJson());

class Restaurant {
    Restaurant({
        this.status,
        this.data,
        this.code
    });

    int status;
    Data data;
    int code;

    factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        status: json["status"] == null ? 0 : json["status"],
        data: json["data"] == null ? Data() : Data.fromJson(json["data"]),
        code: json["code"]
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        this.restaurants,
        this.recentRestaurants,
    });

    List<RestaurantElement> restaurants;
    List<dynamic> recentRestaurants;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        restaurants: json["restaurants"] == null ? List<RestaurantElement>() : List<RestaurantElement>.from(json["restaurants"].map((x) => RestaurantElement.fromJson(x))),
        recentRestaurants: json["recent_restaurants"] == null ? List<RestaurantElement>() : List<RestaurantElement>.from(json["recent_restaurants"].map((x) => RestaurantElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
        "recent_restaurants": List<dynamic>.from(recentRestaurants.map((x) => x)),
    };
}

class RestaurantElement {
    RestaurantElement({
        this.id,
        this.name,
        this.description,
        this.location,
        this.status,
        this.logoUrl,
        this.sliders,
        this.address,
        this.workingDays,
        this.menuCategorized,
    });

    int id;
    String name;
    String description;
    Location location;
    String status;
    String logoUrl;
    List<Slider> sliders;
    Address address;
    WorkingDays workingDays;
    List<MenuCategorized> menuCategorized;

    factory RestaurantElement.fromJson(Map<String, dynamic> json) => RestaurantElement(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        location: Location.fromJson(json["location"]),
        status: json["status"],
        logoUrl: json["logo_url"],
        sliders: List<Slider>.from(json["sliders"].map((x) => Slider.fromJson(x))),
        address: Address.fromJson(json["address"]),
        workingDays: WorkingDays.fromJson(json["working_days"]),
        menuCategorized: List<MenuCategorized>.from(json["menu_categorized"].map((x) => MenuCategorized.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "location": location.toJson(),
        "status": status,
        "logo_url": logoUrl,
        "sliders": List<dynamic>.from(sliders.map((x) => x.toJson())),
        "address": address.toJson(),
        "working_days": workingDays.toJson(),
        "menu_categorized": List<dynamic>.from(menuCategorized.map((x) => x.toJson())),
    };
}

class Address {
    Address({
        this.country,
        this.state,
        this.city,
        this.barangay,
    });

    String country;
    String state;
    String city;
    String barangay;

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        country: json["country"],
        state: json["state"],
        city: json["city"],
        barangay: json["barangay"],
    );

    Map<String, dynamic> toJson() => {
        "country": country,
        "state": state,
        "city": city,
        "barangay": barangay,
    };
}

class Location {
    Location({
        this.lat,
        this.lng,
        this.name,
    });

    double lat;
    double lng;
    String name;

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
        "name": name,
    };
}

class MenuCategorized {
    MenuCategorized({
        this.name,
        this.menus,
    });

    String name;
    List<Menu> menus;

    factory MenuCategorized.fromJson(Map<String, dynamic> json) => MenuCategorized(
        name: json["name"],
        menus: List<Menu>.from(json["menus"].map((x) => Menu.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "menus": List<dynamic>.from(menus.map((x) => x.toJson())),
    };
}

class Menu {
    Menu({
        this.id,
        this.name,
        this.price,
        this.description,
        this.image,
        this.choices,
        this.additionals,
        this.category,
        this.status,
        this.note
    });

    int id;
    String name;
    double price;
    String description;
    String image;
    List<Choice> choices;
    List<Additional> additionals;
    String category;
    int status;
    String note;

    factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json["id"],
        name: json["name"] == null ? "" : json["name"],
        price: json["price"].toDouble(),
        description: json["description"] == null ? "No description" : json["description"],
        image: json["image"] == null ? "" : json["image"],
        choices: json["choices"] == null ? List<Choice>() : List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
        additionals: json["additionals"] == null ? List<Additional>() : List<Additional>.from(json["additionals"].map((x) => Additional.fromJson(x))),
        category: json["category"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "description": description == null ? null : description,
        "image": image,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
        "additionals": additionals == null ? null : List<dynamic>.from(additionals.map((x) => x.toJson())),
        "category": category,
        "status": status,
    };
}

class Additional {
    Additional({
        this.id,
        this.name,
        this.options,
    });

    int id;
    String name;
    List<AdditionalOption> options;

    factory Additional.fromJson(Map<String, dynamic> json) => Additional(
        id: json["id"],
        name: json["name"],
        options: List<AdditionalOption>.from(json["options"].map((x) => AdditionalOption.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
    };
}

class AdditionalOption {
    AdditionalOption({
        this.id,
        this.name,
        this.price,
        this.status,
        this.selectedValue
    });

    int id;
    String name;
    double price;
    int status;
    bool selectedValue;

    factory AdditionalOption.fromJson(Map<String, dynamic> json) => AdditionalOption(
        id: json["id"],
        name: json["name"],
        price: json["price"].toDouble(),
        status: json["status"],
        selectedValue: false
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "status": status,
    };
}

class Choice {
    Choice({
        this.id,
        this.name,
        this.options,
        this.required,
        this.choiceDefault,
    });

    int id;
    String name;
    List<ChoiceOption> options;
    bool required;
    String choiceDefault;

    factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        id: json["id"],
        name: json["name"],
        options: List<ChoiceOption>.from(json["options"].map((x) => ChoiceOption.fromJson(x))),
        required: json["required"],
        choiceDefault: json["default"] == null ? null : json["default"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
        "required": required,
        "default": choiceDefault == null ? null : choiceDefault,
    };
}

class ChoiceOption {
    ChoiceOption({
        this.id,
        this.name,
        this.price,
        this.status,
        this.selectedValue,
    });

    int id;
    String name;
    double price;
    dynamic status;
    String selectedValue;

    factory ChoiceOption.fromJson(Map<String, dynamic> json) => ChoiceOption(
        id: json["id"],
        name: json["name"],
        price: json["price"].toDouble(),
        status: json["status"],
        selectedValue: null
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "status": status,
    };
}

class Slider {
    Slider({
        this.id,
        this.url,
        this.show,
    });

    String id;
    String url;
    bool show;

    factory Slider.fromJson(Map<String, dynamic> json) => Slider(
        id: json["id"],
        url: json["url"],
        show: json["show"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "show": show,
    };
}

class WorkingDays {
    WorkingDays({
        this.sunday,
        this.monday,
        this.tuesday,
        this.wednesday,
        this.thursday,
        this.friday,
        this.saturday,
    });

    Day sunday;
    Day monday;
    Day tuesday;
    Day wednesday;
    Day thursday;
    Day friday;
    Day saturday;

    factory WorkingDays.fromJson(Map<String, dynamic> json) => WorkingDays(
        sunday: Day.fromJson(json["sunday"]),
        monday: Day.fromJson(json["monday"]),
        tuesday: Day.fromJson(json["tuesday"]),
        wednesday: Day.fromJson(json["wednesday"]),
        thursday: Day.fromJson(json["thursday"]),
        friday: Day.fromJson(json["friday"]),
        saturday: Day.fromJson(json["saturday"]),
    );

    Map<String, dynamic> toJson() => {
        "sunday": sunday.toJson(),
        "monday": monday.toJson(),
        "tuesday": tuesday.toJson(),
        "wednesday": wednesday.toJson(),
        "thursday": thursday.toJson(),
        "friday": friday.toJson(),
        "saturday": saturday.toJson(),
    };
}

class Day {
    Day({
        this.status,
        this.openingTime,
        this.closingTime,
    });

    bool status;
    String openingTime;
    String closingTime;

    factory Day.fromJson(Map<String, dynamic> json) => Day(
        status: json["status"],
        openingTime: json["opening_time"] == null ? null : json["opening_time"],
        closingTime: json["closing_time"] == null ? null : json["closing_time"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "opening_time": openingTime == null ? null : openingTime,
        "closing_time": closingTime == null ? null : closingTime,
    };
}
