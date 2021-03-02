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
import 'package:letsbeeclient/screens/mart/store/store_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';

class StoreCartController extends GetxController {

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

  static StoreCartController get to => Get.find();
  
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

  // void _setRefreshCompleter() {
  //   refreshCompleter?.complete();
  //   refreshCompleter = Completer();
  // }

  Future<bool> onWillPopBack() async {
    isEdit(false);
    isUpdateCartLoading(false);
    // fetchActiveCarts(storeId: storeId.call());
    Get.back(closeOverlays: true);
    return true;
  }

  // fetchActiveCarts({@required int storeId, Function callback}) {
  //   isLoading(true);

  //   _apiService.getActiveCarts(storeId: storeId).then((response) {
  //     isLoading(false);
  //     _setRefreshCompleter();
  //     if(response.status == 200) {

  //       if (response.data.isEmpty) {
  //         this.cart.nil();
  //         this.message('No list of carts');
  //         this.isEdit(false);
  //       } else {
  //         totalPrice(response.data.map((e) => double.tryParse(e.customerTotalPrice.toString()) + response.deliveryFee).reduce((value, element) => value + element).roundToDouble());
  //         subTotal(response.data.map((e) => double.tryParse(e.totalPrice.toString())).reduce((value, element) => value + element).roundToDouble());
  //         print('HAHHA $totalPrice');
  //         response.data.sort((b, a) => a.createdAt.compareTo(b.createdAt));
  //         this.cart(response);
  //       }

  //       callback();
      
  //     } else {
  //       this.message(Config.SOMETHING_WENT_WRONG);
  //     }

  //   }).catchError((onError) {
  //     isLoading(false);
  //     _setRefreshCompleter();
  //     if (onError.toString().contains('Connection failed')) message(Config.NO_INTERNET_CONNECTION); else message(Config.SOMETHING_WENT_WRONG);
  //     print('Get cart: $onError');
  //   });
  // }

  updateCartRequest({Product product}) {
    Get.back();
    successSnackBarTop(title: 'Success!', message: 'Your item has been updated', seconds: 1);
  
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
    successSnackBarTop(title: 'Success!', message: 'Your item has been deleted', seconds: 1);
    final prod = listProductFromJson(box.read(Config.PRODUCTS));
    prod.removeWhere((data) => data.uniqueId == uniqueId);
    box.write(Config.PRODUCTS, listProductToJson(prod));
    StoreController.to.list.call().removeWhere((data) => data.uniqueId == uniqueId);
    getProducts();
  }

  paymentMethod(int storeId, String paymentMethod) {
    print('storeId: $storeId');
    if (totalPrice.value < 100) {
      errorSnackbarTop(title: 'Alert', message: 'Please, the minimum transaction was ₱100');
    } else {

      isPaymentLoading(true);
      Get.back();

      _apiService.createOrder(storeId: storeId, paymentMethod: paymentMethod, carts: addToCart.call()).then((order) {
          
        isPaymentLoading(false);

        if(order.status == 200) {
          DashboardController.to.fetchActiveOrders();

          if (order.code == 3506) {
            errorSnackbarTop(title: 'Oops!', message: 'The store has been closed');
          } else {
            if (order.paymentUrl == null) {
              print('NO URL');
              successSnackBarTop(title: 'Success!', message: 'Please check your on going order');

              final prod = listProductFromJson(box.read(Config.PRODUCTS));
              prod.removeWhere((data) => data.storeId == storeId);
              box.write(Config.PRODUCTS, listProductToJson(prod));
              StoreController.to.list.call().removeWhere((data) => data.storeId == storeId);
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
              print('GO TO WEBVIEW: ${order.paymentUrl}');
              // fetchActiveCarts(storeId: storeId);
              Get.toNamed(Config.WEBVIEW_ROUTE, arguments: {
                'url': order.paymentUrl,
                'order_id': order.data.id
              });
            }
          }

        } else {
          
          if (order.code == 3005) {
            errorSnackbarTop(title: 'Oops!', message: 'There\'s a pending request');
          } else  errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
        }
        
      }).catchError((onError) {
        isPaymentLoading(false);
        if (onError.toString().contains('Connection failed')) message(Config.NO_INTERNET_CONNECTION); else message(Config.SOMETHING_WENT_WRONG);
        print('Payment method: $onError');
      });
    }
  }

  // getCurrentLocationText() {
  //   streetTFController.text = box.read(Config.USER_CURRENT_STREET);
  //   cityTFController.text = box.read(Config.USER_CURRENT_CITY);
  //   barangayTFController.text = box.read(Config.USER_CURRENT_BARANGAY);
  // }

  // saveConfirmLocation() {
  //   final address = '${streetTFController.text}, ${cityTFController.text}, ${barangayTFController.text}';
  //   box.write(Config.USER_CURRENT_STREET, streetTFController.text);
  //   box.write(Config.USER_CURRENT_CITY, cityTFController.text);
  //   box.write(Config.USER_CURRENT_BARANGAY, barangayTFController.text);
  //   box.write(Config.USER_CURRENT_ADDRESS, address);
  //   DashboardController.to.userCurrentAddress(address);
  // }

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