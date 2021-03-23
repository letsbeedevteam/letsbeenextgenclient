import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/add_to_cart.dart';
import 'package:letsbeeclient/models/restaurant_dashboard_response.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';
import 'package:uuid/uuid.dart';

class RestaurantController extends GetxController with SingleGetTickerProviderMixin {

  TabController tabController;

  ApiService apiService = Get.find();
  GetStorage box = Get.find();

  final uuid = Uuid();
  final argument = Get.arguments;
  final nestedScrollViewController = ScrollController();
  final tFRequestController = TextEditingController();

  var store = RestaurantStores().obs;
  var storeResponse = StoreResponse().obs;
  var listOfProcucts = RxList<Product>().obs;
  var product = Product().obs;

  var hasError = false.obs;
  var readOnly = false.obs;

  var message = ''.obs;
  var productName = ''.obs;
  var selectedName = ''.obs;

  var quantity = 1.obs;
  var totalPriceOfChoice = 0.00.obs;
  var additionals = List<Additional>().obs;
  var options = List<Option>().obs;
  var choiceCart = RxMap<int, ChoiceCart>().obs;
  var totalPriceOfAdditional = 0.00.obs;
  var isSelectedProceed = true.obs;

  var hasNoChoices = false.obs;
  // var choiceIds = List<ChoiceCart>().obs;
  // var additionalIds =  List<AdditionalCart>().obs;
  
  static RestaurantController get to => Get.find();
  
  @override
  void onInit() {
    Get.put(CartController());
    storeResponse.nil();
    store.nil();

    store(RestaurantStores.fromJson(argument['restaurant']));

    super.onInit();
  }

