import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/activeOrderResponse.dart';
import 'package:letsbeeclient/models/chatResponse.dart';
import 'package:letsbeeclient/models/getAddressResponse.dart';
import 'package:letsbeeclient/models/mart_dashboard_response.dart';
import 'package:letsbeeclient/models/restaurant_dashboard_response.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/account_settings_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/home_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/mart_view.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/services/api_service.dart';
import 'package:letsbeeclient/services/push_notification_service.dart';
import 'package:letsbeeclient/services/socket_service.dart';
// import 'package:intl/intl.dart';

class DashboardController extends GetxController with SingleGetTickerProviderMixin {
  
  TabController tabController;
  AnimationController animationController;
  PageController pageController;
  Animation<Offset> offsetAnimation;
  Completer<void> refreshCompleter;
  GifController gifController;

  final ApiService apiService = Get.find();
  final PushNotificationService pushNotificationService = Get.find();
  final SocketService socketService = Get.find();
  final GetStorage box = Get.find();
  final GoogleSignIn _googleSignIn = Get.find();
  final FacebookLogin _facebookLogin = Get.find();
  
  final restaurantSearchController = TextEditingController();
  final martSearchController = TextEditingController();

  final foodScrollController = ScrollController();
  final martScrollController = ScrollController();

  final widgets = [
    HomePage(), 
    MartPage(),
    AccountSettingsPage(), 
  ];

  var pageIndex = 0.obs;
  var userCurrentNameOfLocation = ''.obs;
  var userCurrentAddress = ''.obs;
  var isFloatVisible = false.obs;
  var isHideAppBar = false.obs;
  var isLoading = false.obs;
  var isSearching = false.obs;
  // var isOnChat = false.obs;
  var isSelectedLocation = false.obs;
  // var message = ''.obs;
  var onGoingMessage = 'No Active Orders...'.obs;
  var cancelMessage = 'Your order has been cancelled. Please see the order history'.obs;
  // var addresses = GetAllAddressResponse().obs;
  var searchRestaurants = RxList<RestaurantStores>().obs;
  var recentRestaurants = RxList<RestaurantStores>().obs;
  var searchMarts = RxList<MartStores>().obs;
  var recentMarts = RxList<MartStores>().obs;
  var restaurantDashboard = RestaurantDashboardResponse().obs;
  var martDashboard = MartDashboardResponse().obs;
  var activeOrderData = ActiveOrderData().obs;
  var activeOrders = ActiveOrder().obs;

  var hasRestaurantError = false.obs;
  var hasMartError = false.obs;

  var restaurantErrorMessage = 'Loading restaurants...'.obs;
  var martErrorMessage = 'Loading shops...'.obs;
  var addressErrorMessage = 'Loading addresses...'.obs;

  var isDisableDeliveryPushNotif = false.obs;
  var isDisablePromotionalPushNotif = false.obs;

  // Timer _timer;

  static DashboardController get to => Get.find();

  GifController changeGifRange({double range, int duration}) {
    gifController.repeat(min:0, max:range,period: Duration(milliseconds: duration));
    return gifController;
  }

  @override
  void onInit() {
    print('Access Token: ${box.read(Config.USER_TOKEN)}');
    restaurantDashboard.nil();
    martDashboard.nil();
    activeOrderData.nil();
    activeOrders.nil();

    userCurrentNameOfLocation(box.read(Config.USER_CURRENT_NAME_OF_LOCATION));
    userCurrentAddress(box.read(Config.USER_CURRENT_ADDRESS));
    pushNotificationService.initialise();

    setupRefreshIndicator();
    setupAnimation();
    setupTabs();
    refreshToken();

    gifController = GifController(vsync: this);

    super.onInit();
  }

  // void startEvery24Hours() {

  //   final now = DateTime.now();
  //   final nextCheck = DateTime(now.year, now.month, now.day + 1);

  //   _timer = Timer.periodic(
  //      Duration(seconds: 1), (Timer timer) {
  //       if (DateFormat('MM-dd-yyyy').format(DateTime.now()) == box.read(Config.NEXT_DAY)) {
  //         refreshToken();
  //       } else {
  //         if (!box.hasData(Config.NEXT_DAY)) {
  //           box.write(Config.NEXT_DAY, DateFormat('MM-dd-yyyy').format(nextCheck));
  //         } else {
  //           // print(box.read(Config.NEXT_DAY));
  //         }
  //       }
  //     },
  //   );

  //   fetchActiveOrders();
  //   fetchRestaurantDashboard();
  //   fetchMartDashboard();
  // }

