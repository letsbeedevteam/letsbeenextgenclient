import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/activeOrderResponse.dart';
import 'package:letsbeeclient/models/chatResponse.dart';
import 'package:letsbeeclient/models/getAddressResponse.dart';
import 'package:letsbeeclient/models/orderHistoryResponse.dart';
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
  final scrollController = ScrollController();
  final widgets = [
    HomePage(), 
    NotificationPage(), 
    ReviewsPage(), 
    OrderPage(),
    AccountSettingsPage(), 
  ];

  var title = ''.obs;
  var pageIndex = 0.obs;
  var userCurrentNameOfLocation = ''.obs;
  var userCurrentAddress = ''.obs;
  var isFloatVisible = false.obs;
  var isHideAppBar = false.obs;
  var isOpenLocationSheet = false.obs;
  var isLoading = false.obs;
  var isSearching = false.obs;
  var isOnChat = false.obs;
  var isSelectedLocation = false.obs;
  var message = ''.obs;
  var onGoingMessage = 'Loading...'.obs;
  var historyMessage = 'No list of history'.obs;
  var addressMessage = 'Loading...'.obs;
  var history = OrderHistoryResponse().obs;
  var addresses = GetAllAddressResponse().obs;
  var restaurants = Restaurant().obs;
  var searchRestaurants = RxList<RestaurantElement>().obs;
  var activeOrderData = ActiveOrderData().obs;
  var activeOrders = ActiveOrder().obs;

  static DashboardController get to => Get.find();

  @override
  void onInit() {
    print('Access Token: ${box.read(Config.USER_TOKEN)}');
    history.nil();
    restaurants.nil();
    activeOrderData.nil();
    addresses.nil();
    activeOrders.nil();

    userCurrentNameOfLocation(box.read(Config.USER_CURRENT_NAME_OF_LOCATION));
    userCurrentAddress(box.read(Config.USER_CURRENT_ADDRESS));
    pushNotificationService.initialise();

    // setupScrollControllers();
    setupRefreshIndicator();
    setupAnimation();
    setupTabs();
    refreshToken();

    super.onInit();
  }

  socketSetup() {
    socketService.connectSocket();
    socketService.socket
    ..on('connect', (_) {
      print('Connected');
      fetchActiveOrder();
      receiveUpdateOrder();
      receiveChat();
    })
    ..on('connecting', (_) {
      print('Connecting');
      onGoingMessage('Loading...');
    })
    ..on('reconnecting', (_) {
      print('Reconnecting');
      onGoingMessage('Loading...');
    })
    ..on('disconnect', (_) {
      onGoingMessage('Loading...');
      // activeOrderData.nil();
      activeOrders.nil();
      print('Disconnected');
    })
    ..on('error', (_) {
      onGoingMessage('Loading...');
      print('Error socket: $_');
    });
  }

  // void setupScrollControllers() {
  //   isFloatVisible(true);
  //   scrollController.addListener(() {
  //      if(scrollController.position.userScrollDirection == ScrollDirection.reverse){
  //       if(isFloatVisible.call()) {
  //         isFloatVisible(false);
  //       }
  //     } else {
  //       if(scrollController.position.userScrollDirection == ScrollDirection.forward){
  //         if(!isFloatVisible.call()) {
  //           isFloatVisible(true);  
  //         }
  //       }
  //     }
  //   });
  // }

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
    // tabController = TabController(length: 2, vsync: this)..addListener(() {
    //   if(tabController.index == 0) {
    //     animationController.reverse();
    //   } else {
    //     animationController.forward();
    //   }
    // });

    tabController = TabController(length: 1, vsync: this);
    pageController = PageController();
  }

  void showLocationSheet(bool isOpenLocationSheet) => this.isOpenLocationSheet(isOpenLocationSheet);

  void tapped(int tappedIndex) {
    tappedIndex == 0 ? isHideAppBar(false) : isHideAppBar(true); 
    if (tappedIndex == 3) {
      // fetchActiveOrder();
      fetchOrderHistory();
    }
    tfSearchController.clear();
    searchRestaurant('');
    pageIndex(tappedIndex);
    pageController.animateToPage(pageIndex.value, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
  }

  void updateCurrentLocation(AddressData data) {
    box.write(Config.USER_CURRENT_STREET, data.street);
    box.write(Config.USER_CURRENT_COUNTRY, data.country);
    box.write(Config.USER_CURRENT_STATE, data.state);
    box.write(Config.USER_CURRENT_CITY, data.city);
    box.write(Config.USER_CURRENT_IS_CODE, data.street);
    box.write(Config.USER_CURRENT_BARANGAY, data.barangay);
    box.write(Config.USER_CURRENT_LATITUDE, data.location.lat);
    box.write(Config.USER_CURRENT_LONGITUDE,  data.location.lng);
    box.write(Config.USER_CURRENT_NAME_OF_LOCATION, data.name);

    final address = '${data.street}, ${data.barangay}, ${data.city}, ${data.state}, ${data.country}';
    isSelectedLocation(true);
    userCurrentAddress(address);
    userCurrentNameOfLocation(data.name);
    box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.call());
    showLocationSheet(false);
    fetchRestaurants();
  }

  void clearData() {
    box.erase();
    history.nil();
    addresses.nil();
    restaurants.nil();
    searchRestaurants.nil();
    // activeOrderData.nil();
    activeOrders.nil();
  }

  void signOut() {
    socketService.disconnectSocket();
    clearData();
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
  }

  void _facebookSignOut() async {
    // await _facebookLogin.logOut().then((value) {
    //   box.write(Config.IS_LOGGED_IN, false);
    //   box.write(Config.IS_SETUP_LOCATION, false);
    //   box.remove(Config.USER_TOKEN);
    //   Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
    // });
    _facebookLogin.logOut();
    box.write(Config.IS_LOGGED_IN, false);
    box.write(Config.IS_SETUP_LOCATION, false);
    box.remove(Config.USER_TOKEN);
    Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
  }

  void _googleSignOut() async {
    // await _googleSignIn.disconnect().then((value) {
    //   box.write(Config.IS_LOGGED_IN, false);
    //   box.write(Config.IS_SETUP_LOCATION, false);
    //   box.remove(Config.USER_TOKEN);
    //   Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
    // });
    _googleSignIn.disconnect();
    box.write(Config.IS_LOGGED_IN, false);
    box.write(Config.IS_SETUP_LOCATION, false);
    box.remove(Config.USER_TOKEN);
    Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
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

  goToChatPage({@required bool fromNotificartion, ChatData data}) {
    if (fromNotificartion) {
      activeOrderData(activeOrders.call().data.where((element) => element.id == data.orderId).first);
      Get.toNamed(Config.CHAT_ROUTE, arguments: activeOrderData.call());
    } else {
      isOnChat(true);
      activeOrderData.call().rider != null ? Get.toNamed(Config.CHAT_ROUTE, arguments: activeOrderData.call()) 
      : alertSnackBarTop(title: 'Oops!', message: 'Please wait for the rider\'s approval');
    }
  }

  goToRiderLocationPage() {
    activeOrderData.call().status == 'rider-picked-up' ? Get.toNamed(Config.RIDER_LOCATION_ROUTE, arguments: activeOrderData.call()) 
    : alertSnackBarTop(title: 'Oops!', message: 'Please wait for the rider\'s pick up');
  }

  fetchActiveOrder() {
    onGoingMessage('Loading...');
    if (socketService.socket != null) {
       socketService.socket.emitWithAck('active-orders', '', ack: (response) {
         'Active orders: $response'.printWrapped();
         activeOrders(ActiveOrder.fromJson(response));
        if (activeOrders.call().status == 200) {
          if (activeOrders.call().data.isEmpty) {
            onGoingMessage('No Active Order');
            activeOrderData.nil();
            activeOrders.nil();
          } else {
            activeOrders(ActiveOrder.fromJson(response));
          }
        } else {
          onGoingMessage(Config.SOMETHING_WENT_WRONG);
        }
      });
    } else {
      socketSetup();
    }
  }

  receiveUpdateOrder() {
    socketService.socket.on('order', (response) {
        'Receive update: $response'.printWrapped();
        String message;
        fetchActiveOrder();
        if (response['status'] == 200) {

          final order = ActiveOrderData.fromJson(response['data']);
          
          final name = order.activeRestaurant.locationName == null ? order.activeRestaurant.name : '${order.activeRestaurant.name} - ${order.activeRestaurant.locationName}';
          
          // if (activeOrderData.call().id == order.id) {
            switch (response['code']) {
              case 'restaurant-declined': {
                message = 'Your order in $name has been declined by the Restaurant';
                pushNotificationService.showNotification(title: 'Hi!', body: message);
                onGoingMessage('No Active Order');
                activeOrderData.nil();
              }
                break;
              case 'restaurant-accepted': {
                message = 'Your order in $name has been accepted by the Restaurant';
                pushNotificationService.showNotification(title: 'Hi!', body: message);
                activeOrderData(ActiveOrderData.fromJson(response['data']));
              }
                break;
              case 'rider-accepted': {
                message = 'Your order in $name has been accepted by the Let\'s Bee Rider';
                pushNotificationService.showNotification(title: 'Hi!', body: message);
                activeOrderData(ActiveOrderData.fromJson(response['data']));
              }
                break;
              case 'rider-picked-up': {
                message = 'Let\'s Bee Rider has picked up your order';
                pushNotificationService.showNotification(title: 'Hi!', body: message);
                activeOrderData(ActiveOrderData.fromJson(response['data']));
              }
                break;
              case 'delivered': {
                message = 'Your order in ${order.activeRestaurant.name} - ${order.activeRestaurant.locationName} has been delivered';
                pushNotificationService.showNotification(title: 'Hi!', body: message);
                onGoingMessage('No Active Order');
                fetchOrderHistory();
                activeOrderData.nil();
              }
                break;
            }
          // }
        }
    });
  }

  receiveChat() {
    socketService.socket.on('order-chat', (response) {
      print('receive message: $response');
      final test = ChatData.fromJson(response['data']);
      // activeOrderData(activeOrders.call().data.where((element) => element.id == test.orderId).first);

      if(Get.currentRoute != Config.CHAT_ROUTE) {
        pushNotificationService.showNotification(title: 'You have a new message from Let\'s Bee Rider', body: test.message, payload: chatDataToJson(test));
      }
    });
  }

  cancelOrderById() {
    socketService.socket.emitWithAck('cancel-order', {'order_id': activeOrderData.value.id}, ack: (response) {
      if (response['status'] == 200) {
        fetchOrderHistory();
        fetchActiveOrder();
        Get.back(result: 'cancel-dialog');
        // successSnackBarTop(title: 'Success!', message: response['message']);
        onGoingMessage('No Active Order');
        activeOrderData.nil();
        Get.back();
      } else {
        errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
      }
    });
  }

  fetchOrderHistory() {
    isLoading(true);
    apiService.orderHistory().then((response) {
      isLoading(false);
      _setRefreshCompleter();
      if (response.status == 200) {

        if (response.data.isNotEmpty) {
          history(response);
          history.call().data.sort((b, a) => a.id.compareTo(b.id));
        } else {
          historyMessage('No list of history orders');
          history.nil();
        }

      } else {
        historyMessage(Config.SOMETHING_WENT_WRONG);
      }
      
    }).catchError((onError) {
      isLoading(false);
      _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) {
        historyMessage(Config.NO_INTERNET_CONNECTION);
      } else if (onError.toString().contains('Operation timed out')) {
        historyMessage(Config.TIMED_OUT);
      } else {
        historyMessage(Config.SOMETHING_WENT_WRONG);
      }
      print('Error fetch history orders: $onError');
    });
  }

  fetchRestaurants() {

    isLoading(true);

    apiService.getAllRestaurants().then((response) {
      isLoading(false);
      isSelectedLocation(false);
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
         isSelectedLocation(false);
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
      // isLoading(false);
      message(null);
      _setRefreshCompleter();
      if(response.status == 200) {
        box.write(Config.USER_TOKEN, response.data.accessToken);
      } 

      Future.delayed(Duration(seconds: 1)).then((value) {
        socketSetup();
        fetchAllAddresses();
      });
      
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

  addAddress() => Get.toNamed(Config.MAP_ROUTE, arguments: {'type': Config.ADD_NEW_ADDRESS});

  fetchAllAddresses() {
    isLoading(true);
    apiService.getAllAddress().then((response) {
      isLoading(false);
      if (response.status == 200) {
        fetchRestaurants();
        if (response.data.isNotEmpty) {
          addresses(response);
        } else {
          addresses.nil();
          addressMessage('No list of address');
        }

      } else {
        addresses.nil();
        addressMessage(Config.SOMETHING_WENT_WRONG);
      }
      
    }).catchError((onError) {
      addresses.nil();
      isLoading(false);
      addressMessage(Config.SOMETHING_WENT_WRONG);
      print('Error fetch all address: $onError');
    });
  }
}