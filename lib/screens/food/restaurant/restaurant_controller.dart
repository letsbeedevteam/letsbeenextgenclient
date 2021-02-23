import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
// import 'package:letsbeeclient/models/add_to_cart.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';
// import 'package:letsbeeclient/models/restaurant.dart';
// import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
// import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';

class RestaurantController extends GetxController with SingleGetTickerProviderMixin {

  TabController tabController;

  ApiService apiService = Get.find();
  GetStorage box = Get.find();

  final argument = Get.arguments;
  final nestedScrollViewController = ScrollController();
  final tFRequestController = TextEditingController();
  final list = RxList<Product>().obs;

  var store = StoreResponse().obs;
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
    getProduct.choices.forEach((data) => data.options.forEach((option) => option.selectedValue = null));
    getProduct.additionals.forEach((data) => data.selectedValue = true);
    product(getProduct);
    additionals.clear();
    options.clear();
    totalPriceOfAdditional(0.00);
    totalPriceOfChoice(0.00);
    quantity(1);
    tFRequestController.clear();
    isSelectedProceed('');
  }

  void updateChoices(int id, Option option) {
    product.update((val) {
      val.choices.where((element) => element.id == id).forEach((choice) {
        choice.options.forEach((data) { 
          data.selectedValue = option.name;
          if (data.name == option.name) {
            options.add(data);
          } else {
            options.remove(data);
          }
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

  void addToCart() {
    
    product.call().note = tFRequestController.text;
    product.call().userId = box.read(Config.USER_ID);
    product.call().quantity = quantity.call();
    list.call().add(product.call());
    box.write(Config.PRODUCTS, listProductToJson(list.call()));
    
    // if(listProductFromJson(box.read(Config.PRODUCTS)).isNotEmpty) {
    //   final products = listProductFromJson(box.read(Config.PRODUCTS));

    //   var choiceIds1 = List<ChoiceCart>();
    //   var choiceIds2 = List<ChoiceCart>();
    //   var additionalIds1 = List<int>();
    //   var additionalIds2 = List<int>();

    //   choiceIds1.clear();
    //   choiceIds2.clear();
    //   additionalIds1.clear();
    //   additionalIds2.clear();
      
    //   products.where((data) => data.name == product.call().name).first.choices.forEach((choice) {
    //     choice.options.forEach((element) {
    //       if (element.name == element.selectedValue) {
    //         choiceIds1.add(
    //           ChoiceCart(
    //             id: choice.id,
    //             optionId: element.name == element.selectedValue ? element.id : null
    //           )
    //         );
    //       }
    //     });
    //   });

    //   product.call().choices.forEach((choice) {
    //     choice.options.forEach((element) {
    //       if (element.name == element.selectedValue) {
    //         choiceIds2.add(
    //           ChoiceCart(
    //             id: choice.id,
    //             optionId: element.name == element.selectedValue ? element.id : null
    //           )
    //         );
    //       }
    //     });
    //   });

    //   products.where((data) => data.name == product.call().name).first.additionals.where((element) => !element.selectedValue).forEach((data) => additionalIds1.add(data.id)); 
    //   product.call().additionals.where((element) => !element.selectedValue).forEach((data) => additionalIds2.add(data.id)); 


    //   var convert1 = AddToCart(
    //     storeId: products.where((data) => data.name == product.call().name).first.storeId,
    //     productId: products.where((data) => data.name == product.call().name).first.id,
    //     choices: choiceIds1,
    //     additionals: additionalIds1,
    //     quantity: 0,
    //     note: null
    //   );

    //   print(convert1.toJson());
    //   var convert2 = AddToCart(
    //     storeId: product.call().storeId,
    //     productId:product.call().id,
    //     choices: choiceIds2,
    //     additionals: additionalIds2,
    //     quantity: 0,
    //     note: null
    //   );
    //   print(convert2.toJson());

    //   if (convert1.toString().contains(convert2.toString())) {
    //     var addQuantity =  products.where((data) => data.name == product.call().name).first.quantity;
    //     products.where((data) => data.name == product.call().name).first.quantity = addQuantity + quantity.call();
    //     box.write(Config.PRODUCTS, listProductToJson(products));
    //     print('has same options');
    //   } else {
    //     products.add(product.call());
    //     box.write(Config.PRODUCTS, listProductToJson(products));
    //     print('none');
    //   }

    // } else {
    //   list.call().add(product.call());
    //   box.write(Config.PRODUCTS, listProductToJson(list.call()));
    // }

    CartController.to.getProducts();
    Get.back();
  }

  searchProduct(String name) {
    productName(name);
    update();
  }

  fetchStore() {
    message('Loading Restaurant...');
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
      message(Config.SOMETHING_WENT_WRONG);
      print('Error fetch restaurant by ID ${argument['id']}: $onError');
    });
  }
}