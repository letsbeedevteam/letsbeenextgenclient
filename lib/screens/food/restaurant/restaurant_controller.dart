import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';
// import 'package:letsbeeclient/models/restaurant.dart';
// import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
// import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';

class RestaurantController extends GetxController with SingleGetTickerProviderMixin {

  TabController tabController;

  ApiService apiService = Get.find();

  var store = StoreResponse().obs;

  var message = ''.obs;

  final argument = Get.arguments;

  var hasError = false.obs;

  final nestedScrollViewController = ScrollController();

  var listOfProcucts = RxList<Product>().obs;

  var readOnly = false.obs;
  var productName = ''.obs;
  
  @override
  void onInit() {
    Get.put(CartController());
    store.nil();
    super.onInit();
  }

  @override
  void onClose() {
    DashboardController.to.fetchRestaurantDashboard();
    super.onClose();
  }

  searchProduct(String name) {
    productName(name);
    update();
  }

  fetchStore() {
    message('Loading Restaurant...');
    hasError(false);
    apiService.fetchStoreById(id: argument['id']).then((response) {
      hasError(false);
      store(response);
      tabController = TabController(length: store.call().data.categorized.map((categorize) => categorize.name).length, vsync: this);
      CartController.to..storeId(store.call().data.id)..fetchActiveCarts(storeId: store.call().data.id);
      tabController.addListener(() {
        FocusScope.of(Get.context).requestFocus(FocusNode());
        productName('');
        update();
      });

    }).catchError((onError) {
      hasError(true);
      store.nil();
      message(Config.SOMETHING_WENT_WRONG);
      print('Error fetch restaurant by ID ${argument['id']}: $onError');
    });
  }
}