  refreshSocket({String type = 'initialize'}) {
    if (type == 'initialize') {
      socketService.connectSocket();
    } else {
      socketService.socket..disconnect()..connect();
    }
    socketService.socket
    ..on('connect', (_) {
      print('Connected');
      fetchActiveOrders();
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
      // activeOrders.nil();
      print('Disconnected');
    })
    ..on('error', (_) {
      onGoingMessage('Loading...');
      print('Error socket: $_');
    });
  }

  void setupRefreshIndicator() {
    refreshCompleter = Completer();
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
    tabController = TabController(length: 1, vsync: this);
    pageController = PageController();
  }

  void tapped(int tappedIndex) {
    // tappedIndex == 0 || tappedIndex == 1 ? isHideAppBar(false) : isHideAppBar(true); 
    if (tappedIndex == 0) {
      // restaurantDashboard.nil();
      fetchRestaurantDashboard();
      if (foodScrollController.hasClients) foodScrollController.animateTo(1, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    } else if (tappedIndex == 1) {
      // martDashboard.nil();
      fetchMartDashboard();
      if (martScrollController.hasClients) martScrollController.animateTo(1, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    }
    restaurantSearchController.clear();
    martSearchController.clear();
    pageIndex(tappedIndex);
    pageController.animateToPage(pageIndex.value, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
    dismissKeyboard(Get.context);
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

    final address = '${data.street}, ${data.barangay}, ${data.city}';
    isSelectedLocation(true);
    userCurrentAddress(address);
    userCurrentNameOfLocation(data.name);
    box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.call());
    fetchRestaurantDashboard();
    fetchMartDashboard();
  }

  void clearData() {
    searchRestaurants.nil();
    restaurantDashboard.nil();
    activeOrders.nil();
    // box.erase();
    box.remove(Config.USER_TOKEN);
    box.remove(Config.IS_LOGGED_IN);
    box.remove(Config.USER_CURRENT_STREET);
    box.remove(Config.USER_CURRENT_COUNTRY);
    box.remove(Config.USER_CURRENT_STATE);
    box.remove(Config.USER_CURRENT_CITY);
    box.remove(Config.USER_CURRENT_IS_CODE);
    box.remove(Config.USER_CURRENT_BARANGAY);
    box.remove(Config.USER_CURRENT_LATITUDE);
    box.remove(Config.USER_CURRENT_LONGITUDE);
    box.remove(Config.USER_CURRENT_ADDRESS);
    box.remove(Config.USER_CURRENT_NAME_OF_LOCATION);
  }

  void signOut() {
    // box.remove(Config.PRODUCTS);
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
    _facebookLogin.logOut();
    Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
  }

  void _googleSignOut() async {
    _googleSignIn.disconnect();
    Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
  }

  void _signOut() {
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
      // isOnChat(true);
      activeOrderData.call().rider != null ? Get.toNamed(Config.CHAT_ROUTE, arguments: activeOrderData.call()) 
      : alertSnackBarTop(title: 'Oops!', message: 'Please wait for the rider\'s approval');
    }
  }

  goToRiderLocationPage() {
    activeOrderData.call().status == 'rider-picked-up' ? Get.toNamed(Config.RIDER_LOCATION_ROUTE, arguments: activeOrderData.call()) 
    : alertSnackBarTop(title: 'Oops!', message: 'Please wait for the rider\'s pick up');
  }

  fetchActiveOrders() {
    onGoingMessage('Loading...');
    if (socketService.socket != null) {
      socketService.socket.emitWithAck('active-orders', '', ack: (response) {
        'Active orders: $response'.printWrapped();
        activeOrders(ActiveOrder.fromJson(response));
        if (activeOrders.call().status == 200) {
          onGoingMessage('No Active Order');
          if (activeOrders.call().data.isEmpty) {
            activeOrders.nil();
          } else {
            activeOrders(ActiveOrder.fromJson(response));
            activeOrders.call().data.sort((b, a) => a.id.compareTo(b.id));
          }
        } else {
          onGoingMessage(Config.SOMETHING_WENT_WRONG);
        }
      });
    }
  }

  receiveUpdateOrder() {
    socketService.socket.on('order', (response) {
      'Receive update: $response'.printWrapped();
      fetchActiveOrders();
      String message;
      if (response['status'] == 200) {
        
        if (activeOrderData.call() != null) {
          if (activeOrderData.call().id == response['data']['id']) {
            activeOrderData(ActiveOrderData.fromJson(response['data']));
          }
        }

        switch (response['code']) {
          case 'store-declined': {
            final order = ActiveOrderData.fromJson(response['data']);
            final name = order.activeStore.locationName == null || order.activeStore.locationName == '' ? order.activeStore.name : '${order.activeStore.name} - ${order.activeStore.locationName}';

            message = 'Your order in $name has been declined';
            pushNotificationService.showNotification(title: 'Hi ${box.read(Config.USER_NAME)}!', body: message);
          }
            break;
          case 'store-accepted': {
            final order = ActiveOrderData.fromJson(response['data']);
            final name = order.activeStore.locationName == null || order.activeStore.locationName == '' ? order.activeStore.name : '${order.activeStore.name} - ${order.activeStore.locationName}';

            message = 'Your order in $name has been accepted';
            pushNotificationService.showNotification(title: 'Hi ${box.read(Config.USER_NAME)}!', body: message);
          }
            break;
          case 'rider-accepted': {
            message = 'Let\'s Bee Rider is on the way to pick up your food';
            pushNotificationService.showNotification(title: 'Hi ${box.read(Config.USER_NAME)}!', body: message);
          }
            break;
          case 'rider-picked-up': {
            message = 'Let\'s Bee Rider is on the way to your location';
            pushNotificationService.showNotification(title: 'Hi ${box.read(Config.USER_NAME)}!', body: message);
          }
            break;
          case 'delivered': {
            final order = ActiveOrderData.fromJson(response['data']);
            final name = order.activeStore.locationName == null || order.activeStore.locationName == '' ? order.activeStore.name : '${order.activeStore.name} - ${order.activeStore.locationName}';

            message = 'Your order in $name has been delivered';
            pushNotificationService.showNotification(title: 'Hi ${box.read(Config.USER_NAME)}!', body: message);

            fetchRestaurantDashboard();
            fetchMartDashboard();
            fetchActiveOrders();
          }
            break;
        }
      }
    });
  }

  receiveChat() {
    socketService.socket.on('order-chat', (response) {
      print('receive message: $response');
      final test = ChatData.fromJson(response['data']);

      // if(Get.currentRoute != Config.CHAT_ROUTE) {
      //   pushNotificationService.showNotification(title: 'You have a new message from Let\'s Bee Rider', body: test.message, payload: chatDataToJson(test));
      // }

      pushNotificationService.showNotification(title: 'You have a new message from Let\'s Bee Rider', body: test.message, payload: chatDataToJson(test));
    });
  }

  cancelOrderById() {
    socketService.socket.emitWithAck('cancel-order', {'order_id': activeOrderData.value.id}, ack: (response) {
      if (response['status'] == 200) {
        fetchActiveOrders();
        Get.back(result: 'cancel-dialog');
        cancelMessage('Your order has been cancelled. Please see the order history.');
        activeOrderData.nil();
        Get.back(closeOverlays: true);
      } else {
        errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
      }
    });
  }

  refreshToken() {
    restaurantErrorMessage('Loading restaurants...');
    martErrorMessage('Loading shops...');
    hasMartError(false);
    hasRestaurantError(false);
    isLoading(true);
    // message(title);
    apiService.refreshToken().then((response) {
      // message(null);
      _setRefreshCompleter();
      if(response.status == 200) {
        // _timer.cancel();
        // box.remove(Config.NEXT_DAY);
        box.write(Config.USER_TOKEN, response.data.accessToken);
        // startEvery24Hours();
      } 

      Future.delayed(Duration(seconds: 1)).then((value) {
        if (socketService.socket == null) refreshSocket(); else refreshSocket(type: 'refresh');
        fetchActiveOrders();
        fetchRestaurantDashboard();
        fetchMartDashboard();
      });
      
    }).catchError((onError) {
      isLoading(false);
      _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) {
        // message(Config.NO_INTERNET_CONNECTION);
        restaurantErrorMessage(Config.NO_INTERNET_CONNECTION);
        martErrorMessage(Config.NO_INTERNET_CONNECTION);
        addressErrorMessage(Config.NO_INTERNET_CONNECTION);
      } else if (onError.toString().contains('Operation timed out')) {
        // message(Config.TIMED_OUT);
        restaurantErrorMessage(Config.TIMED_OUT);
        martErrorMessage(Config.TIMED_OUT);
        addressErrorMessage(Config.TIMED_OUT);
      } else {
        restaurantErrorMessage(Config.SOMETHING_WENT_WRONG);
        martErrorMessage(Config.SOMETHING_WENT_WRONG);
        addressErrorMessage(Config.SOMETHING_WENT_WRONG);
      }
      hasMartError(true);
      hasRestaurantError(true);
      print('Refresh token: $onError');
    });
  }

