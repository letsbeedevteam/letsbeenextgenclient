import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/addToCart.dart';
import 'package:letsbeeclient/models/getCart.dart';
import 'package:letsbeeclient/models/restaurant.dart';
import 'package:letsbeeclient/screens/cart/cart_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';

class MenuController extends GetxController {

  final ApiService apiService = Get.find();
  Completer<void> refreshCompleter;

  var menu = Menu().obs;
  var cart = CartData().obs;
  var countQuantity = 1.obs;
  var restaurantId = 0.obs;
  var choiceIds = List<ChoiceCart>().obs;
  var additionalIds =  List<AdditionalCart>().obs;
  var tFRequestController = TextEditingController();

  var isLoading = false.obs;
  var isAddToCartLoading = false.obs;
  var argument = Get.arguments;
  var message = ''.obs;

  var hasNoChoices = false.obs;

  @override
  void onInit() {
    refreshCompleter = Completer();
    menu.nil();
    cart.nil();
    if (argument['type'] == 'edit') {
      
      cart(CartData.fromJson(argument['cart']));
      
      countQuantity(cart.value.quantity);
      tFRequestController.text = cart.call().note == 'N/A' ? '' : cart.call().note;
      fetchMenuById();

    } else {
      
      restaurantId(argument['restaurantId']);
      menu(Menu.fromJson(argument['menu']));
    }

    super.onInit();
  }

  void _setRefreshCompleter() {
    refreshCompleter?.complete();
    refreshCompleter = Completer();
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

  Future<bool> onWillPopBack() async {
    Get.back(closeOverlays: true);
    return true;
  }

  updateSelectedChoice(int id, String name) {
    menu.update((val) {
      final getMenu = val.choices.where((element) => element.id == id).first;
      getMenu.options.forEach((data) { 
        data.selectedValue = name;
      });
    });
  }

  updateSelectedAdditional(int id, String name) {
    menu.update((val) {
      final getMenu = val.additionals.where((element) => element.id == id).first;
      getMenu.options.forEach((data) { 
        if (name == data.name) data.selectedValue = !data.selectedValue; else data.selectedValue = false;
      });
    });
  }

  addToCart() {
    
    isAddToCartLoading(true);
    choiceIds.clear();
    additionalIds.clear();

    if (menu.value.choices.isEmpty) {
      hasNoChoices(true);
    } else {
      hasNoChoices(false);
      menu.value.choices.forEach((choice) {
        choice.options.forEach((element) {
          if (element.name == element.selectedValue) {
            choiceIds.add(
              ChoiceCart(
                id: choice.id,
                optionId: element.name == element.selectedValue ? element.id : null
              )
            );
          }
        });
      });
    }

    menu.value.additionals.forEach((additional) {
      additionalIds.add(
        AdditionalCart(
          id: additional.id,
          optionIds: additional.options.where((element) => element.selectedValue).map((e) => e.id).toList()
        )
      );
    });

    var addToCart = AddToCart(
      restaurantId: restaurantId.call(),
      menuId: menu.call().id,
      choices: choiceIds,
      additionals: additionalIds.toList(),
      quantity: countQuantity.call(),
      note: tFRequestController.text
    );

    if (argument['type'] == 'edit') {
      updateCartRequest(addToCart);
    } else {

      if(hasNoChoices.call()) {
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
     apiService.updateCart(addToCart, cart.value.id).then((response) {
    
      if (response.status == 200) {
        CartController.to..cart.nil()..fetchActiveCarts(getRestaurantId: argument['restaurant_id']);
        successSnackBarTop(title: 'Updated Cart!', message: response.message, status: (status) => status == SnackbarStatus.CLOSED ? Get.back() : null);
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
    isAddToCartLoading(true);
    apiService.addToCart(addToCart).then((response) {
      
      if (response.status == 200) {
        // successSnackBarTop(title: 'Cart!', message: response.message, status: (status) => status == SnackbarStatus.CLOSED ? Get.offAndToNamed(Config.CART_ROUTE, arguments: restaurantId.value) : null);
        CartController.to.cart.nil();
        Get.offAndToNamed(Config.CART_ROUTE, arguments: restaurantId.call());
        isAddToCartLoading(true);
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

  fetchMenuById() {

    isLoading(true);
   
    apiService.getMenuById(restaurantId: argument['restaurant_id'], menuId: argument['restaurant_menu_id']).then((restaurant) {
      isLoading(false);
      _setRefreshCompleter();

      menu(restaurant);

      for (var item in cart.value.additionals) {
        print(item.name);
        menu.value.additionals.map((e) => e.options).forEach((element) {
            var name = item.picks.map((e) => e.name);
            name.forEach((additional) {
              element.where((element) => element.name.contains(additional)).forEach((element) {
                element.selectedValue = true;
              });
            });
        });
      }

      for (var item in cart.value.choices) {
        menu.value.choices.map((e) => e.options).forEach((element) {
          element.where((element) => item.pick.contains(element.name)).forEach((element) {
            element.selectedValue = item.pick;
          });
        });
      }
              
    }).catchError((onError) {
        isLoading(false);
        _setRefreshCompleter();
        if (onError.toString().contains('Connection failed')) message.value = Config.NO_INTERNET_CONNECTION; else message.value = Config.SOMETHING_WENT_WRONG;
        print('Error fetch restaurant: $onError');
    });
  }
}