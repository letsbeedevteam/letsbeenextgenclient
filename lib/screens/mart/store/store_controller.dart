import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/add_to_cart.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/mart/store_cart/store_cart_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';

class StoreController extends GetxController with SingleGetTickerProviderMixin {
  
  TabController tabController;
  ApiService apiService = Get.find();
  GetStorage box = Get.find();

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

  static StoreController get to => Get.find();

  @override
  void onInit() {
    // list.call().clear();
    store.nil();
    Get.put(StoreCartController());

    if (box.hasData(Config.PRODUCTS)) {
      final products = List<Product>.from(box.read(Config.PRODUCTS).map((x) => Product.fromJson(x)));
      
      products.forEach((data) {
        print('Product ID: ${data.name} == Quantity: ${data.quantity} == Price: ${data.customerPrice}');
      });



      list.call().addAll(products);
      box.write(Config.PRODUCTS, list.toJson());
      StoreCartController.to.getProducts();
    } 

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
    message('Loading Mart...');
    hasError(false);
    apiService.fetchStoreById(id: argument['id']).then((response) {
      hasError(false);
      store(response);
      tabController = TabController(length: store.call().data.categorized.map((categorize) => categorize.name).length, vsync: this);
      StoreCartController.to..storeId(store.call().data.id);
      tabController.addListener(() {
        FocusScope.of(Get.context).requestFocus(FocusNode());
        productName('');
        update();
      });
    }).catchError((onError) {
      hasError(true);
      store.nil();
      message(Config.SOMETHING_WENT_WRONG);
      print('Error fetch mart by ID ${argument['id']}: $onError');
    });
  }

  addTocart(Product product) {

    var addToCart = AddToCart(
      storeId: product.storeId,
      productId: product.id,
      choices: [],
      additionals: [],
      quantity: quantity.call(),
      note: null
    );

    isAddToCartLoading(true);
    apiService.addToCart(addToCart).then((response) {
      
      if (response.status == 200) {
        // StoreCartController.to
        // ..cart.nil();
        // ..fetchActiveCarts(storeId: product.storeId, callback: ()  {
        //   Future.delayed(Duration(seconds: 1)).then((data) {
        //     isAddToCartLoading(false);
        //     Get.back();
        //   });
        // });

      } else {
        if (response.code == 3005) {
          errorSnackbarTop(title: 'Oops!', message: 'There\'s a pending order');
        } else if (response.code == 3107) {
          errorSnackbarTop(title: 'Oops!', message: 'Please select your required choice(s)');
        } else {
          errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
        }
        isAddToCartLoading(false);
      }

    }).catchError((onError) {
      isAddToCartLoading(false);
      errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
      print('Add to cart error: ${onError.toString()}');
    });
  }

  void storeCartToStorage(Product product) {
    for (var i = 0; i < quantity.call(); i++) {
      list.call().add(product);
    }
    box.write(Config.PRODUCTS, list);
    StoreCartController.to.getProducts();
    Get.back();
  }
} 