import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/active_cart_response.dart';
import 'package:letsbeeclient/models/add_to_cart.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';

class StoreCartController extends GetxController {

  final ApiService _apiService = Get.find();
  final GetStorage box = Get.find();
  final argument = Get.arguments;
  Completer<void> refreshCompleter;

  var message = ''.obs;
  var totalPrice = 0.0.obs;
  var isLoading = false.obs;
  var isPaymentLoading = false.obs;
  var isUpdateCartLoading = false.obs;
  var isEdit = false.obs;
  var storeId = 0.obs;
  var cart = ActiveCartResponse().obs;
  var quantity = 0.obs;
  
  final streetTFController = TextEditingController();
  final barangayTFController = TextEditingController();
  final cityTFController = TextEditingController();

  final streetNode = FocusNode();
  final barangayNode = FocusNode();
  final cityNode = FocusNode();

  var product = Product().obs;

  static StoreCartController get to => Get.find();
  
  @override
  void onInit() {
    cart.nil();
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

  void _setRefreshCompleter() {
    refreshCompleter?.complete();
    refreshCompleter = Completer();
  }

  Future<bool> onWillPopBack() async {
    isEdit(false);
    isUpdateCartLoading(false);
    fetchActiveCarts(storeId: storeId.call());
    Get.back(closeOverlays: true);
    return true;
  }

  fetchActiveCarts({@required int storeId, Function callback}) {
    isLoading(true);

    _apiService.getActiveCarts(storeId: storeId).then((response) {
      isLoading(false);
      _setRefreshCompleter();
      if(response.status == 200) {

        if (response.data.isEmpty) {
          this.cart.nil();
          this.message('No list of carts');
          this.isEdit(false);
        } else {
          totalPrice(response.data.map((e) => double.tryParse(e.totalPrice.toString())).reduce((value, element) => value + element).roundToDouble());
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

  updateCartRequest(ActiveCartData data) {
    isUpdateCartLoading(true);
    var addToCart = AddToCart(
      storeId: data.storeId,
      productId: data.id,
      choices: [],
      additionals: [],
      quantity: quantity.call(),
      note: null
    );

    _apiService.updateCart(addToCart, data.id).then((response) {
    
      if (response.status == 200) {
        Future.delayed(Duration(milliseconds: 500)).then((data) {
          StoreCartController.to..cart.nil()..fetchActiveCarts(storeId: storeId.call(), callback: () {
            isUpdateCartLoading(false);
            if(Get.isSnackbarOpen) {
              Get.back();
              Future.delayed(Duration(milliseconds: 500));
              Get.back();
            } else {
              Get.back();
            }
          });
        });
        successSnackBarTop(title: 'Updated Cart!', message: '${response.message} Please wait...');
      } else {
        errorSnackbarTop(title: 'Oops!', message: response.message);
        isUpdateCartLoading(false);
      }

    }).catchError((onError) {
      isUpdateCartLoading(false);
      errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
      print('Add to cart error: ${onError.toString()}');
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
          fetchActiveCarts(storeId: storeId.call());
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

  paymentMethod(int storeId, String paymentMethod) {

    if (totalPrice.value < 100) {
      errorSnackbarTop(title: 'Alert', message: 'Please, the minimum transaction was ₱100');
    } else {
      
      isPaymentLoading(true);
      Get.back();

      _apiService.createOrder(storeId: storeId, paymentMethod: paymentMethod).then((order) {
          
        isPaymentLoading(false);

        if(order.status == 200) {
          DashboardController.to.fetchActiveOrders();
          if (order.paymentUrl == null) {
            print('NO URL');
            successSnackBarTop(title: 'Success!', message: 'Please check your on going order');

            Future.delayed(Duration(seconds: 1)).then((value) {
              fetchActiveCarts(storeId: storeId);
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
            fetchActiveCarts(storeId: storeId);
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
    final address = '${streetTFController.text}, ${cityTFController.text}, ${barangayTFController.text}';
    box.write(Config.USER_CURRENT_STREET, streetTFController.text);
    box.write(Config.USER_CURRENT_CITY, cityTFController.text);
    box.write(Config.USER_CURRENT_BARANGAY, barangayTFController.text);
    box.write(Config.USER_CURRENT_ADDRESS, address);
    DashboardController.to.userCurrentAddress(address);
  }
}