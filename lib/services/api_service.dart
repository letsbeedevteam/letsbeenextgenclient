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
import 'package:letsbeeclient/models/newAddressRequest.dart';
import 'package:letsbeeclient/models/newAddressResponse.dart';
import 'package:letsbeeclient/models/orderHistoryResponse.dart';
import 'package:letsbeeclient/models/refreshTokenResponse.dart';
import 'package:letsbeeclient/models/restaurant.dart';
import 'package:letsbeeclient/models/signInResponse.dart';
import 'package:letsbeeclient/models/signUpResponse.dart';
import 'package:letsbeeclient/_utils/extensions.dart';

class ApiService extends GetxService {

  final GetStorage _box = Get.find();

  Future<SignInResponse> customerSignIn({String email, String password}) async {

    final response = await http.post(
      Config.BASE_URL + '/auth/customer/signin',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password
      })
    );

    print('Customer Sign In: ${response.body}');

    return signInResponseFromJson(response.body);
  }

  Future<SignUpResponse> customerSignUp({String name, String email, String password}) async {

    final response = await http.post(
      Config.BASE_URL + '/auth/customer/signup',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password
      })
    );

    print('Customer Sign Up: ${response.body}');

    return signUpResponseFromJson(response.body);
  }

  Future<RefreshTokenResponse> refreshToken() async {

    final response = await http.post(
      Config.BASE_URL + '/auth/customer/refresh-token',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'token': _box.read(Config.USER_TOKEN)
      })
    );

    print('Refresh token: ${response.body}');

    return refreshTokenFromJson(response.body);
  }

  Future<Restaurant> getAllRestaurants() async {

    final response = await http.get(
      Config.BASE_URL + '/restaurants/dashboard/${_box.read(Config.USER_CURRENT_LATITUDE)}/${_box.read(Config.USER_CURRENT_LONGITUDE)}',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      },
    );

  // 'Get restaurants: ${response.body}'.printWrapped();
    print('Get restaurants: ${response.body}');

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

     print('Menu by id: ${response.body}');

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

  Future<OrderHistoryResponse> orderHistory() async {

    final response = await http.get(
      Config.BASE_URL + '/orders/history',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    // print('Get order history: ${response.body}');
    'Get order history: ${response.body}'.printWrapped();

    return orderHistoryResponseFromJson(response.body);
  }

  Future<void> getAllAddress() async {
    
    final response = await http.get(
      Config.BASE_URL + '/addresses?user_id=${_box.read(Config.USER_ID)}',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Get all address: $response');
  }

  Future<NewAddressResponse> addNewAddress(NewAddressRequest request) async {

    final response = await http.put(
      Config.BASE_URL + '/addresses',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      },
      body: jsonEncode(request.toJson())
    );

    return newAddressResponseFromJson(response.body);
  }
}