import 'dart:async';

// import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/getCart.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';

class CartController extends GetxController {

  final ApiService _apiService = Get.find();
  final GetStorage box = Get.find();
  final argument = Get.arguments;
  Completer<void> refreshCompleter;

  var message = ''.obs;
  var totalPrice = 0.0.obs;
  var isLoading = false.obs;
  var isPaymentLoading = false.obs;
  var isEdit = false.obs;
  var restaurantId = 0.obs;
  var cart = GetCart().obs;

  static CartController get to => Get.find();
  @override
  void onInit() {
    this.cart.nil();
    refreshCompleter = Completer();
        
    if (restaurantId.call() != 0) {
      fetchActiveCarts(getRestaurantId: restaurantId.call());
    }
    
    super.onInit();
  }
  
  Future<bool> onWillPopBack() async {
    Get.back(closeOverlays: true);
    return true;
  }

  void _setRefreshCompleter() {
    refreshCompleter?.complete();
    refreshCompleter = Completer();
  }

  setEdit() {
    isEdit(!isEdit.call());
  }

  fetchActiveCarts({@required int getRestaurantId}) {
    isLoading(true);

    _apiService.getActiveCarts(restaurantId: getRestaurantId).then((response) {
      isLoading(false);
        _setRefreshCompleter();
      if(response.status == 200) {

        if (response.data.isEmpty) {
          this.cart.nil();
          this.message('No list of carts');
          this.isEdit(false);
        } else {
          totalPrice(response.data.map((e) => e.totalPrice).reduce((value, element) => value + element).roundToDouble());
          response.data.sort((b, a) => a.createdAt.compareTo(b.createdAt));
          this.cart(response);
        }
      
      } else {
        this.message(Config.SOMETHING_WENT_WRONG);
      }

    }).catchError((onError) {
      isLoading(false);
      _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) message(Config.NO_INTERNET_CONNECTION); else message(Config.SOMETHING_WENT_WRONG);
      print('Get cart: $onError');
    });
  }

  deleteCart({int cartId}) {
    isLoading(true);
    Get.back();
    deleteSnackBarTop(title: 'Deleting item..', message: 'Please wait..');

    _apiService.deleteCart(cartId).then((cart) {
      isLoading(false);
        _setRefreshCompleter();

      if(cart.status == 200) {
        fetchActiveCarts(getRestaurantId: restaurantId.call());
        successSnackBarTop(title: 'Success', message: cart.message);
      } else {
        errorSnackbarTop(title: 'Failed', message: Config.SOMETHING_WENT_WRONG);
      }
      
    }).catchError((onError) {
      isLoading(false);
        _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) message(Config.NO_INTERNET_CONNECTION); else message(Config.SOMETHING_WENT_WRONG);
      print('Delete cart: $onError');
    });
  }

  paymentMethod(int restaurantId, String paymentMethod) {

    if (totalPrice.value < 100) {
      errorSnackbarTop(title: 'Alert', message: 'Please, the minimum transaction was ₱100');
    } else {
      
      isPaymentLoading(true);
      Get.back();

      _apiService.createOrder(restaurantId: restaurantId, paymentMethod: paymentMethod).then((order) {
          
        isPaymentLoading(false);

        if(order.status == 200) {
          DashboardController.to.fetchActiveOrder();
          if (order.paymentUrl == null) {
            print('NO URL');
            successSnackBarTop(title: 'Success!', message: 'Please check your on going order');
          } else {
            paymentSnackBarTop(title: 'Processing..', message: 'Please wait..');
            print('GO TO WEBVIEW: ${order.paymentUrl}');
            Get.toNamed(Config.WEBVIEW_ROUTE, arguments: {
              'url': order.paymentUrl,
              'order_id': order.data.id
            });
          }

        } else {
          
          if (order.code == 3005) {
            errorSnackbarTop(title: 'Oops!', message: 'There\'s a pending request');
          } else  errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
        }

        fetchActiveCarts(getRestaurantId: restaurantId);
        
      }).catchError((onError) {
        isPaymentLoading(false);
        if (onError.toString().contains('Connection failed')) message(Config.NO_INTERNET_CONNECTION); else message(Config.SOMETHING_WENT_WRONG);
        print('Payment method: $onError');
      });
    }
  }
}