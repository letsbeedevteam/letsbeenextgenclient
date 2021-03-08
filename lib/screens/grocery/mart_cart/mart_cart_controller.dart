import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
// import 'package:letsbeeclient/models/active_cart_response.dart';
import 'package:letsbeeclient/models/add_to_cart.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/grocery/mart/mart_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';

class MartCartController extends GetxController {

  final ApiService _apiService = Get.find();
  final GetStorage box = Get.find();
  final argument = Get.arguments;
  Completer<void> refreshCompleter;

  var message = ''.obs;
  var totalPrice = 0.0.obs;
  var subTotal = 0.0.obs;
  var isLoading = false.obs;
  var isPaymentLoading = false.obs;
  var isUpdateCartLoading = false.obs;
  var isEdit = false.obs;
  var storeId = 0.obs;
  // var cart = ActiveCartResponse().obs;
  var quantity = 0.obs;
  
  final streetTFController = TextEditingController();
  final barangayTFController = TextEditingController();
  final cityTFController = TextEditingController();

  final streetNode = FocusNode();
  final barangayNode = FocusNode();
  final cityNode = FocusNode();

  final addToCart = RxList<AddToCart>().obs;
  final updatedProducts = RxList<Product>().obs;
  // final products = RxList<Product>().obs;

  static MartCartController get to => Get.find();
  
  @override
  void onInit() {
    // cart.nil();
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

  setEdit() {
    isEdit(!isEdit.call());
    isUpdateCartLoading(false);
  }

  Future<bool> onWillPopBack() async {
    isEdit(false);
    isUpdateCartLoading(false);
    // fetchActiveCarts(storeId: storeId.call());
    Get.back(closeOverlays: true);
    return true;
  }

  updateCartRequest({Product product}) {
    Get.back();
    successSnackBarTop(message: Config.updatedItem, seconds: 1);
  
    final prod = listProductFromJson(box.read(Config.PRODUCTS));
   
    if (product.quantity < quantity.call()) {
      prod.where((data) => data.uniqueId == product.uniqueId);
      for (var i = 0; i < quantity.call() - product.quantity; i++) {
        prod.add(product);
      }
    } else {
      print(product.quantity - quantity.call());
      prod.where((data) => data.uniqueId == product.uniqueId).take(product.quantity - quantity.call()).forEach((data) {
        data.isRemove = true;
      });
     
      prod.removeWhere((data) => data.isRemove);
    }
   
    box.write(Config.PRODUCTS, listProductToJson(prod));
    getProducts();
  }

  deleteCart({String uniqueId}) {
    // isLoading(true);
    Get.back();
    successSnackBarTop(message: Config.deletedItem, seconds: 1);
    final prod = listProductFromJson(box.read(Config.PRODUCTS));
    prod.removeWhere((data) => data.uniqueId == uniqueId);
    box.write(Config.PRODUCTS, listProductToJson(prod));
    MartController.to.list.call().removeWhere((data) => data.uniqueId == uniqueId);
    getProducts();
  }

  paymentMethod(int storeId, String paymentMethod) {
    print('storeId: $storeId');
    if (totalPrice.value < 100) {
      errorSnackbarTop(message: Config.minimumTransaction);
    } else {

      isPaymentLoading(true);
      Get.back();

      _apiService.createOrder(storeId: storeId, paymentMethod: paymentMethod, carts: addToCart.call()).then((response) {
          
        isPaymentLoading(false);

        if(response.status == 200) {
          DashboardController.to.fetchActiveOrders();

          if (response.code == 3506) {
            errorSnackbarTop(title: Config.oops, message: Config.storeClosed);
          } else {
            if (response.paymentUrl == null) {
              print('NO URL');
              successSnackBarTop(title: Config.yay, message: Config.successOrder);

              final prod = listProductFromJson(box.read(Config.PRODUCTS));
              prod.removeWhere((data) => data.storeId == storeId);
              box.write(Config.PRODUCTS, listProductToJson(prod));
              MartController.to.list.call().removeWhere((data) => data.storeId == storeId);
              getProducts();

              DashboardController.to.fetchActiveOrders();

              Future.delayed(Duration(seconds: 1)).then((value) {
                // fetchActiveCarts(storeId: storeId);
                if (Get.isSnackbarOpen) {
                  Get.back();
                  Future.delayed(Duration(seconds: 1));
                  Get.back();
                } else {
                  Get.back();
                }
              });

            } else {
              // paymentSnackBarTop(title: 'Processing..', message: 'Please wait..');
              print('GO TO WEBVIEW: ${response.paymentUrl}');
              // fetchActiveCarts(storeId: storeId);
              Get.toNamed(Config.WEBVIEW_ROUTE, arguments: {
                'url': response.paymentUrl,
                'order_id': response.data.id
              });
            }
          }

        } else {
          
          if (response.code == 3006) {
            errorSnackbarTop(title: Config.oops, message: response.message);
          } else {
            errorSnackbarTop(title: Config.oops, message: Config.somethingWentWrong);
          }
        }
        
      }).catchError((onError) {
        isPaymentLoading(false);
        if (onError.toString().contains('Connection failed')) message(Config.noInternetConnection); else message(Config.somethingWentWrong);
        print('Payment method: $onError');
      });
    }
  }

  getProducts() {

    final products = listProductFromJson(box.read(Config.PRODUCTS)).where((data) => !data.isRemove && data.storeId == storeId.call());

    final Map<String, Product> newMap = Map();
    final quantity = {};
    addToCart.call().clear();
    
    products.forEach((item) {
      newMap[item.name] = item;
      quantity[item.name] = quantity.containsKey(item.name) ? quantity[item.name] + 1 : 1;
    });

    newMap.values.forEach((item) {
      item.quantity = quantity[item.name];

      print('Product ID: ${item.name} == Quantity: ${item.quantity} == Price: ${item.customerPrice} == User ID: ${item.userId}');

      addToCart.call().add(
        AddToCart(
          productId: item.id,
          choices: null,
          additionals: null,
          quantity: item.quantity,
          note: null
        )
      );
    });

    // print(addToCart.toJson());

    if (newMap.isNotEmpty) {
      updatedProducts.call().assignAll(newMap.values);
      totalPrice(updatedProducts.call().map((e) => double.tryParse(e.customerPrice) * e.quantity).reduce((value, element) => value + element)).roundToDouble();
      subTotal(updatedProducts.call().map((e) => double.tryParse(e.customerPrice) * e.quantity).reduce((value, element) => value + element)).roundToDouble();
    } else {
      updatedProducts.call().clear();
    }
  }
}