import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/addToCart.dart';
import 'package:letsbeeclient/models/addToCartResponse.dart';
import 'package:letsbeeclient/models/createOrderResponse.dart';
import 'package:letsbeeclient/models/deleteCartResponse.dart';
import 'package:letsbeeclient/models/deleteOrderResponse.dart';
import 'package:letsbeeclient/models/getAddressResponse.dart';
import 'package:letsbeeclient/models/getCart.dart';
import 'package:letsbeeclient/models/newAddressRequest.dart';
import 'package:letsbeeclient/models/newAddressResponse.dart';
import 'package:letsbeeclient/models/numberResponse.dart';
import 'package:letsbeeclient/models/orderHistoryResponse.dart';
import 'package:letsbeeclient/models/refreshTokenResponse.dart';
import 'package:letsbeeclient/models/restaurant.dart';
import 'package:letsbeeclient/models/signInResponse.dart';
import 'package:letsbeeclient/models/signUpResponse.dart';
// import 'package:letsbeeclient/_utils/extensions.dart';

class ApiService extends GetConnect {

  @override
  void onInit() {
    httpClient.baseUrl = Config.BASE_URL;
    super.onInit();
  }

  final GetStorage _box = Get.find();

  Future<SignInResponse> customerSignIn({String email, String password}) async {

    final response = await post(
      '/auth/customer/signin',
      {
        'email': email,
        'password': password
      }
    );

    print('Customer Sign In: ${response.body}');

    return signInResponseFromJson(response.bodyString);
  }

  Future<SignUpResponse> customerSignUp({String name, String email, String password}) async {

    final response = await post(
      '/auth/customer/signup',
      {
        'name': name,
        'email': email,
        'password': password
      }
    );

    print('Customer Sign Up: ${response.body}');

    return signUpResponseFromJson(response.bodyString);
  }

  Future<RefreshTokenResponse> refreshToken() async {

    final response = await post(
      '/auth/customer/refresh-token',
      {
        'token': _box.read(Config.USER_TOKEN)
      }
    );

    print('Refresh token: ${response.body}');

    return refreshTokenFromJson(response.bodyString);
  }

  Future<Restaurant> getAllRestaurants() async {

    final response = await get(
      '/restaurants/dashboard/${_box.read(Config.USER_CURRENT_LATITUDE)}/${_box.read(Config.USER_CURRENT_LONGITUDE)}',
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

  // 'Get restaurants: ${response.body}'.printWrapped();
    print('Get dashboard: ${response.body}');

    return restaurantFromJson(response.bodyString);
  }

  Future<Menu> getMenuById({int restaurantId, int menuId}) async {

    final response = await get(
      '/restaurants/$restaurantId/menus/$menuId',
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Menu by id: ${response.body}');

    var json = response.body;
    return Menu.fromJson(json['data']);
  } 

  Future<AddToCartResponse> addToCart(AddToCart addToCart) async {

    final response = await put(
      '/carts',
      addToCart.toJson(),
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Add carts: ${response.body}');
    
    return addToCartResponseFromJson(response.bodyString);
  }

  Future<AddToCartResponse> updateCart(AddToCart addToCart, int cartId) async {
    
    final response = await post(
      '/carts/$cartId',
      addToCart.toJson(),
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Update carts: ${response.body}');
    
    return addToCartResponseFromJson(response.bodyString);
  }

  Future<DeleteCartResponse> deleteCart(int cartId) async {

    final response = await delete(
      '/carts/$cartId',
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Delete carts: ${response.body}');
    
    return deleteCartResponseFromJson(response.bodyString);
  }

  Future<GetCart> getActiveCarts({int restaurantId}) async {

    final response = await get(
      '/carts?restaurant_id=$restaurantId&lat=${_box.read(Config.USER_CURRENT_LATITUDE)}&lng=${_box.read(Config.USER_CURRENT_LONGITUDE)}',
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Get carts: ${response.body}');

    return getCartFromJson(response.bodyString);
  }

  Future<CreateOrderResponse> createOrder({int restaurantId, String paymentMethod}) async {

    final response = await put(
      '/orders',
      {
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
      },
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Create order: ${response.body}');
    
    return createOrderResponseFromJson(response.bodyString);
  }

  Future<DeleteOrderResponse> deleteOrderById({int orderId}) async {

    final response = await delete(
      '/orders/$orderId',
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Delete order: ${response.body}');
    
    return deleteOrderResponseFromJson(response.bodyString);
  }

  Future<OrderHistoryResponse> orderHistory() async {

    final response = await get(
      '/orders/history',
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Get order history: ${response.body}');
    // 'Get order history: ${response.body}'.printWrapped();

    return orderHistoryResponseFromJson(response.bodyString);
  }

  Future<GetAllAddressResponse> getAllAddress() async {
    
    final response = await get(
      '/addresses',
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Get all addresses: ${response.body}');
    

    return getAllAddressResponseFromJson(response.bodyString);
  }

  Future<NewAddressResponse> addNewAddress(NewAddressRequest request) async {

    final response = await put(
      '/addresses',
      request.toJson(),
      headers: <String, String>{
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      },
    );

    print('New addresses: ${response.body}');

    return newAddressResponseFromJson(response.bodyString);
  }

  Future<NumberResponse> addCellphoneNumber({String number}) async {

    final response = await post(
      '/auth/customer/cellphone-number',
      {'cellphone_number': number},
      headers: <String, String>{
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      },
    );

    print('Cellphone Number Response: ${response.body}');

    return numberResponseFromJson(response.bodyString);
  }
}