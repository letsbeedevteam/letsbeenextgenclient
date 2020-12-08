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

  CartController cartController;
  Completer<void> refreshCompleter;

  var menu = Menu(
    id: 0,
  ).obs;
  var cart = CartData().obs;
  var hasSelected = true.obs;
  var countQuantity = 1.obs;
  var restaurantId = 0.obs;
  var menuId = 0.obs;
  var choiceIds = List<ChoiceCart>().obs;
  var additionalIds =  List<AdditionalCart>().obs;
  var tFRequestController = TextEditingController();

  var isLoading = false.obs;
  var isAddToCartLoading = false.obs;
  var argument = Get.arguments;
  var message = ''.obs;

  @override
  void onInit() {
    refreshCompleter = Completer();
    if (argument['type'] == 'edit') {
      
      cartController = Get.find();
      cart.value = CartData.fromJson(argument['cart']);

      countQuantity.value = cart.value.quantity;
      tFRequestController.text = cart.value.note == 'N/A' ? '' : cart.value.note;
      fetchMenuById();

    } else {
      
      restaurantId.value = argument['restaurantId'];
      menuId.value = argument['menuId'];
      menu.value = Menu.fromJson(argument['menu']);
    }

    super.onInit();
  }

  void _setRefreshCompleter() {
    refreshCompleter?.complete();
    refreshCompleter = Completer();
  }

  void increment() {
    countQuantity.value++;
    update();
  }

  void decrement() {
    if (countQuantity.value <= 1) {
      countQuantity.value = 1;
    } else {
      countQuantity.value--;
    }
    update();
  }

  updateSelectedChoice(int id, String name) {

    var getMenu = menu.value.choices.where((element) => element.id == id).first;

    getMenu.options.forEach((data) { 
       data.selectedValue = name;
    });

    update();
  }

  updateSelectedAdditional(int id, String name) {
    var getMenu = menu.value.additionals.where((element) => element.id == id).first;
    getMenu.options.forEach((data) { 
      if (name == data.name) data.selectedValue = !data.selectedValue;
    });

    update();
  }

  addToCart() {
    
    isAddToCartLoading.value = true;
    choiceIds.clear();
    additionalIds.clear();

    menu.value.choices.forEach((choice) {
      choice.options.forEach((element) {
        hasSelected.value = element.selectedValue != null;
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

    menu.value.additionals.forEach((additional) {
      additionalIds.add(
        AdditionalCart(
          id: additional.id,
          optionIds: additional.options.where((element) => element.selectedValue).map((e) => e.id).toList()
        )
      );
    });

    if (argument['type'] == 'edit')  hasSelected.value = true;

    if (!hasSelected.value) {
      errorSnackbarTop(title: 'Oops!', message: 'Please choose your required option(s)');
      isAddToCartLoading.value = false;
      update();
    } else {

      var addToCart = AddToCart(
        restaurantId: restaurantId.value,
        menuId: menuId.value,
        choices: choiceIds,
        additionals: additionalIds.toList(),
        quantity: countQuantity.value,
        note: tFRequestController.text
      );

      if (argument['type'] == 'edit') {
        updateCartRequest(addToCart);
      } else {
        sendCartRequest(addToCart);
      }
    }

    update();
  }

  updateCartRequest(AddToCart addToCart) {
    Future.delayed(Duration(seconds: 2)).then((value) {

        apiService.updateCart(addToCart, cart.value.id).then((value) {
        
          if (value.status == 200) {
            cartController.fetchActiveCarts();
            successSnackBarTop(title: 'Updated Cart!', message: value.message, status: (status) => status == SnackbarStatus.CLOSED ? Get.back() : null);
          } else {
            errorSnackbarTop(title: 'Oops!', message: value.message);
          }

          isAddToCartLoading.value = false;
          update();

        }).catchError((onError) {
          isAddToCartLoading.value = false;
          errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
          update();
          print('Add to cart error: ${onError.toString()}');
        });
      });
  }

  sendCartRequest(AddToCart addToCart) {
    isAddToCartLoading.value = true;
    Future.delayed(Duration(seconds: 2)).then((value) {

      apiService.addToCart(addToCart).then((value) {
      
        if (value.status == 200) {
          successSnackBarTop(title: 'Cart!', message: value.message, status: (status) => status == SnackbarStatus.CLOSED ? Get.offAndToNamed(Config.CART_ROUTE, arguments: restaurantId.value) : null);
        } else {
          
          if (value.code == 3005) errorSnackbarTop(title: 'Oops!', message: "There\'s a pending order"); else errorSnackbarTop(title: 'Oops!', message: value.message);
        }

        isAddToCartLoading.value = false;
        update();

      }).catchError((onError) {
        isAddToCartLoading.value = false;
        errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
        update();
        print('Add to cart error: ${onError.toString()}');
      });
    });

    update();
  }

  fetchMenuById() {

    isLoading.value = true;
   
    Future.delayed(Duration(seconds: 2)).then((value) {

      apiService.getMenuById(restaurantId: argument['restaurant_id'], menuId: argument['restaurant_menu_id']).then((restaurant) {
        isLoading.value = false;
        _setRefreshCompleter();

        menu.value = restaurant;

        for (var item in cart.value.additionals) {
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
        
        update();
        
      }).catchError((onError) {
          isLoading.value = false;
          _setRefreshCompleter();
          if (onError.toString().contains('Connection failed')) message.value = Config.NO_INTERNET_CONNECTION; else message.value = Config.SOMETHING_WENT_WRONG;
          print('Error fetch restaurant: $onError');
          update();
      });

    });
  }
}