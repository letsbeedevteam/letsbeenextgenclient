import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/getCart.dart';
import 'package:letsbeeclient/services/api_service.dart';

class CartController extends GetxController {

  final ApiService _apiService = Get.find();
  final GetStorage box = Get.find();
  final argument = Get.arguments;
  Completer<void> refreshCompleter;

  var userCurrentAddress = ''.obs;
  var message = ''.obs;
  var totalPrice = 0.0.obs;
  var isLoading = false.obs;
  var isPaymentLoading = false.obs;
  var isEdit = false.obs;
  var cart = GetCart(data: []).obs;
  
  @override
  void onInit() {
    refreshCompleter = Completer();
    userCurrentAddress(box.read(Config.USER_CURRENT_ADDRESS));

    fetchActiveCarts();
    
    super.onInit();
  }

  void _setRefreshCompleter() {
    refreshCompleter?.complete();
    refreshCompleter = Completer();
  }

  setEdit() {
    isEdit(!isEdit.call());
  }

  fetchActiveCarts() {
    isLoading(true);

    _apiService.getActiveCarts(restaurantId: argument).then((response) {
      isLoading(false);
        _setRefreshCompleter();
      if(response.status == 200) {

        if (response.data.isEmpty) {
          this.cart(response);
          this.message('No list of carts');
          this.isEdit(false);
        } else {
          totalPrice(response.data.map((e) => e.totalPrice).reduce((value, element) => value + element).roundToDouble());
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
        fetchActiveCarts();
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
      paymentSnackBarTop(title: 'Processing..', message: 'Please wait..');

      _apiService.createOrder(restaurantId: restaurantId, paymentMethod: paymentMethod).then((order) {
          
        isPaymentLoading(false);

        if(order.status == 200) {

          if (order.paymentUrl.isNull) {
            print('NO URL');
          } else {
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

        fetchActiveCarts();
        
      }).catchError((onError) {
        isPaymentLoading(false);
        if (onError.toString().contains('Connection failed')) message(Config.NO_INTERNET_CONNECTION); else message(Config.SOMETHING_WENT_WRONG);
        print('Payment method: $onError');
      });
    }
  }
}