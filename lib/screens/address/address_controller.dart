import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/get_address_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';
import 'package:letsbeeclient/screens/grocery/mart_cart/mart_cart_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';
import 'package:easy_localization/easy_localization.dart';

class AddressController extends GetxController {

  final ApiService apiService = Get.find();
  final GetStorage box = Get.find();

  var addresses = GetAllAddressResponse().obs;
  var isLoading = false.obs;
  var addressErrorMessage = ''.obs;

  StreamSubscription<GetAllAddressResponse> addressSub;

  static AddressController get to => Get.find();

  @override
  void onInit() {
    addresses.nil();
    fetchAllAddresses();
    super.onInit();
  }

  @override
  void onClose() {
    addressSub?.cancel();
    super.onClose();
  }

  Future<bool> onWillPopBack() async {
    Get.back();
    if (Get.previousRoute == Config.CART_ROUTE) {
      CartController.to.getProducts();
    } else if (Get.previousRoute == Config.MART_CART_ROUTE) {
      MartCartController.to.getProducts();
    }
    return true;
  }

  Future<Null> refreshAddress() async => fetchAllAddresses();

  checkCartBeforeChangeAddress({AddressData data}) {

    if (box.read(Config.USER_ADDRESS_ID) != data.id) {
      if(box.hasData(Config.PRODUCTS)) {
        addresssDialog(data);
      } else {
        updateSelectedAddress(data, false);
      }
    }
  }

  addresssDialog(AddressData data) => Get.defaultDialog(
    title: tr('alertAddressMessage'),
    backgroundColor: Color(Config.WHITE),
    titleStyle: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
    radius: 8,
    content: Container(),
    confirm: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      color: const Color(Config.LETSBEE_COLOR),
      onPressed: () => updateSelectedAddress(data, true),
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

  updateSelectedAddress(AddressData data, bool dismiss) async {
    
    await box.remove(Config.PRODUCTS).then((data) => DashboardController.to.updateCart());
   
    DashboardController.to
    ..updateCurrentLocation(data)
    ..fetchRestaurantDashboard(page: 0)
    ..fetchMartDashboard(page: 0);

    if (Get.previousRoute == Config.CART_ROUTE) {
      CartController.to.refreshDeliveryFee();
    } else if (Get.previousRoute == Config.MART_CART_ROUTE) {
      MartCartController.to.refreshDeliveryFee();
    }
     
    addresses.update((value) {
      value.data.forEach((data) => data.id == box.read(Config.USER_ADDRESS_ID) ? data.isSelected = true : data.isSelected = false);
    });

    if (dismiss) Get.back();
  }

  addAddress() => Get.toNamed(Config.MAP_ROUTE, arguments: {'type': Config.ADD_NEW_ADDRESS});

  editAddress(AddressData data) => Get.toNamed(Config.MAP_ROUTE, arguments: {'type': Config.EDIT_NEW_ADDRESS, 'data': data.toJson()});

  fetchAllAddresses() {
    isLoading(true);
    addressSub = apiService.getAllAddress().asStream().listen((response) {
      isLoading(false);
      if (response.status == Config.OK) {
        if (response.data.isNotEmpty) {
          addresses(response);
          addresses.call().data.singleWhere((data) => data.id == box.read(Config.USER_ADDRESS_ID) ? data.isSelected = true : data.isSelected = false);
          addresses.call().data.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        } else {
          addresses.nil();
          addressErrorMessage('No list of address');
        }

      } else {
        addresses.nil();
        addressErrorMessage(tr('somethingWentWrong'));
      }
      
    })..onError((onError) {
      addresses.nil();
      isLoading(false);
      addressErrorMessage(tr('somethingWentWrong'));
      // message(Config.SOMETHING_WENT_WRONG);
      print('Error fetch all address: $onError');
    });
  }
}