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

  final streetTFController = TextEditingController();
  final barangayTFController = TextEditingController();
  final cityTFController = TextEditingController();

  final streetNode = FocusNode();
  final barangayNode = FocusNode();
  final cityNode = FocusNode();

  static CartController get to => Get.find();

  @override
  void onInit() {
    refreshCompleter = Completer();

    // fetchActiveCarts(getRestaurantId: 1);
 
    super.onInit();
  }

  Future<bool> onWillPopBack() async {
    isEdit(false);
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

  fetchActiveCarts({@required int getRestaurantId, Function callback}) {
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
          totalPrice(response.data.map((e) => double.tryParse(e.totalPrice)).reduce((value, element) => value + element).roundToDouble());
          response.data.sort((b, a) => a.createdAt.compareTo(b.createdAt));
          this.cart(response);
        }

        callback();
      
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

    Future.delayed(Duration(seconds: 2)).then((value) {
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
          DashboardController.to.fetchActiveOrders();
          if (order.paymentUrl == null) {
            print('NO URL');
            successSnackBarTop(title: 'Success!', message: 'Please check your on going order');

            Future.delayed(Duration(seconds: 1)).then((value) {
              fetchActiveCarts(getRestaurantId: restaurantId);
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
            fetchActiveCarts(getRestaurantId: restaurantId);
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
    final address = '${streetTFController.text} ${cityTFController.text} ${barangayTFController.text}';
    box.write(Config.USER_CURRENT_STREET, streetTFController.text);
    box.write(Config.USER_CURRENT_CITY, cityTFController.text);
    box.write(Config.USER_CURRENT_BARANGAY, barangayTFController.text);
    box.write(Config.USER_CURRENT_ADDRESS, address);
    DashboardController.to.userCurrentAddress(address);
  }
}