  void refreshProduct(Product getProduct) {
    product.value = getProduct;
    product.value.variants.forEach((data) => data.options.forEach((option) => option.selectedValue = null));
    product.value.additionals.forEach((data) => data.selectedValue = true);
    
    additionals.clear();
    options.clear();
    totalPriceOfAdditional(0.00);
    totalPriceOfChoice(0.00);
    quantity(1);
    tFRequestController.clear();
    choiceCart.call().clear();
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

          choiceCart.call()[choice.id] = ChoiceCart(
            id: choice.id,
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

  void checkPreviousCart(Product product) {
    
    if(box.hasData(Config.PRODUCTS)) {

      final products = listProductFromJson(box.read(Config.PRODUCTS)).where((data) => data.storeId != store.call().id && data.userId == box.read(Config.USER_ID));

      var hasNotSelectedChoice = false;

      if (product.variants.isEmpty) {
        hasNotSelectedChoice = true;
      } else {
        hasNotSelectedChoice = product.variants.length == choiceCart.call().values.toList().length;
      }
    
      if (!hasNotSelectedChoice) {
        errorSnackbarTop(title: tr('oops'), message: tr('requiredChoice'));
      } else {

        if (products.isNotEmpty) {
          print('REMOVE THE PREVIOUS CART FIRST');

          Get.defaultDialog(
            title: tr('alertCartMessage'),
            backgroundColor: Color(Config.WHITE),
            titleStyle: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
            radius: 8,
            content: Container(),
            confirm: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              color: const Color(Config.LETSBEE_COLOR),
              onPressed: () async {
                
                final products = listProductFromJson(box.read(Config.PRODUCTS));
                CartController.to.updatedProducts.call().assignAll(products);
                CartController.to.updatedProducts.call().removeWhere((data) => data.storeId != product.storeId && data.userId == box.read(Config.USER_ID));
                box.write(Config.PRODUCTS, listProductToJson(CartController.to.updatedProducts.call()));
                Get.back();
                addToCart(product);
              },
              child: Text(tr('yes'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            cancel: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              color: const Color(Config.LETSBEE_COLOR),
              onPressed: () => Get.back(),
              child: Text(tr('no'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            barrierDismissible: false
          );

        } else {
          addToCart(product);
        }
      }

    } else {
      addToCart(product);
    }
  }

  void addToCart(Product product) {

    product.uniqueId = uuid.v4();
    product.note = tFRequestController.text.trim().isEmpty ? null : tFRequestController.text;
    product.userId = box.read(Config.USER_ID);
    product.storeId = store.call().id;
    product.quantity = quantity.call();
    product.choiceCart = choiceCart.call().values.toList();
    product.additionalCart = additionals.where((element) => !element.selectedValue).map((data) => data.id).toList();
    product.type = Config.RESTAURANT;
    product.removable = isSelectedProceed.call();

    final prod = CartController.to.updatedProducts.call().where((data) => data.storeId == store.call().id);

    if (prod.isNotEmpty) {
      
      try {

        final filteredChoice = prod.where((data) => choicesToJson2(data.choiceCart).contains(choicesToJson2(product.choiceCart)));

        if (filteredChoice.toList().isEmpty) {
          CartController.to.updatedProducts.call().add(product);
        } else {

          if (choicesToJson2(filteredChoice.first.choiceCart) == choicesToJson2(product.choiceCart) && additionalsToJson2(filteredChoice.first.additionalCart) == additionalsToJson2(product.additionalCart)) {
            filteredChoice.first.note = tFRequestController.text.isNotEmpty ? product.note : null; 
            filteredChoice.first.quantity = filteredChoice.first.quantity + product.quantity;
          } else {
            CartController.to.updatedProducts.call().add(product);
          }

        }
      } catch (error) {
        CartController.to.updatedProducts.call().add(product);
        print(error);
      }

    } else {
      print('Added cart when theres no product if found');
      CartController.to.updatedProducts.call().add(product);
    }

    choiceCart.call().clear();
    box.write(Config.PRODUCTS, listProductToJson(CartController.to.updatedProducts.call()));
    final products = listProductFromJson(box.read(Config.PRODUCTS));
    CartController.to.updatedProducts.call().assignAll(products);
    CartController.to.getProducts();
    DashboardController.to.updateCart();

    if(Get.isSnackbarOpen) {
      Get.back();
      Future.delayed(Duration(milliseconds: 300));
      Get.back();
    } else {
      Get.back();
    }
  }

  searchProduct(String name) {
    productName(name);
    update();
  }

  fetchStore() {
    message(tr('loadingRestaurant'));
    hasError(false);
    storeResponse.nil();
    apiService.fetchStoreById(id: argument['id']).then((response) {
      
      if(response.status == Config.OK) {

        if(response.data.isNotEmpty) {

          storeResponse(response);
          selectedName(storeResponse.call().data.first.name);
          tabController = TabController(length: storeResponse.call().data.map((data) => data.name).length, vsync: this);
          CartController.to..storeId(store.call().id);
          tabController.addListener(() {
            FocusScope.of(Get.context).requestFocus(FocusNode());
            productName('');
            update();
          });

          if (box.hasData(Config.PRODUCTS)) {
            final products = listProductFromJson(box.read(Config.PRODUCTS));
            CartController.to.updatedProducts.call().assignAll(products);
            box.write(Config.PRODUCTS, listProductToJson(CartController.to.updatedProducts.call()));
            CartController.to.getProducts();
          } else {
            CartController.to.updatedProducts.call().clear();
            box.write(Config.PRODUCTS, listProductToJson(CartController.to.updatedProducts.call()));
            CartController.to.getProducts();
          }

          hasError(false);

        } else {
          storeResponse.nil();
          hasError(true);
          message(tr('emptyProduct'));
        }

      } else {

        storeResponse.nil();
        hasError(true);
        message(tr('somethingWentWrong'));
      }

    }).catchError((onError) {
      hasError(true);
      storeResponse.nil();
      message(tr('somethingWentWrong'));
      print('Error fetch restaurant by ID ${argument['id']}: $onError');
    });
  }

  Future<Null> refreshStore() async => fetchStore();

  Future<bool> onWillPopBack() async {
    Get.back();
    DashboardController.to.updateCart();
    return true;
  }
}