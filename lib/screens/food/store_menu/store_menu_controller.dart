import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/active_cart_response.dart';
import 'package:letsbeeclient/models/add_to_cart.dart';
// import 'package:letsbeeclient/models/getCart.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';

class StoreMenuController extends GetxController {
  
  ApiService apiService = Get.find();
  Completer<void> refreshCompleter;

  var product = Product().obs;
  final argument = Get.arguments;

  var choiceIds = List<ChoiceCart>().obs;
  var additionalIds =  List<AdditionalCart>().obs;

  var isAddToCartLoading = false.obs;
  var isLoading = false.obs;

  var countQuantity = 1.obs; 
  var hasChoices = false.obs;

  var message = ''.obs;

  var hasError = false.obs;

  var tFRequestController = TextEditingController();

  var cart = ActiveCartData().obs;

  @override
  void onInit() {
    cart.nil();
    product.nil();
    if (argument['type'] == 'edit') {
      
      cart(ActiveCartData.fromJson(argument['cart']));
      
      countQuantity(cart.value.quantity);
      tFRequestController.text = cart.call().note == null ? '' : cart.call().note;
      fetchProductById();

    } else {
      
      product(Product.fromJson(argument['product']));
    }
   
    super.onInit();
  }

  void _setRefreshCompleter() {
    refreshCompleter?.complete();
    refreshCompleter = Completer();
  }

  Future<bool> onWillPopBack() async {
    Get.back(closeOverlays: true);
    return true;
  }

  void increment() {
    countQuantity.value++;
  }

  void decrement() {
    if (countQuantity.value <= 1) {
      countQuantity(1);
    } else {
      countQuantity.value--;
    }
  }

  updateSelectedChoice(int id, String name) {
    product.update((val) {
      final getMenu = val.choices.where((element) => element.id == id).first;
      getMenu.choiceDefault = name;
    });
  }

  updateSelectedAdditional(int id, String name) {
    product.update((val) {
      val.additionals.forEach((data) {
        if (name == data.name) data.status = !data.status;
      });
    });
  }

  addToCart() {
    
    isAddToCartLoading(true);
    choiceIds.clear();
    additionalIds.clear();

    if (product.value.choices.isEmpty) {
      hasChoices(false);
    } else {
      hasChoices(true);
      product.value.choices.forEach((choice) {
        choice.options.forEach((element) {
          if (element.name == choice.choiceDefault) {
            choiceIds.add(
              ChoiceCart(
                id: choice.id,
                optionId: element.name == choice.choiceDefault ? element.id : null
              )
            );
          }
        });
      });
    }

    additionalIds.add(
      AdditionalCart(
        id: product.call().additionals.where((element) => !element.status).map((e) => e.id).toList(),
      )
    );

    var addToCart = AddToCart(
      storeId: product.call().storeId,
      productId: product.call().id,
      choices: choiceIds.call(),
      additionals: additionalIds.call().first.id,
      quantity: countQuantity.call(),
      note: tFRequestController.text
    );


    if(argument['type'] == 'edit') {
      updateCartRequest(addToCart);
    } else {

      if(!hasChoices.call()) {
        sendCartRequest(addToCart);
      } else {
        if (choiceIds.isNotEmpty) {
          sendCartRequest(addToCart);
        } else {
          isAddToCartLoading(false);
          errorSnackbarTop(title: 'Oops!', message: 'Please select your required choices');
        }
      }
    }
  }

  updateCartRequest(AddToCart addToCart) {
    print(addToCart.toJson());
    apiService.updateCart(addToCart, cart.call().id).then((response) {
    
      if (response.status == 200) {
        Future.delayed(Duration(milliseconds: 500)).then((data) {
          CartController.to..cart.nil()..fetchActiveCarts(storeId: product.call().storeId, callback: () {
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
        isAddToCartLoading(true);
      } else {
        errorSnackbarTop(title: 'Oops!', message: response.message);
        isAddToCartLoading(false);
      }

    }).catchError((onError) {
      isAddToCartLoading(true);
      errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
      print('Add to cart error: ${onError.toString()}');
    });
  }

  sendCartRequest(AddToCart addToCart) {
    print(addToCart.toJson());
    isAddToCartLoading(true);
    apiService.addToCart(addToCart).then((response) {
      
      if (response.status == 200) {
        CartController.to
        ..cart.nil()
        ..fetchActiveCarts(storeId: product.call().storeId, callback: ()  {
          Future.delayed(Duration(seconds: 1)).then((data) {
            Get.back();
            isAddToCartLoading(true);
          });
        });

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

   fetchProductById() {

    isLoading(true);
    hasError(false);
    message('Loading...');

    apiService.getProductById(productId: argument['product_id']).then((restaurant) {
      isLoading(false);
      hasError(false);
      _setRefreshCompleter();

      product(restaurant);

      for (var item in cart.call().choices) {
        
        product.call().choices.forEach((choice) {
          choice.choiceDefault = item.pick;
        });
      }

      for (var item in cart.call().additionals) {
        print(item.name);
        product.call().additionals.forEach((choice) {
          if (item.name == choice.name) {
            choice.status = false;
          }
        });
      }
  
    }).catchError((onError) {
      hasError(true);
      isLoading(false);
      message(Config.SOMETHING_WENT_WRONG);
      _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) message.value = Config.NO_INTERNET_CONNECTION; else message.value = Config.SOMETHING_WENT_WRONG;
      print('Error fetch restaurant: $onError');
    });
  }
}