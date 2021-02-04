import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/models/restaurant.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';

class RestaurantController extends GetxController with SingleGetTickerProviderMixin {

  TabController tabController;

  var restaurant = RestaurantElement().obs;

  @override
  void onInit() {
    CartController.to.cart.nil();
    restaurant(RestaurantElement.fromJson(Get.arguments));

    final menus = restaurant.call().menuCategorized..map((e) => e.menus);
  
    tabController = TabController(length: menus.length, vsync: this);

    final restaurantId = restaurant.call().id;

    CartController.to..restaurantId(restaurantId)..fetchActiveCarts(getRestaurantId: restaurantId);
    
    super.onInit();
  }

  @override
    void onClose() {
      DashboardController.to.fetchRestaurants();
      super.onClose();
    }
}