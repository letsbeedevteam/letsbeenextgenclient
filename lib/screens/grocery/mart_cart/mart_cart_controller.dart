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

class MartCartController extends GetxController {

  final ApiService _apiService = Get.find();
  final GetStorage box = Get.find();
  final argument = Get.arguments;
  Completer<void> refreshCompleter;

  var totalPrice = 0.0.obs;
  var subTotal = 0.0.obs;
  var storeId = 0.obs;
  var deliveryFee = 0.0.obs;
  
  var quantity = 0.obs;

  var message = ''.obs;

  var hasError = false.obs;
  var isLoading = false.obs;
  var isPaymentLoading = false.obs;
  var isEdit = false.obs;
  
  final noteToRider = TextEditingController();
  final noteToRiderNode = FocusNode();

  final addToCart = RxList<AddToCart>().obs;
  final updatedProducts = RxList<Product>().obs;

  StreamSubscription<CreateOrderResponse> createOrderSub;
  StreamSubscription<GetDeliveryFeeResponse> deliveryFeeSub;
  
  static MartCartController get to => Get.find();

  @override
  void onInit() {
    // cart.nil();
    if (argument != null) {
      storeId(argument['storeId']);
    }
    
    if(box.hasData(Config.PRODUCTS)) getProducts();
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

  setEdit() => isEdit(!isEdit.call());
  
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
    DashboardController.to.updateCart();
    return true;
  }

  updateCartRequest({Product product}) {
    
    product.quantity = quantity.call();
    updatedProducts.call().where((data) => data.uniqueId == product.uniqueId).forEach((data) => data = product);
    box.write(Config.PRODUCTS, listProductToJson(updatedProducts.call()));
    getProducts();
    Get.back();
    successSnackBarTop(message: tr('updatedItem'), seconds: 1);
  }

  deleteCart({String uniqueId}) {
    Get.back();
    successSnackBarTop(message: tr('deletedItem'), seconds: 1);
    final prod = listProductFromJson(box.read(Config.PRODUCTS));
    prod.removeWhere((data) => data.uniqueId == uniqueId);
    box.write(Config.PRODUCTS, listProductToJson(prod));
    getProducts();
    update();
  }

  paymentMethod(int storeId, String paymentMethod) {
    print('storeId: $storeId');
    if (totalPrice.value < 100) {
      errorSnackbarTop(message: tr('minimumTransaction'));
    } else {

      dismissKeyboard(Get.context);
      isPaymentLoading(true);
      Get.back();

      createOrderSub = _apiService.createOrder(storeId: storeId, paymentMethod: paymentMethod, noteToRider: noteToRider.text.trim(), carts: addToCart.call()).asStream().listen((response) {
          
        isPaymentLoading(false);

        if(response.status == Config.OK) {
          DashboardController.to.fetchActiveOrders();

          if (response.status == Config.INVALID) {
            errorSnackbarTop(title: tr('oops'), message: tr('storeClosed'));
          } else {
            noteToRider.clear();
            if (response.paymentUrl == null) {
              print('NO URL');
             
              clearCart(storeId);
              DashboardController.to..fetchActiveOrders()..updateCart();

              Get.back(closeOverlays: true);
              successSnackBarTop(title: tr('yay'), message: tr('successOrder'));

            } else {
              print('GO TO WEBVIEW: ${response.paymentUrl}');
              Get.toNamed(Config.WEBVIEW_ROUTE, arguments: {
                'url': response.paymentUrl,
                'order_id': response.data.id,
                'store_id': storeId,
                'type': Config.MART
              }).whenComplete(() => dismissKeyboard(Get.context));
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

  clearCart(int storeId) {
    final prod = listProductFromJson(box.read(Config.PRODUCTS));
    prod.removeWhere((data) => data.storeId == storeId);
    box.write(Config.PRODUCTS, listProductToJson(prod));
    getProducts();
  }

  Future<Null> refreshDeliveryFee() async => getDeliveryFee();

  getDeliveryFee() {
    if(updatedProducts.call().isNotEmpty) {
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

  getProducts() {

    if (box.hasData(Config.PRODUCTS)) {

      final products = listProductFromJson(box.read(Config.PRODUCTS)).where((data) => data.storeId == storeId.call());
      addToCart.call().clear();

      if (products.isNotEmpty) {
        updatedProducts.call().assignAll(products);
        updatedProducts.call().forEach((product) { 

          addToCart.call().add(
            AddToCart(
              productId: product.id,
              variants: null,
              additionals: null,
              quantity: product.quantity,
              note: null,
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
}