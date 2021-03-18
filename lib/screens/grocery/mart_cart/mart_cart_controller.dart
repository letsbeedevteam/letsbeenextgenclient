import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
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

  var totalPrice = 0.0.obs;
  var subTotal = 0.0.obs;
  var storeId = 0.obs;
  var deliveryFee = 0.0.obs;
  
  var quantity = 0.obs;

  var message = ''.obs;

  var hasError = false.obs;
  var isLoading = false.obs;
  var isPaymentLoading = false.obs;
  var isEdit = false.obs;
  
  final noteToRider = TextEditingController();
  final noteToRiderNode = FocusNode();

  final addToCart = RxList<AddToCart>().obs;
  final updatedProducts = RxList<Product>().obs;

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
  }

  Future<bool> onWillPopBack() async {
    isEdit(false);
    Get.back(closeOverlays: true);
    return true;
  }

  updateCartRequest({Product product}) {
    Get.back();
    successSnackBarTop(message: tr('updatedItem'), seconds: 1);
      
    final prod = listProductFromJson(box.read(Config.PRODUCTS));

    if(product.quantity == quantity.call()) {
      prod.where((data) => data.uniqueId == product.uniqueId).forEach((data) {
        data.removable = product.removable;
      });
    }

    if (product.quantity < quantity.call()) {
      prod.where((data) => data.uniqueId == product.uniqueId);
      for (var i = 0; i < quantity.call() - product.quantity; i++) {
        prod.add(product);
      }
    } else {
      print(product.quantity - quantity.call());
      prod.where((data) => data.uniqueId == product.uniqueId).take(product.quantity - quantity.call()).forEach((data) {
        data.removable = product.removable;
        data.isRemove = true;
      });
     
      prod.removeWhere((data) => data.isRemove);
    }
    
    MartController.to.list.call()..clear()..addAll(prod);
    box.write(Config.PRODUCTS, listProductToJson(prod));
    getProducts();
  }

  deleteCart({String uniqueId}) {
    Get.back();
    successSnackBarTop(message: tr('deletedItem'), seconds: 1);
    final prod = listProductFromJson(box.read(Config.PRODUCTS));
    prod.removeWhere((data) => data.uniqueId == uniqueId);
    box.write(Config.PRODUCTS, listProductToJson(prod));
    MartController.to.list.call().removeWhere((data) => data.uniqueId == uniqueId);
    getProducts();
  }

  paymentMethod(int storeId, String paymentMethod) {
    print('storeId: $storeId');
    if (totalPrice.value < 100) {
      errorSnackbarTop(message: tr('minimumTransaction'));
    } else {

      isPaymentLoading(true);
      Get.back();

      _apiService.createOrder(storeId: storeId, paymentMethod: paymentMethod, noteToRider: noteToRider.text.trim(), carts: addToCart.call()).then((response) {
          
        isPaymentLoading(false);

        if(response.status == 200) {
          DashboardController.to.fetchActiveOrders();

          if (response.code == 3506) {
            errorSnackbarTop(title: tr('oops'), message: tr('storeClosed'));
          } else {
            noteToRider.clear();
            if (response.paymentUrl == null) {
              print('NO URL');
              successSnackBarTop(title: tr('yay'), message: tr('successOrder'));

             
              clearCart(storeId);
              DashboardController.to.fetchActiveOrders();

              Future.delayed(Duration(seconds: 1)).then((value) {
                Get.back(closeOverlays: true);
              });

            } else {
              print('GO TO WEBVIEW: ${response.paymentUrl}');
              Get.toNamed(Config.WEBVIEW_ROUTE, arguments: {
                'url': response.paymentUrl,
                'order_id': response.data.id,
                'store_id': storeId,
                'type': Config.MART
              }).whenComplete(() => dismissKeyboard(Get.context));
            }
          }

        } else {
          
          if (response.code == 3006) {
            errorSnackbarTop(title: tr('oops'), message: response.message);
          } else {
            errorSnackbarTop(title: tr('oops'), message: tr('somethingWentWrong'));
          }
        }
        
      }).catchError((onError) {
        isPaymentLoading(false);
        if (onError.toString().contains('Connection failed')) message(tr('noInternetConnection')); else message(tr('somethingWentWrong'));
        print('Payment method: $onError');
      });
    }
  }

  clearCart(int storeId) {
    final prod = listProductFromJson(box.read(Config.PRODUCTS));
    prod.removeWhere((data) => data.storeId == storeId);
    box.write(Config.PRODUCTS, listProductToJson(prod));
    MartController.to.list.call().removeWhere((data) => data.storeId == storeId);
    getProducts();
  }

  Future<Null> refreshDeliveryFee() async => getDeliveryFee();

  getDeliveryFee() {
    message(tr('loadingCart'));
    isLoading(true);
    hasError(true);
    _apiService.getDeliveryFee(storeId: storeId.call()).then((response) {

      if (response.status == 200) {
        hasError(false);
        deliveryFee(double.tryParse(response.data.deliveryFee));
        getProducts();

      } else {
        hasError(true);
        message(tr('somethingWentWrong'));
      }

      isLoading(false);

    }).catchError((onError) {
      hasError(true);
      isLoading(false);
      message(tr('somethingWentWrong'));
      print('Delivery Fee Error: $onError');
    });
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

      print('Product ID: ${item.name} == Quantity: ${item.quantity} == Price: ${item.customerPrice} == User ID: ${item.userId} == removable: ${item.removable}');

      addToCart.call().add(
        AddToCart(
          productId: item.id,
          variants: null,
          additionals: null,
          quantity: item.quantity,
          note: null,
          removable: item.removable
        )
      );
    });

    if (newMap.isNotEmpty) {
      updatedProducts.call().assignAll(newMap.values);
      totalPrice(updatedProducts.call().map((e) => double.tryParse(e.customerPrice) * e.quantity).reduce((value, element) => value + element)).roundToDouble();
      subTotal(updatedProducts.call().map((e) => double.tryParse(e.customerPrice) * e.quantity).reduce((value, element) => value + element)).roundToDouble();
    } else {
      updatedProducts.call().clear();
    }
  }
}