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
  Completer<void> refreshCompleter;

  var userCurrentAddress = ''.obs;
  var message = ''.obs;
  var totalPrice = ''.obs;
  var isLoading = false.obs;
  var isEdit = false.obs;
  var cart = GetCart(data: []).obs;
  
  @override
  void onInit() {
    refreshCompleter = Completer();
    userCurrentAddress.value = box.read(Config.USER_CURRENT_ADDRESS);

    fetchActiveCarts();
    
    super.onInit();
  }

  void _setRefreshCompleter() {
    refreshCompleter?.complete();
    refreshCompleter = Completer();
  }

  setEdit() {
    isEdit.value = !isEdit.value;
    update();
  }

  fetchActiveCarts() {
    isLoading.value = true;

    Future.delayed(Duration(seconds: 2)).then((value) {
      
      _apiService.getActiveCarts().then((cart) {
        isLoading.value = false;
         _setRefreshCompleter();
        if(cart.status == 200) {

          if (cart.data.isEmpty) {
            this.cart.value = cart;
            this.message.value = 'No list of carts';
            this.isEdit.value = false;
          } else {
            totalPrice.value = cart.data.map((e) => e.totalPrice).reduce((value, element) => value + element).toStringAsFixed(2);
            this.cart.value = cart;
          }
       
        } else {
          this.message.value = Config.SOMETHING_WENT_WRONG;
        }
        update();

      }).catchError((onError) {
        isLoading.value = false;
         _setRefreshCompleter();
        if (onError.toString().contains('Connection failed')) message.value = Config.NO_INTERNET_CONNECTION; else message.value = Config.SOMETHING_WENT_WRONG;
        print('Get cart: $onError');
        update();
      });
    });
  }

  deleteCart({int cartId}) {
    isLoading.value = true;
    Get.back();
    deleteSnackBarTop(title: 'Deleting item..', message: 'Please wait..');

    Future.delayed(Duration(seconds: 2)).then((value) {
      
      _apiService.deleteCart(cartId).then((cart) {
        isLoading.value = false;
         _setRefreshCompleter();

        if(cart.status == 200) {
          fetchActiveCarts();
          successSnackBarTop(title: 'Success', message: cart.message);
        } else {
          errorSnackbarTop(title: 'Failed', message: 'Item already deleted');
        }
        
        update();

      }).catchError((onError) {
        isLoading.value = false;
         _setRefreshCompleter();
        if (onError.toString().contains('Connection failed')) message.value = Config.NO_INTERNET_CONNECTION; else message.value = Config.SOMETHING_WENT_WRONG;
        print('Delete cart: $onError');
        update();
      });
    });
  }

  paymentMethod(int restaurantId, String paymentMethod) {
    isLoading.value = true;
    Get.back();
    paymentSnackBarTop(title: 'Processing..', message: 'Please wait..');

    Future.delayed(Duration(seconds: 2)).then((value) {
      
      _apiService.createOrder(restaurantId: restaurantId, paymentMethod: paymentMethod).then((value) {
        
        isLoading.value = false;

        if(value.status == 200) {
          print('URL: ${value.paymentUrl}');
          fetchActiveCarts();
        }
        
      }).catchError((onError) {
        isLoading.value = false;
        errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
        print('Payment method: $onError');
      });

    });
  }
}