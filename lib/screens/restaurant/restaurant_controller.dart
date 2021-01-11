import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/models/restaurant.dart';
import 'package:letsbeeclient/screens/cart/cart_controller.dart';

class RestaurantController extends GetxController with SingleGetTickerProviderMixin {

  TabController tabController;

  var restaurant = RestaurantElement().obs;

  @override
  void onInit() {

    restaurant(RestaurantElement.fromJson(Get.arguments));

    var menus = restaurant.call().menuCategorized..map((e) => e.menus);
  
    tabController = TabController(length: menus.length, vsync: this);
    
    super.onInit();
  }

  @override
  void onClose() {
    CartController.to.cart.nil();
    super.onClose();
  }
}