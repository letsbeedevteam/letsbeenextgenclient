// import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/add_to_cart.dart';
// import 'package:letsbeeclient/models/add_to_cart.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';
// import 'package:letsbeeclient/models/restaurant.dart';
// import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
// import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';
import 'package:uuid/uuid.dart';
// import 'package:collection/collection.dart';

class RestaurantController extends GetxController with SingleGetTickerProviderMixin {

  TabController tabController;

  ApiService apiService = Get.find();
  GetStorage box = Get.find();

  final uuid = Uuid();
  final argument = Get.arguments;
  final nestedScrollViewController = ScrollController();
  final tFRequestController = TextEditingController();

  var store = StoreResponse().obs;
  var listOfProcucts = RxList<Product>().obs;
  var product = Product().obs;
  final list = RxList<Product>().obs;

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
  var isSelectedProceed = ''.obs;

  var hasNoChoices = false.obs;
  // var choiceIds = List<ChoiceCart>().obs;
  // var additionalIds =  List<AdditionalCart>().obs;
  
  static RestaurantController get to => Get.find();
  
  @override
  void onInit() {
    Get.put(CartController());
    store.nil();
    super.onInit();
  }

  @override
  void onClose() {
    DashboardController.to.fetchRestaurantDashboard();
    super.onClose();
  }

  void refreshProduct(Product getProduct) {
    product.value = getProduct;
    product.value.choices.forEach((data) => data.options.forEach((option) => option.selectedValue = null));
    product.value.additionals.forEach((data) => data.selectedValue = true);
    
    additionals.clear();
    options.clear();
    totalPriceOfAdditional(0.00);
    totalPriceOfChoice(0.00);
    quantity(1);
    tFRequestController.clear();
    isSelectedProceed('');
    choiceCart.call().clear();
  }

  void updateChoices(int id, Option option) {
    product.update((val) {
      val.choices.where((element) => element.id == id).forEach((choice) {
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

  void addToCart(Product product) {

    var hasNotSelectedChoice = false;

    if (product.choices.isEmpty) {
      hasNotSelectedChoice = true;
    } else {
      product.choices.forEach((choice) {
        hasNotSelectedChoice = choice.options.where(((option) => option.selectedValue != null)).isNotEmpty;
      });
    }
   
    if (!hasNotSelectedChoice) {
      errorSnackbarTop(title: Config.oops, message: Config.requiredChoice);
    } else {

      product.uniqueId = uuid.v4();
      product.note = tFRequestController.text.trim().isEmpty ? null : tFRequestController.text;
      product.userId = box.read(Config.USER_ID);
      product.quantity = quantity.call();
      product.isRemove = false;
      product.choiceCart = choiceCart.call().values.toList();
      product.additionalCart = additionals.where((element) => !element.selectedValue).map((data) => data.id).toList();
  
      final prod = list.call().where((data) => !data.isRemove && data.storeId == store.call().data.id);

      if (prod.isNotEmpty) {
        
        try {

          final filteredChoice = prod.where((data) => choicesToJson2(data.choiceCart).contains(choicesToJson2(product.choiceCart)));

          if (filteredChoice.toList().isEmpty) {
            list.call().add(product);
          } else {

            if (choicesToJson2(filteredChoice.first.choiceCart) == choicesToJson2(product.choiceCart) && additionalsToJson2(filteredChoice.first.additionalCart) == additionalsToJson2(product.additionalCart)) {
              filteredChoice.first.note = tFRequestController.text.isNotEmpty ? product.note : null; 
              filteredChoice.first.quantity = filteredChoice.first.quantity + product.quantity;
            } else {
               list.call().add(product);
            }

          }
        } catch (error) {
          list.call().add(product);
          print(error);
        }

      } else {
        print('Added cart when theres no product if found');
        list.call().add(product);
      }

      choiceCart.call().clear();
      box.write(Config.PRODUCTS, listProductToJson(list.call()));
      final products = listProductFromJson(box.read(Config.PRODUCTS)).where((data) => !data.isRemove);
      list.call().clear();
      list.call().addAll(products);
      CartController.to.getProducts();

      if(Get.isSnackbarOpen) {
         Get.back();
         Future.delayed(Duration(milliseconds: 300));
         Get.back();
      } else {
         Get.back();
      }
    }
  }

  searchProduct(String name) {
    productName(name);
    update();
  }

  fetchStore() {
    message(tr('loadingRestaurant'));
    hasError(false);
    apiService.fetchStoreById(id: argument['id']).then((response) {
      hasError(false);
      store(response);
      selectedName(store.call().data.categorized.first.name);
      tabController = TabController(length: store.call().data.categorized.map((categorize) => categorize.name).length, vsync: this);
      CartController.to..storeId(store.call().data.id);
      tabController.addListener(() {
        FocusScope.of(Get.context).requestFocus(FocusNode());
        productName('');
        update();
      });

      if (box.hasData(Config.PRODUCTS)) {
        final products = listProductFromJson(box.read(Config.PRODUCTS)).where((data) => !data.isRemove);
        list.call().clear();
        list.call().addAll(products);
        box.write(Config.PRODUCTS, listProductToJson(list.call()));
        CartController.to.getProducts();
      } 

    }).catchError((onError) {
      hasError(true);
      store.nil();
      message(Config.somethingWentWrong);
      print('Error fetch restaurant by ID ${argument['id']}: $onError');
    });
  }
}