import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/add_to_cart.dart';
import 'package:letsbeeclient/models/cancel_order_response.dart';
import 'package:letsbeeclient/models/cancel_payment_response.dart';
import 'package:letsbeeclient/models/cellphone_confirmation_response.dart';
import 'package:letsbeeclient/models/change_pass_request.dart';
import 'package:letsbeeclient/models/change_pass_response.dart';
import 'package:letsbeeclient/models/create_order_response.dart';
import 'package:letsbeeclient/models/customer_edit_response.dart';
import 'package:letsbeeclient/models/edit_address_request.dart';
import 'package:letsbeeclient/models/edit_address_response.dart';
import 'package:letsbeeclient/models/edit_profile_request.dart';
import 'package:letsbeeclient/models/fogot_pass_response.dart';
import 'package:letsbeeclient/models/forgot_password_request.dart';
import 'package:letsbeeclient/models/get_address_response.dart';
import 'package:letsbeeclient/models/get_delivery_fee_response.dart';
import 'package:letsbeeclient/models/mart_dashboard_response.dart';
import 'package:letsbeeclient/models/new_address_request.dart';
import 'package:letsbeeclient/models/new_address_response.dart';
import 'package:letsbeeclient/models/number_response.dart';
import 'package:letsbeeclient/models/order_history_response.dart';
import 'package:letsbeeclient/models/refresh_token_response.dart';
import 'package:letsbeeclient/models/request_forgot_pass_response.dart';
import 'package:letsbeeclient/models/restaurant_dashboard_response.dart';
import 'package:letsbeeclient/models/search_mart_response.dart';
import 'package:letsbeeclient/models/search_restaurant_response.dart';
import 'package:letsbeeclient/models/signin_response.dart';
import 'package:letsbeeclient/models/signup_response.dart';
import 'package:letsbeeclient/models/signup_request.dart';
import 'package:letsbeeclient/models/social_signup_request.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/_utils/extensions.dart';

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

  Future<SignUpResponse> customerSignUp({SignUpRequest signUp}) async {

    print(signUp.toJson());
    final response = await post(
      '/auth/customer/signup',
      signUp.toJson()
    );

    print('Customer Sign Up: ${response.body}');

    return signUpResponseFromJson(response.bodyString);
  }

  Future<ChangePasswordResponse> customerChangePassword({ChangePasswordRequest request}) async {

    print(request.toJson());
    final response = await post(
      '/auth/customer/change-password',
      request.toJson(),
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Customer Change Password: ${response.body}');

    return changePasswordResponseFromJson(response.bodyString);
  }

  Future<RequestForgotPassResponse> customerRequestForgotPassword({String contactNumber}) async {

    final response = await post(
      '/auth/customer/request-forgot-password',
      {'cellphone_number': contactNumber}
    );

    print('Request Forgot Password: ${response.body}');

    return requestForgotPassFromJson(response.bodyString);
  }

  Future<ForgotPassResponse> customerForgotPassword({ForgotPasswordRequest request}) async {
    
    print(request.toJson());
    final response = await post(
      '/auth/customer/forgot-password',
      request.toJson()
    );

    print('Forgot Password: ${response.body}');

    return forgotPassFromJson(response.bodyString);
  }

  Future<SignInResponse> resendOtp({String token}) async {
    final response = await post(
      '/auth/customer/resend-otp',
      {'token': token}
    );

    print('Resend Otp: ${response.body}');

    return signInResponseFromJson(response.bodyString);
  }

  Future<SignUpResponse> customerSocialSignUp({SocialSignUpRequest socialSignUp}) async {

    print(socialSignUp.toJson());
    final response = await post(
      '/auth/customer/social/login-update',
      socialSignUp.toJson()
    );

    print('Customer Social Sign Up: ${response.body}');

    return signUpResponseFromJson(response.bodyString);
  }

  Future<CustomerEditResponse> customerEditProfile({EditProfileRequest request}) async {

    final response = await post(
      '/auth/customer/edit',
      request.toJson(),
      headers: <String, String>{
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      },
    );

     print('Customer Edit Profile: ${response.body}');
  
    return customerEditResponseFromJson(response.bodyString);
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

  Future<Product> getProductById({int productId}) async {

    final response = await get(
      '/stores/products/$productId',
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Product by id: ${response.body}');

    var json = response.body;
    return Product.fromJson(json['data']);
  } 
  
  Future<CreateOrderResponse> createOrder({int storeId, String paymentMethod, String noteToRider, List<AddToCart> carts}) async {
    final response = await put(
      '/orders',
      {
        'store_id': storeId,
        'payment_method': paymentMethod,
        'address_id': _box.read(Config.USER_ADDRESS_ID),
        'carts': carts,
        'note': noteToRider
      },
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Create order: ${response.body}');
    
    return createOrderResponseFromJson(response.bodyString);
  }

  Future<GetDeliveryFeeResponse> getDeliveryFee({int storeId}) async {
    final response = await get(
      '/stores/$storeId/delivery-fee/${_box.read(Config.USER_CURRENT_LATITUDE)}/${_box.read(Config.USER_CURRENT_LONGITUDE)}',
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Delivery Fee: ${response.body}');
    
    return getDeliveryFeeFromJson(response.bodyString);
  }

  Future<CancelPaymentResponse> cancelOnlinePayment({int orderId}) async {

    final response = await post(
      '/orders/cancel-payment',
      {
        'order_id': orderId
      },
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Cancel payment: ${response.body}');
    
    return cancelPaymentResponseFromJson(response.bodyString);
  }

  Future<CancelOrderResponse> cancelOrder({int orderId, String note}) async {

    final response = await post(
      '/orders/cancel',
      {
        'order_id': orderId,
        'note': note
      },
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

    print('Cancel order: ${response.body}');
    
    return cancelOrderResponseFromJson(response.bodyString);
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

  Future<EditAddressResponse> editAddress(EditAddressRequest request) async {

    final response = await post(
      '/addresses',
      request.toJson(),
      headers: <String, String>{
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      },
    );

    print('Edit addresses: ${response.body}');

    return editAddressResponseFromJson(response.bodyString);
  }

  Future<NumberResponse> updateCellphoneNumber({String number, String token}) async {

    final response = await post(
      '/auth/customer/cellphone-update',
      {
        'token': token,
        'cellphone_number': number
      },
    );

    print('Cellphone Number Response: ${response.body}');

    return numberResponseFromJson(response.bodyString);
  }

  Future<CellphoneConfirmationResponse> cellphoneConfirmation({String code, String token}) async {

    final response = await post(
      '/auth/customer/cellphone-confirmation',
      {
        'token': token,
        'code': code
      },
    );

    print('Cellphone Confirmation Response: ${response.body}');

    return cellphoneConfirmationResponseFromJson(response.bodyString);
  }

  Future<RestaurantDashboardResponse> getRestaurantDashboard({@required int page}) async {

    final response = await get(
      '/stores/restaurants/dashboard/${_box.read(Config.USER_CURRENT_LATITUDE)}/${_box.read(Config.USER_CURRENT_LONGITUDE)}?page=$page',
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

  // 'Get restaurants: ${response.body}'.printWrapped();
    print('Get restaurant dashboard: ${response.body}');

    return restaurantDashboardFromJson(response.bodyString);
  }

  Future<SearchRestaurantResponse> searchRestaurant({@required String name}) async {

    final response = await get(
      '/stores/restaurants/search/${_box.read(Config.USER_CURRENT_LATITUDE)}/${_box.read(Config.USER_CURRENT_LONGITUDE)}/$name',
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

  // 'Get restaurants: ${response.body}'.printWrapped();
    print('Search restaurant: ${response.body}');

    return searchRestaurantResponseFromJson(response.bodyString);
  }

  Future<SearchMartResponse> searchMart({@required String name}) async {

    final response = await get(
      '/stores/marts/search/${_box.read(Config.USER_CURRENT_LATITUDE)}/${_box.read(Config.USER_CURRENT_LONGITUDE)}/$name',
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

  // 'Get restaurants: ${response.body}'.printWrapped();
    print('Search mart: ${response.body}');

    return searchMartResponseFromJson(response.bodyString);
  }

  Future<MartDashboardResponse> getMartDashboard({@required int page}) async {

    final response = await get(
      '/stores/marts/dashboard/${_box.read(Config.USER_CURRENT_LATITUDE)}/${_box.read(Config.USER_CURRENT_LONGITUDE)}?page=$page',
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

  // 'Get restaurants: ${response.body}'.printWrapped();
    print('Get mart dashboard: ${response.body}');

    return martDashboardFromJson(response.bodyString);
  }

  Future<StoreResponse> fetchStoreById({int id}) async {

    final response = await get(
      '/stores/$id/products',
      headers: {
        'Authorization': 'Bearer ${_box.read(Config.USER_TOKEN)}',
      }
    );

  'Get stores: ${response.body}'.printWrapped();
    // print('Get store: ${response.body}');

    return storeResponseFromJson(response.bodyString);
  }
}