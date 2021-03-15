import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/mart_dashboard_response.dart';
// import 'package:letsbeeclient/_utils/extensions.dart';
// import 'package:letsbeeclient/models/add_to_cart.dart';
import 'package:letsbeeclient/models/store_response.dart';
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

  var store = MartStores().obs;
  var storeResponse = StoreResponse().obs;

  var message = ''.obs;
  var productName = ''.obs;

  var readOnly = false.obs;
  var hasError = false.obs;
  var isAddToCartLoading = false.obs;

  var selectedName = ''.obs;
  var isSelectedProceed = false.obs;

  static MartController get to => Get.find();

  @override
  void onInit() {
    storeResponse.nil();
    store.nil();
    Get.put(MartCartController());
    store(MartStores.fromJson(argument['mart']));
    super.onInit();
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

      if(response.data.isNotEmpty) {

        storeResponse(response);
        selectedName(storeResponse.call().data.first.name);
        tabController = TabController(length: storeResponse.call().data.map((categorize) => categorize.name).length, vsync: this);
        MartCartController.to..storeId(store.call().id);
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

        hasError(false);

      } else {
        storeResponse.nil();
        hasError(true);
        message(tr('emptyProduct'));
      }

    }).catchError((onError) {
      hasError(true);
      storeResponse.nil();
      message(tr('somethingWentWrong'));
      print('Error fetch mart by ID ${argument['id']}: $onError');
    });
  }

  void storeCartToStorage(Product product) {
    
    product.uniqueId = uuid.v4();
    product.userId = box.read(Config.USER_ID);
    product.storeId = store.call().id;
    product.type = Config.MART;
    product.removable = isSelectedProceed.call();

    for (var i = 0; i < quantity.call(); i++) {
      list.call().add(product);
    }
    box.write(Config.PRODUCTS, listProductToJson(list.call()));
    MartCartController.to.getProducts();
    Get.back();
  }

  Future<Null> refreshStore() async => fetchStore();
} 