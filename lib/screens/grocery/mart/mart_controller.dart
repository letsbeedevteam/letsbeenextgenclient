import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
// import 'package:letsbeeclient/_utils/extensions.dart';
// import 'package:letsbeeclient/models/add_to_cart.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/grocery/mart_cart/mart_cart_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';
import 'package:uuid/uuid.dart';

class MartController extends GetxController with SingleGetTickerProviderMixin {
  
  TabController tabController;
  ApiService apiService = Get.find();
  GetStorage box = Get.find();

  final uuid = Uuid();
  final argument = Get.arguments;
  final nestedScrollViewController = ScrollController();
  final list = RxList<Product>().obs;

  var quantity = 0.obs;

  var store = StoreResponse().obs;

  var message = ''.obs;
  var productName = ''.obs;

  var readOnly = false.obs;
  var hasError = false.obs;
  var isAddToCartLoading = false.obs;

  var selectedName = ''.obs;

  static MartController get to => Get.find();

  @override
  void onInit() {
    // list.call().clear();
    store.nil();
    Get.put(MartCartController());
    super.onInit();
  }

  @override
  void onClose() {
    DashboardController.to.fetchMartDashboard();
    super.onClose();
  }

  searchProduct(String name) {
    productName(name);
    update();
  }

  void increment() => quantity.value++;
  
  void decrement() {
    if (quantity.value <= 1) {
      quantity(1);
    } else {
      quantity.value--;
    }
  }

  fetchStore() {
    message(tr('loadingShop'));
    hasError(false);
    apiService.fetchStoreById(id: argument['id']).then((response) {
      hasError(false);
      store(response);
      selectedName(store.call().data.categorized.first.name);
      tabController = TabController(length: store.call().data.categorized.map((categorize) => categorize.name).length, vsync: this);
      MartCartController.to..storeId(store.call().data.id);
      tabController.addListener(() {
        FocusScope.of(Get.context).requestFocus(FocusNode());
        productName('');
        update();
      });

      if (box.hasData(Config.PRODUCTS)) {
        final products = listProductFromJson(box.read(Config.PRODUCTS)).where((data) => !data.isRemove);
        list.call().clear();
        list.call().addAll(products);
        box.write(Config.PRODUCTS, listProductToJson(list.call()));
        MartCartController.to.getProducts();
      } 

    }).catchError((onError) {
      hasError(true);
      store.nil();
      message(Config.somethingWentWrong);
      print('Error fetch mart by ID ${argument['id']}: $onError');
    });
  }

  void storeCartToStorage(Product product) {
    product.uniqueId = uuid.v4();
    product.userId = box.read(Config.USER_ID);
    for (var i = 0; i < quantity.call(); i++) {
      list.call().add(product);
    }
    // list.call().forEach((data) => data.userId = box.read(Config.USER_ID));
    box.write(Config.PRODUCTS, listProductToJson(list.call()));
    MartCartController.to.getProducts();
    Get.back();
  }
} 