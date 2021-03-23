import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/mart_dashboard_response.dart';
// import 'package:letsbeeclient/_utils/extensions.dart';
// import 'package:letsbeeclient/models/add_to_cart.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/grocery/mart_cart/mart_cart_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';
import 'package:uuid/uuid.dart';

class MartController extends GetxController with SingleGetTickerProviderMixin {
  
  TabController tabController;
  ApiService apiService = Get.find();
  GetStorage box = Get.find();

  final uuid = Uuid();
  final argument = Get.arguments;
  final nestedScrollViewController = ScrollController();

  var quantity = 0.obs;

  var store = MartStores().obs;
  var storeResponse = StoreResponse().obs;

  var message = ''.obs;
  var productName = ''.obs;

  var readOnly = false.obs;
  var hasError = false.obs;
  var isAddToCartLoading = false.obs;

  var selectedName = ''.obs;
  var isSelectedProceed = false.obs;

  static MartController get to => Get.find();
  
  @override
  void onInit() {
    storeResponse.nil();
    store.nil();
    Get.put(MartCartController());
    store(MartStores.fromJson(argument['mart']));
    super.onInit();
  }

  searchProduct(String name) {
    productName(name);
    update();
  }

  void increment() => quantity.value++;
  
  void decrement() {
    if (quantity.value <= 1) {
      quantity(1);
    } else {
      quantity.value--;
    }
  }

  fetchStore() {
    message(tr('loadingShop'));
    hasError(false);
    storeResponse.nil();
    apiService.fetchStoreById(id: argument['id']).then((response) {

      if(response.data.isNotEmpty) {

        storeResponse(response);
        selectedName(storeResponse.call().data.first.name);
        tabController = TabController(length: storeResponse.call().data.map((categorize) => categorize.name).length, vsync: this);
        MartCartController.to..storeId(store.call().id);
        tabController.addListener(() {
          FocusScope.of(Get.context).requestFocus(FocusNode());
          productName('');
          update();
        });

        if (box.hasData(Config.PRODUCTS)) {
          final products = listProductFromJson(box.read(Config.PRODUCTS));
          MartCartController.to.updatedProducts.call().assignAll(products);
          box.write(Config.PRODUCTS, listProductToJson(MartCartController.to.updatedProducts.call()));
          MartCartController.to.getProducts();
        } else {
          MartCartController.to.updatedProducts.call().clear();
          box.write(Config.PRODUCTS, listProductToJson(MartCartController.to.updatedProducts.call()));
          MartCartController.to.getProducts();
        }

        hasError(false);

      } else {
        storeResponse.nil();
        hasError(true);
        message(tr('emptyProduct'));
      }

    }).catchError((onError) {
      hasError(true);
      storeResponse.nil();
      message(tr('somethingWentWrong'));
      print('Error fetch mart by ID ${argument['id']}: $onError');
    });
  }

  void checkPreviousCart(Product product) {
    
    if (box.hasData(Config.PRODUCTS)) {

      final products = listProductFromJson(box.read(Config.PRODUCTS)).where((data) => data.storeId != store.call().id && data.userId == box.read(Config.USER_ID));

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
              MartCartController.to.updatedProducts.call().assignAll(products);
              MartCartController.to.updatedProducts.call().removeWhere((data) => data.storeId != product.storeId && data.userId == box.read(Config.USER_ID));
              box.write(Config.PRODUCTS, listProductToJson(MartCartController.to.updatedProducts.call()));
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

    } else {
      addToCart(product);
    }
  }

  void addToCart(Product product) {
    
    product.uniqueId = uuid.v4();
    product.note = null;
    product.userId = box.read(Config.USER_ID);
    product.storeId = store.call().id;
    product.quantity = quantity.call();
    product.choiceCart = [];
    product.additionalCart = [];
    product.type = Config.MART;
    product.removable = isSelectedProceed.call();

    final prod = MartCartController.to.updatedProducts.call().where((data) => data.storeId == store.call().id);

      if (prod.isNotEmpty) {
        
        try {

          final fileredProduct = prod.where((data) => data.id == product.id);

          if (fileredProduct.toList().isEmpty) {
            MartCartController.to.updatedProducts.call().add(product);
          } else {

            fileredProduct.first.quantity = fileredProduct.first.quantity + product.quantity;

          }
        } catch (error) {
          MartCartController.to.updatedProducts.call().add(product);
          print(error);
        }

      } else {
        print('Added cart when theres no product if found');
        MartCartController.to.updatedProducts.call().add(product);
      }

    box.write(Config.PRODUCTS, listProductToJson(MartCartController.to.updatedProducts.call()));
    final products = listProductFromJson(box.read(Config.PRODUCTS));
    MartCartController.to.updatedProducts.call().assignAll(products);
    MartCartController.to.getProducts();
    DashboardController.to.updateCart();
    Get.back();
  }

  Future<Null> refreshStore() async => fetchStore();

  Future<bool> onWillPopBack() async {
    Get.back();
    DashboardController.to.updateCart();
    return true;
  }
} 