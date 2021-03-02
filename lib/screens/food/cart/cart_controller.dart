import 'dart:async';

// import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
// import 'package:letsbeeclient/models/active_cart_response.dart';
import 'package:letsbeeclient/models/add_to_cart.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/food/restaurant/restaurant_controller.dart';
// import 'package:letsbeeclient/screens/food/restaurant/restaurant_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';

class CartController extends GetxController {

  final ApiService _apiService = Get.find();
  final GetStorage box = Get.find();
  final argument = Get.arguments;
  Completer<void> refreshCompleter;

  var message = ''.obs;
  var totalPrice = 0.0.obs;
  var subTotal = 0.0.obs;
  var isLoading = false.obs;
  var isPaymentLoading = false.obs;
  var isEdit = false.obs;
  var storeId = 0.obs;
  // var cart = ActiveCartResponse().obs;

  final streetTFController = TextEditingController();
  final barangayTFController = TextEditingController();
  final cityTFController = TextEditingController();

  final streetNode = FocusNode();
  final barangayNode = FocusNode();
  final cityNode = FocusNode();

  static CartController get to => Get.find();

  final addToCart = RxList<AddToCart>().obs;
  final updatedProducts = RxList<Product>().obs;
  
  var choicesTotalPrice = 0.00.obs;
  var additionalTotalPrice = 0.00.obs;

  @override
  void onInit() {
    // cart.nil();
    refreshCompleter = Completer();

    // fetchActiveCarts(getRestaurantId: 1);
 
    super.onInit();
  }

  Future<bool> onWillPopBack() async {
    isEdit(false);
    // fetchActiveCarts(storeId: storeId.call());
    Get.back(closeOverlays: true);
    return true;
  }

  // void _setRefreshCompleter() {
  //   refreshCompleter?.complete();
  //   refreshCompleter = Completer();
  // }

  setEdit() {
    isEdit(!isEdit.call());
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

  deleteCart({String uniqueId}) {
    // isLoading(true);
    Get.back();
    successSnackBarTop(title: 'Success!', message: 'Your item has been deleted', seconds: 1);
    final prod = listProductFromJson(box.read(Config.PRODUCTS));
    prod.removeWhere((data) => data.uniqueId == uniqueId);
    RestaurantController.to.list.call().removeWhere((data) => data.uniqueId == uniqueId);
    box.write(Config.PRODUCTS, listProductToJson(prod));
    getProducts();
  }

  paymentMethod(int storeId, String paymentMethod) {

    if (totalPrice.value < 100) {
      errorSnackbarTop(title: 'Alert', message: 'Please, the minimum transaction was ₱100');
    } else {
      isPaymentLoading(true);
      Get.back();

      // successSnackBarTop(title: 'Order processing..', message: 'Please wait...');

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
              RestaurantController.to.list.call().removeWhere((data) => data.storeId == storeId);
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

  getCurrentLocationText() {
    streetTFController.text = box.read(Config.USER_CURRENT_STREET);
    cityTFController.text = box.read(Config.USER_CURRENT_CITY);
    barangayTFController.text = box.read(Config.USER_CURRENT_BARANGAY);
  }

  saveConfirmLocation() {
    final address = '${streetTFController.text}, ${cityTFController.text}, ${barangayTFController.text}';
    box.write(Config.USER_CURRENT_STREET, streetTFController.text);
    box.write(Config.USER_CURRENT_CITY, cityTFController.text);
    box.write(Config.USER_CURRENT_BARANGAY, barangayTFController.text);
    box.write(Config.USER_CURRENT_ADDRESS, address);
    DashboardController.to.userCurrentAddress(address);
  }

  getProducts() {
    choicesTotalPrice(0.00);
    additionalTotalPrice(0.00);
    final products = listProductFromJson(box.read(Config.PRODUCTS)).where((data) => !data.isRemove && data.storeId == storeId.call());
    addToCart.call().clear();
    
    if (products.isNotEmpty) {

      updatedProducts.call().assignAll(products);
      updatedProducts.call().forEach((product) { 

          for (var j = 0;  j < product.choices.length; j++) {

            final choice =  product.choices[j];
            choice.options.where((data) => data.name == data.selectedValue).forEach((option) {
              choicesTotalPrice.value += double.tryParse(option.customerPrice.toString()) * product.quantity;
            });
          }

          product.additionals.forEach((additional) {
            if(!additional.selectedValue) {
              additionalTotalPrice.value += double.tryParse(additional.customerPrice.toString()) * product.quantity;
            }
          });
          
          addToCart.call().add(
            AddToCart(
              productId: product.id,
              choices: product.choices.isEmpty ? [] : product.choiceCart.toList(),
              additionals: product.additionals.where((element) => !element.selectedValue).map((e) => e.id).toList(),
              quantity: product.quantity,
              note: product.note
            )
          );
      });

      totalPrice(updatedProducts.call().map((e) => double.tryParse(e.customerPrice) * e.quantity).reduce((value, element) => value + element)).roundToDouble();
      subTotal(updatedProducts.call().map((e) => double.tryParse(e.customerPrice) * e.quantity).reduce((value, element) => value + element)).roundToDouble();
    } else {
      updatedProducts.call().clear();
    }
  }
}