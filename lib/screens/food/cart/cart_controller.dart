import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/add_to_cart.dart';
import 'package:letsbeeclient/models/create_order_response.dart';
import 'package:letsbeeclient/models/get_delivery_fee_response.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';

class CartController extends GetxController {

  final ApiService _apiService = Get.find();
  final GetStorage box = Get.find();
  final argument = Get.arguments;
  Completer<void> refreshCompleter;

  var totalPrice = 0.0.obs;
  var subTotal = 0.0.obs;
  var storeId = 0.obs;
  var deliveryFee = 0.0.obs;

  var isLoading = false.obs;
  var isPaymentLoading = false.obs;
  var isEdit = false.obs;
  var hasError = false.obs;

  var message = ''.obs;

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

  final tFRequestController = TextEditingController();
  var product = Product().obs;
  var quantity = 1.obs;
  var totalPriceOfChoice = 0.00.obs;
  var additionals = List<Additional>().obs;
  var options = List<Option>().obs;
  var choiceCart = RxMap<int, ChoiceCart>().obs;
  var totalPriceOfAdditional = 0.00.obs;

  StreamSubscription<CreateOrderResponse> createOrderSub;
  StreamSubscription<GetDeliveryFeeResponse> deliveryFeeSub;

  final dashboard = DashboardController.to;
  
  @override
  void onInit() {
    refreshCompleter = Completer();

    if (argument != null) {
      storeId(argument['storeId']);
    }
    if(box.hasData(Config.PRODUCTS)) getProducts();

 
    super.onInit();
  }

  Future<bool> onWillPopBack() async {
    createOrderSub?.cancel()?.whenComplete(() {
      isPaymentLoading(false);
      isLoading(false);
    });
    deliveryFeeSub?.cancel()?.whenComplete(() {
      isPaymentLoading(false);
      isLoading(false);
    });
    isEdit(false);
    Get.back(closeOverlays: true);
    dashboard.updateCart();
    return true;
  }

  setEdit() => isEdit(!isEdit.call());

  deleteCart({String uniqueId}) {
    Get.back();
    successSnackBarTop(message: tr('deletedItem'), seconds: 1);
    final prod = listProductFromJson(box.read(Config.PRODUCTS));
    prod.removeWhere((data) => data.uniqueId == uniqueId);
    box.write(Config.PRODUCTS, listProductToJson(prod));
    getProducts();
  }

  paymentMethod(int storeId, String paymentMethod) {

    if (totalPrice.value < 100) {
      errorSnackbarTop(message: tr('minimumTransaction'));
    } else {
      isPaymentLoading(true);
      Get.back();

      // successSnackBarTop(title: 'Order processing..', message: 'Please wait...');

      createOrderSub = _apiService.createOrder(storeId: storeId, paymentMethod: paymentMethod, carts: addToCart.call()).asStream().listen((response) {
          
        isPaymentLoading(false);

        if(response.status == Config.OK) {
          
          if (response.status == Config.INVALID) {
            errorSnackbarTop(title: tr('oops'), message: tr('storeClosed'));
          } else {
            if (response.paymentUrl == null) {
              print('NO URL');
              
              Get.back(closeOverlays: true);
              dashboard.fetchActiveOrders(activeOrderid: response.data.id, function: () {
                clearCart(storeId);
              });
              
            } else {
              // paymentSnackBarTop(title: 'Processing..', message: 'Please wait..');
              print('GO TO WEBVIEW: ${response.paymentUrl}');
              // fetchActiveCarts(storeId: storeId);
              Get.toNamed(Config.WEBVIEW_ROUTE, arguments: {
                'url': response.paymentUrl,
                'order_id': response.data.id,
                'store_id': storeId,
                'type': Config.RESTAURANT
              });
            }
          }

        } else {
          errorSnackbarTop(title: tr('oops'), message: response.errorMessage);
        }
        
      })..onError((onError) {
        isPaymentLoading(false);
        if (onError.toString().contains('Connection failed')) message(tr('noInternetConnection')); else message(tr('somethingWentWrong'));
        print('Payment method: $onError');
      });
    }
  }

  Future<Null> refreshDeliveryFee() async => getDeliveryFee();

  getDeliveryFee() {
    if (updatedProducts.call().isNotEmpty) {
      message(tr('loadingCart'));
      isLoading(true);
      hasError(true);
      deliveryFeeSub = _apiService.getDeliveryFee(storeId: storeId.call()).asStream().listen((response) {

        if (response.status == Config.OK) {
          hasError(false);
          deliveryFee(double.tryParse(response.data.deliveryFee));

        } else {
          hasError(true);
          message(tr('somethingWentWrong'));
        }

        isLoading(false);

      })..onError((onError) {
        hasError(true);
        isLoading(false);
        message(tr('somethingWentWrong'));
        print('Delivery Fee Error: $onError');
      });
    }
  }

  clearCart(int storeId) {
    final prod = listProductFromJson(box.read(Config.PRODUCTS));
    prod.removeWhere((data) => data.storeId == storeId);
    box.write(Config.PRODUCTS, listProductToJson(prod));
    getProducts();
  }