  fetchRestaurantDashboard() {
    restaurantErrorMessage('Loading restaurants...');
    isLoading(true);
    hasRestaurantError(false);
    apiService.getRestaurantDashboard().then((response) {
      isLoading(false);
      isSelectedLocation(false);
      hasRestaurantError(false);
      restaurantSearchController.text = '';
      _setRefreshCompleter();
      if (response.status == 200) {
        restaurantDashboard(response);

        final Map<int, RestaurantStores> newMap = Map();
        response.data.recentStores.forEach((item) {
          newMap[item.id] = item;
        });
        recentRestaurants.call()..clear()..assignAll(newMap.values.toList());
        searchRestaurants.call()..clear()..assignAll(response.data.stores);
        if(searchRestaurants.call().isEmpty) {
          restaurantDashboard.nil();
          hasRestaurantError(true);
          restaurantErrorMessage('No restaurants found');
        }
      } else {
        restaurantErrorMessage(Config.SOMETHING_WENT_WRONG);
      }
      
    }).catchError((onError) {
      hasRestaurantError(true);
      isLoading(false);
      isSelectedLocation(false);
      _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) {
        restaurantErrorMessage(Config.NO_INTERNET_CONNECTION);
      } else if (onError.toString().contains('Operation timed out')) {
        restaurantErrorMessage(Config.TIMED_OUT);
      } else {
        restaurantErrorMessage(Config.SOMETHING_WENT_WRONG);
      }
      print('Error fetch restaurant: $onError');
    });
  }

  fetchMartDashboard() {
    martErrorMessage('Loading shops...');
    isLoading(true);
    hasMartError(false);
    apiService.getMartDashboard().then((response) {
      isLoading(false);
      isSelectedLocation(false);
      hasMartError(false);
      martSearchController.text = '';
      _setRefreshCompleter();
      if (response.status == 200) {
        martDashboard(response);
        final Map<int, MartStores> newMap = Map();
        response.data.recentStores.forEach((item) {
          newMap[item.id] = item;
        });
        recentMarts.call()..clear()..assignAll(newMap.values.toList());
        searchMarts.call()..clear()..assignAll(response.data.stores);
        if(searchMarts.call().isEmpty) {
          martDashboard.nil();
          hasMartError(true);
          martErrorMessage('No marts found');
        }
      
      } else {

        martErrorMessage(Config.SOMETHING_WENT_WRONG);
      }
      
    }).catchError((onError) {
      hasMartError(true);
      isLoading(false);
      isSelectedLocation(false);
      _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) {
        martErrorMessage(Config.NO_INTERNET_CONNECTION);
      } else if (onError.toString().contains('Operation timed out')) {
        martErrorMessage(Config.TIMED_OUT);
      } else {
        martErrorMessage(Config.SOMETHING_WENT_WRONG);
      }
      print('Error fetch mart: $onError');
    });
  }

  searchRestaurant({String value = ''}) {
    
    if (restaurantDashboard.call() != null) {
      isSearching(value.trim().isNotEmpty);
      searchRestaurants.call().clear();
      if (isSearching.call()) {
        
        var restaurant = restaurantDashboard.call().data.stores.where((element) => element.name.toLowerCase().contains(value.trim().toLowerCase()) || element.category.toLowerCase().contains(value.trim().toLowerCase()));

        if (restaurant.isEmpty) {
          searchRestaurants.call().clear();
          restaurantErrorMessage('No restaurant found');
        } else {
          searchRestaurants.call().assignAll(restaurant);
        }
      
      } else {
        searchRestaurants.call().assignAll(restaurantDashboard.call().data.stores);
      }
    }
  }

  searchMart({String value = ''}) {
    
    if (martDashboard.call() != null) {
      isSearching(value.trim().isNotEmpty);
      searchMarts.call().clear();
      if (isSearching.call()) {
        
        var mart = martDashboard.call().data.stores.where((element) => element.name.toLowerCase().contains(value.trim().toLowerCase()) || element.category.toLowerCase().contains(value.trim().toLowerCase()));

        if (mart.isEmpty) {
          searchMarts.call().clear();
          martErrorMessage('No mart found');
        } else {
          searchMarts.call().assignAll(mart);
        }
      
      } else {
        searchMarts.call().assignAll(martDashboard.call().data.stores);
      }
    }
  }
}