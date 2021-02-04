import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController with SingleGetTickerProviderMixin {
  
  TabController tabController;

  var quantity = 0.obs;
  
  @override
  void onInit() {
    tabController = TabController(length:3, vsync: this);
    super.onInit();
  }

  void increment() => quantity.value++;
  
  void decrement() {
    if (quantity.value <= 1) {
      quantity(1);
    } else {
      quantity.value--;
    }
  }
} 