  getProducts() {
    if(box.hasData(Config.PRODUCTS)) {
      choicesTotalPrice(0.00);
      additionalTotalPrice(0.00);
      final products = listProductFromJson(box.read(Config.PRODUCTS)).where((data) => data.storeId == storeId.call());
      addToCart.call().clear();
      options.clear();
      additionals.clear();
      
      if (products.isNotEmpty) {

        updatedProducts.call().assignAll(products);
        updatedProducts.call().forEach((product) { 

            for (var j = 0;  j < product.variants.length; j++) {

              final choice =  product.variants[j];
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
                variants: product.variants.isEmpty ? [] : product.choiceCart.toList(),
                additionals: product.additionals.isEmpty ? [] : product.additionalCart.toList(),
                quantity: product.quantity,
                note: product.note,
                removable: product.removable
              )
            );
        });

        totalPrice(updatedProducts.call().map((e) => double.tryParse(e.customerPrice) * e.quantity).reduce((value, element) => value + element)).roundToDouble();
        subTotal(updatedProducts.call().map((e) => double.tryParse(e.customerPrice) * e.quantity).reduce((value, element) => value + element)).roundToDouble();
      } else {
        updatedProducts.call().clear();
      }
    } else {
      updatedProducts.call().clear();
    }
  }

  void updateChoices(int id, Option option) {
    product.update((val) {
      val.variants.where((element) => element.id == id).forEach((choice) {
        choice.options.forEach((data) { 
          if (data.name == option.name) {
            data.selectedValue = option.name;
            options.add(data);
          } else {
            data.selectedValue = null;
            options.remove(data);
          }

          choiceCart.call()[id] = ChoiceCart(
            id: id,
            optionId: option.id
          );

        });
      });
    });

    totalPriceOfChoice(options.where((data) => data.status).map((data) => double.tryParse(data.customerPrice.toString())).reduce((value, element) => value + element).toDouble());
    update();
  }

  void updateAdditionals(int id, Additional additional) {
    product.update((val) {
      val.additionals.forEach((data) {
        if (additional.name == data.name) {
          data.selectedValue = !data.selectedValue;
          if (!data.selectedValue) {
            additionals.add(additional);
          } else {
            additionals.remove(additional);
          }
        } 
      });
    });

    if (additionals.isEmpty) {
      totalPriceOfAdditional(0.00);
    } else {
      totalPriceOfAdditional(additionals.where((data) => !data.selectedValue).map((data) => double.tryParse(data.customerPrice.toString())).reduce((value, element) => value + element).toDouble());
    }

    update();
  }

  void updateCart(Product product) {
    product.note = tFRequestController.text.trim().isEmpty ? null : tFRequestController.text;
    product.quantity = quantity.call();
    product.choiceCart = choiceCart.call().values.toList();
    product.additionalCart = additionals.where((element) => !element.selectedValue).map((data) => data.id).toList();

    final check = updatedProducts.call().where((data) => data.uniqueId != product.uniqueId);
    final choice = check.where((data) => choicesToJson2(data.choiceCart).contains(choicesToJson2(product.choiceCart)));
    final additional = check.where((data) => additionalsToJson2(data.additionalCart).contains(additionalsToJson2(product.additionalCart)));
    
    if (choice.isNotEmpty && additional.isNotEmpty) {
      final filtered = check.singleWhere((data) => data.uniqueId != product.uniqueId && choicesToJson2(data.choiceCart).contains(choicesToJson2(product.choiceCart)) && additionalsToJson2(data.additionalCart).contains(additionalsToJson2(product.additionalCart)));
      filtered.quantity = filtered.quantity + quantity.call();
      filtered.choiceCart = product.choiceCart;
      filtered.additionalCart = product.additionalCart;
      filtered.note = product.note;
      updatedProducts.call().removeWhere((data) => data.uniqueId == product.uniqueId);
    } else {
      updatedProducts.call().where((data) => data.uniqueId == product.uniqueId).forEach((data) => data = product);
    }

    box.write(Config.PRODUCTS, listProductToJson(updatedProducts.call()));
    getProducts();
    Get.back();
    successSnackBarTop(message: tr('updatedItem'), seconds: 1);
  }

  void increment() {
    quantity.value++;
  }

  void decrement() {
    if (quantity.value <= 1) {
      quantity(1);
    } else {
      quantity.value--;
    }
  }

  void refreshProduct(Product getProduct) {
    product(getProduct);
    quantity(product.call().quantity);
    tFRequestController.clear();
    tFRequestController.text = product.call().note;
    options.clear();
    additionals.clear();
    choiceCart.call().clear();

    if (product.call().variants.isNotEmpty) {
      product.call().variants.forEach((choice) {
        choice.options.forEach((data) { 
          if (data.name == data.selectedValue) {
            options.add(data);
            choiceCart.call()[choice.id] = ChoiceCart(
              id: choice.id,
              optionId: data.id
            );
          }
        });
      });

      totalPriceOfChoice(options.where((data) => data.status).map((data) => double.tryParse(data.customerPrice.toString())).reduce((value, element) => value + element).toDouble());
    }

    if (product.call().additionals.isNotEmpty) {
      
      product.call().additionals.forEach((data) {
        if (!data.selectedValue) {
          additionals.add(data);
        } 
      });
      
      if (additionals.isEmpty) {
        totalPriceOfAdditional(0.00);
      } else {
        totalPriceOfAdditional(additionals.where((data) => !data.selectedValue).map((data) => double.tryParse(data.customerPrice.toString())).reduce((value, element) => value + element).toDouble());
      }
    }
    
    update();
  }
}