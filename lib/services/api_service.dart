import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/addToCart.dart';
import 'package:letsbeeclient/models/addToCartResponse.dart';
import 'package:letsbeeclient/models/createOrderResponse.dart';
import 'package:letsbeeclient/models/deleteCartResponse.dart';
import 'package:letsbeeclient/models/deleteOrderResponse.dart';
import 'package:letsbeeclient/models/getCart.dart';
import 'package:letsbeeclient/models/restaurant.dart';

class ApiService extends GetxService {

  final GetStorage _box = Get.find();

  Future<Restaurant> getAllRestaurants() async {

    final response = await http.get(
      Config.BASE_URL + '/restaurants/dashboard',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      },
    );

    // print('Get restaurants: ${response.body}');

    return restaurantFromJson(response.body);
  }

  Future<Menu> getMenuById({int restaurantId, int menuId}) async {
    final response = await http.get(
      Config.BASE_URL + '/restaurants/$restaurantId/menus/$menuId',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      },
    );

    var json = jsonDecode(response.body);
    return Menu.fromJson(json['data']);
  } 

  Future<AddToCartResponse> addToCart(AddToCart addToCart) async {
    
    final response = await http.put(
      Config.BASE_URL + '/carts',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      },
      body: jsonEncode(addToCart)
    );

    print('Add carts: ${response.body}');
    
    return addToCartResponseFromJson(response.body);
  }

  Future<AddToCartResponse> updateCart(AddToCart addToCart, int cartId) async {
    
    final response = await http.post(
      Config.BASE_URL + '/carts/$cartId',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      },
      body: jsonEncode(addToCart)
    );

    print('Update carts: ${response.body}');
    
    return addToCartResponseFromJson(response.body);
  }

  Future<DeleteCartResponse> deleteCart(int cartId) async {
    
    final response = await http.delete(
      Config.BASE_URL + '/carts/$cartId',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      },
    );

    print('Delete carts: ${response.body}');
    
    return deleteCartResponseFromJson(response.body);
  }

  Future<GetCart> getActiveCarts({int restaurantId}) async {
    
    final response = await http.get(
      Config.BASE_URL + '/carts?restaurant_id=$restaurantId',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Get carts: ${response.body}');

    return getCartFromJson(response.body);
  }

  Future<CreateOrderResponse> createOrder({int restaurantId, String paymentMethod}) async {

    final response = await http.put(
      Config.BASE_URL + '/orders',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      },
      body: jsonEncode({
        'restaurant_id': restaurantId,
        'payment_method': paymentMethod,
        'location': {
          'lat': _box.read(Config.USER_CURRENT_LATITUDE),
          'lng': _box.read(Config.USER_CURRENT_LONGITUDE),
          'street': _box.read(Config.USER_CURRENT_STREET),
          'country': _box.read(Config.USER_CURRENT_COUNTRY),
          'state': _box.read(Config.USER_CURRENT_STATE),
          'city': _box.read(Config.USER_CURRENT_CITY),
          'iso_code': _box.read(Config.USER_CURRENT_IS_CODE),
          'barangay': _box.read(Config.USER_CURRENT_BARANGAY)
        }
      })
    );

    print('Create order: ${response.body}');
    
    return createOrderResponseFromJson(response.body);
  }

  Future<DeleteOrderResponse> deleteOrderById({int orderId}) async {
     final response = await http.delete(
      Config.BASE_URL + '/orders/$orderId',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      },
    );

    print('Delete order: ${response.body}');
    
    return deleteOrderResponseFromJson(response.body);
  }
}