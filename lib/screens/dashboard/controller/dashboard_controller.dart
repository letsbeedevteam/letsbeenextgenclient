import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/activeOrderResponse.dart';
import 'package:letsbeeclient/models/restaurant.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/account_settings_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/home_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/notification_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/order_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/reviews_view.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/services/api_service.dart';
import 'package:letsbeeclient/services/push_notification_service.dart';
import 'package:letsbeeclient/services/socket_service.dart';

class DashboardController extends GetxController with SingleGetTickerProviderMixin {
  
  TabController tabController;
  AnimationController animationController;
  PageController pageController;
  Animation<Offset> offsetAnimation;
  Completer<void> refreshCompleter;
  // GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  final ApiService apiService = Get.find();
  final PushNotificationService pushNotificationService = Get.find();
  final SocketService socketService = Get.find();
  final GetStorage box = Get.find();
  final GoogleSignIn _googleSignIn = Get.find();
  final FacebookLogin _facebookLogin = Get.find();
  final tfSearchController = TextEditingController();
  final widgets = [HomePage(), NotificationPage(), AccountSettingsPage(), ReviewsPage(), OrderPage()];

  var pageIndex = 0.obs;
  var userCurrentAddress = ''.obs;
  var isHideAppBar = false.obs;
  var isOpenLocationSheet = false.obs;
  var isLoading = false.obs;
  var isSearching = false.obs;
  var message = ''.obs;
  var onGoingMessage = 'No Active Order'.obs;
  var restaurants = Restaurant().obs;
  var searchRestaurants = RxList<RestaurantElement>().obs;
  var activeOrderData = ActiveOrderData().obs;

  static DashboardController get to => Get.find();

  @override
  void onInit() {
    restaurants.nil();
    activeOrderData.nil();

    userCurrentAddress.value = box.read(Config.USER_CURRENT_ADDRESS);
    pushNotificationService.initialise();

    setupRefreshIndicator();
    setupAnimation();
    setupTabs();
    refreshToken();
    
    super.onInit();
  }

  void setupRefreshIndicator() {
    // refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    refreshCompleter = Completer();
    // SchedulerBinding.instance.addPostFrameCallback((_){  
    //   refreshIndicatorKey.currentState?.show(); 
    // });
  }
  
  void setupAnimation() {

    animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this
    );

    offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticInOut,
    ));
  }

  void setupTabs() {
    tabController = TabController(length: 2, vsync: this)..addListener(() {
      tabController.index == 0 ?  animationController.reverse() :  animationController.forward();
    });

    pageController = PageController();
  }

  void showLocationSheet(bool isOpenLocationSheet) {
    this.isOpenLocationSheet(isOpenLocationSheet);
  }

  void tapped(int tappedIndex) {
    tappedIndex == 0 ? isHideAppBar(false) : isHideAppBar(true); 
    if (tappedIndex == 4) fetchActiveOrder();
    tfSearchController.clear();
    searchRestaurant('');
    pageIndex(tappedIndex);
    pageController.animateToPage(pageIndex.value, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
  }

  void updateCurrentLocation(String address) {
     userCurrentAddress(address);
     box.write(Config.USER_CURRENT_ADDRESS, address);
     showLocationSheet(false);
  }

  void signOut() {
   switch (box.read(Config.SOCIAL_LOGIN_TYPE)) {
      case Config.GOOGLE: _googleSignOut();
      break;
      case Config.FACEBOOK: _facebookSignOut();
      break;
      case Config.APPLE: _signOut();
      break;
      case Config.KAKAO: _signOut();
      break;
      default: _signOut();
    }
    socketService.disconnectSocket();
  }

  void _facebookSignOut() async {
    await _facebookLogin.logOut().then((value) {
      box.write(Config.IS_LOGGED_IN, false);
      box.write(Config.IS_SETUP_LOCATION, false);
      box.remove(Config.USER_TOKEN);
      Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
    });
  }

  void _googleSignOut() async {
    await _googleSignIn.disconnect().then((value) {
      box.write(Config.IS_LOGGED_IN, false);
      box.write(Config.IS_SETUP_LOCATION, false);
      box.remove(Config.USER_TOKEN);
      Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
    });
  }

  void _signOut() {
    box.write(Config.IS_LOGGED_IN, false);
    box.write(Config.IS_SETUP_LOCATION, false);
    box.remove(Config.USER_TOKEN);
    Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
  }

  void _setRefreshCompleter() {
    refreshCompleter?.complete();
    refreshCompleter = Completer();
  }

  goToChatPage() {
    activeOrderData.call().riderId != 0 ? Get.toNamed(Config.CHAT_ROUTE, arguments: activeOrderData.call()) 
    : alertSnackBarTop(title: 'Oops!', message: 'Please wait for the rider\'s approval');

    // Get.toNamed(Config.CHAT_ROUTE, arguments: activeOrderData.call());
  }

  goToRiderLocationPage() {
    activeOrderData.call().riderId != 0 ? Get.toNamed(Config.RIDER_LOCATION_ROUTE, arguments: activeOrderData.call()) 
    : alertSnackBarTop(title: 'Oops!', message: 'Please wait for the rider\'s approval');

    // Get.toNamed(Config.RIDER_LOCATION_ROUTE, arguments: activeOrderData.call());
  }

  fetchActiveOrder() {
    socketService.socket.emitWithAck('active-order', '', ack: (response) {
      print('Active order $response');
      if (response['status'] == 200) {
        if (response['data'] == null) {
          onGoingMessage('No Active Order');
          activeOrderData.nil();
        } else {
          activeOrderData(ActiveOrderData.fromJson(response['data']));
        }
      } else {
        onGoingMessage(Config.SOMETHING_WENT_WRONG);
      }
    });
  }

  receiveUpdateOrder() {
    socketService.socket.on('order', (response) {
      print('Receive update: $response');
      final order = ActiveOrder.fromJson(response);
      if (order.status == 200) {
        final name = '${order.data.activeRestaurant.name} - ${order.data.address.location.name}';
        switch (order.data.status) {
          case 'restaurant-declined': {
            pushNotificationService.showNotification(title: 'Hi!,', body: 'Your order in $name has been declined by the restaurant');
            onGoingMessage('No Active Order');
            activeOrderData.nil();
          }
            break;
          case 'restaurant-accepted': {
            pushNotificationService.showNotification(title: 'Hi!,', body: 'Your order in $name has been accepted by the restaurant');
            activeOrderData(ActiveOrderData.fromJson(response['data']));
          }
            break;
          case 'rider-accepted': {
            pushNotificationService.showNotification(title: 'Hi!,', body: 'Your order in $name has been accepted by the rider');
            activeOrderData(ActiveOrderData.fromJson(response['data']));
          }
            break;
          case 'rider-picked-up': {
            pushNotificationService.showNotification(title: 'Hi!,', body: 'Rider has picked up your order');
            activeOrderData(ActiveOrderData.fromJson(response['data']));
          }
            break;
          case 'delivered': {
            pushNotificationService.showNotification(title: 'Hi!,', body: 'Your order in $name has been delivered');
            onGoingMessage('No Active Order');
            activeOrderData.nil();
          }
            break;
        }
      }
    });
  }

  cancelOrderById() {
    socketService.socket.emitWithAck('cancel-order', {'order_id': activeOrderData.value.id}, ack: (response) {
      if (response['status'] == 200) {
        successSnackBarTop(title: 'Success!', message: response['message']);
        onGoingMessage('No Active Order');
        activeOrderData.nil();
      } else {
        errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
      }
    });
  }

  fetchRestaurants() {

    isLoading(true);

    apiService.getAllRestaurants().then((response) {
      isLoading(false);
      tfSearchController.text = '';
      _setRefreshCompleter();
      if (response.status == 200) {
        
        restaurants(response);

        searchRestaurants.call()..clear()..assignAll(response.data.restaurants);
        if(searchRestaurants.call().isEmpty) message('No restaurant found');
      
      } else {
        message(Config.SOMETHING_WENT_WRONG);
      }
      
    }).catchError((onError) {
         isLoading(false);
        _setRefreshCompleter();
        if (onError.toString().contains('Connection failed')) {
          message(Config.NO_INTERNET_CONNECTION);
        } else if (onError.toString().contains('Operation timed out')) {
          message(Config.TIMED_OUT);
        } else {
          message(Config.SOMETHING_WENT_WRONG);
        }
        print('Error fetch restaurant: $onError');
    });
  }

  searchRestaurant(String value) {
    
    if (restaurants.call() != null) {
      isSearching(value.trim().isNotEmpty);
      searchRestaurants.call().clear();
      if (isSearching.call()) {
        
        var restaurant = restaurants.call().data.restaurants.where((element) => element.name.toLowerCase().contains(value.trim().toLowerCase()));

        if (restaurant.isEmpty) {
          searchRestaurants.call().clear();
          message('No restaurant found');
        } else {
          searchRestaurants.call().assignAll(restaurant);
        }
      
      } else {
        searchRestaurants.call().assignAll(restaurants.call().data.restaurants);
      }
    }
  }

  refreshToken() {
    isLoading(true);

    apiService.refreshToken().then((response) {
      isLoading(false);
      _setRefreshCompleter();
      if(response.status == 200) {
        box.write(Config.USER_TOKEN, response.data.accessToken);
      } 

      fetchRestaurants();
      socketSetup();
      
    }).catchError((onError) {
      isLoading(false);
      _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) {
        message(Config.NO_INTERNET_CONNECTION);
      } else if (onError.toString().contains('Operation timed out')) {
        message(Config.TIMED_OUT);
      } else {
        message(Config.SOMETHING_WENT_WRONG);
      }
      print('Refresh token: $onError');
    });
  }

  socketSetup() {
    socketService.connectSocket();
    socketService.socket
    ..on('connect', (_) {
      print('Connected');
      fetchActiveOrder();
      receiveUpdateOrder();
    })
    ..on('connecting', (_) {
      print('Connecting');
      onGoingMessage('Connecting');
    })
    ..on('reconnecting', (_) {
      print('Reconnecting');
      onGoingMessage('Reconnecting');
    })
    ..on('disconnect', (_) {
      onGoingMessage('No Active Order');
      activeOrderData.nil();
      print('Disconnected');
    })
    ..on('error', (_) {
      print('Error socket: $_');
    });
  }
}