import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/active_order_response.dart';
import 'package:letsbeeclient/models/chat_response.dart';
import 'package:letsbeeclient/models/get_address_response.dart';
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
  final reasonController = TextEditingController();

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
  // var isSearching = false.obs;
  // var isOnChat = false.obs;
  var isSelectedLocation = false.obs;
  // var message = ''.obs;
  var onGoingMessage = 'No Active Orders...'.obs;
  var cancelMessage = 'Your order has been cancelled. Please see the order history'.obs;
  // var addresses = GetAllAddressResponse().obs;
  var reason = ''.obs;
  var searchRestaurants = RxList<RestaurantStores>().obs;
  var recentRestaurants = RxList<RestaurantStores>().obs;
  var searchMarts = RxList<MartStores>().obs;
  var recentMarts = RxList<MartStores>().obs;
  // var restaurantDashboard = RestaurantDashboardResponse().obs;
  // var martDashboard = MartDashboardResponse().obs;
  var activeOrderData = ActiveOrderData().obs;
  var activeOrders = ActiveOrder().obs;

  var hasRestaurantError = false.obs;
  var hasMartError = false.obs;

  var restaurantErrorMessage = tr('loadingRestaurants').obs;
  var martErrorMessage = tr('loadingShops').obs;

  var isDisableDeliveryPushNotif = false.obs;
  var isDisablePromotionalPushNotif = false.obs;

  var countRestoPage = 0.obs;
  var searchRestaurantValue = ''.obs;
  var isRestaurantLoadingScroll = true.obs;
  
  var searchMartValue = ''.obs;
  var countMartPage = 0.obs;
  var isMartLoadingScroll = false.obs;

  static DashboardController get to => Get.find();

  GifController changeGifRange({double range, int duration}) {
    gifController.repeat(min:0, max:range,period: Duration(milliseconds: duration));
    return gifController;
  }

  @override
  void onInit() {
    print('Access Token: ${box.read(Config.USER_TOKEN)}');
    activeOrderData.nil();
    activeOrders.nil();
    reason.nil();

    userCurrentNameOfLocation(box.read(Config.USER_CURRENT_NAME_OF_LOCATION));
    userCurrentAddress(box.read(Config.USER_CURRENT_ADDRESS));
    pushNotificationService.initialise();

    setupRefreshIndicator();
    setupAnimation();
    setupTabs();
    refreshToken(page: 0);

    gifController = GifController(vsync: this);

    foodScrollController.addListener(() {
      if (foodScrollController.position.atEdge) {
        if (foodScrollController.position.pixels != 0) {
          if (!isRestaurantLoadingScroll.call()) {
            fetchRestaurantDashboard(page: countRestoPage.call());
          }
          isRestaurantLoadingScroll(true);
        } 
      }
    });

    martScrollController.addListener(() {
      if (martScrollController.position.atEdge) {
        if (martScrollController.position.pixels != 0) {
          if (!isMartLoadingScroll.call()) {
            fetchMartDashboard(page: countMartPage.call());
          }
          isMartLoadingScroll(true);
        } 
      }
    });

    super.onInit();
  }
  
  refreshSocket() {
    socketService.connectSocket();

    socketService.socket?.on('connect', (_) {
      print('Connected');
      fetchActiveOrders();
      receiveUpdateOrder();
      receiveChat();
    });
    socketService.socket?.on('connecting', (_) {
      print('Connecting');
      onGoingMessage(tr('loading'));
    });
    socketService.socket?.on('reconnecting', (_) {
      print('Reconnecting');
      onGoingMessage(tr('loading'));
    });
    socketService.socket?.on('disconnect', (_) {
      onGoingMessage(tr('loading'));
      print('Disconnected');
    });
    socketService.socket?.on('error', (_) {
      onGoingMessage(tr('loading'));
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
    if (tappedIndex == 0) {
      // restaurantDashboard.nil();
      // fetchRestaurantDashboard(page: 0);
      if (foodScrollController.hasClients) foodScrollController.animateTo(1, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    } else if (tappedIndex == 1) {
      // martDashboard.nil();
      // fetchMartDashboard(page: 0);
      if (martScrollController.hasClients) martScrollController.animateTo(1, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    }
    searchRestaurantValue('');
    searchMartValue('');
    pageIndex(tappedIndex);
    pageController.animateToPage(pageIndex.value, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
    dismissKeyboard(Get.context);
  }

  void updateCurrentLocation(AddressData data) {
    box.write(Config.USER_ID, data.userId);
    box.write(Config.USER_ADDRESS_ID, data.id);
    box.write(Config.USER_CURRENT_ADDRESS, data.address);
    box.write(Config.NOTE_TO_RIDER, data.note);
    box.write(Config.USER_CURRENT_NAME_OF_LOCATION, data.name);
    box.write(Config.USER_CURRENT_LATITUDE, data.location.lat);
    box.write(Config.USER_CURRENT_LONGITUDE,  data.location.lng);

    isSelectedLocation(true);
    userCurrentAddress(data.address);
    userCurrentNameOfLocation(data.name);
    box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.call());
    fetchRestaurantDashboard(page: 0);
    fetchMartDashboard(page: 0);
    fetchActiveOrders();
  }

  void clearData() {
    searchRestaurants.call().clear();
    searchMarts.call().clear();
    activeOrders.nil();
    box.remove(Config.USER_TOKEN);
    box.remove(Config.USER_ADDRESS_ID);
    box.remove(Config.USER_ID);
    box.remove(Config.USER_CURRENT_LATITUDE);
    box.remove(Config.USER_CURRENT_LONGITUDE);
    box.remove(Config.USER_CURRENT_ADDRESS);
    box.remove(Config.USER_CURRENT_NAME_OF_LOCATION);
    box.remove(Config.IS_LOGGED_IN);
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
    await _facebookLogin.logOut();
    Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
  }

  void _googleSignOut() async {
    await _googleSignIn.disconnect();
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
      Get.toNamed(Config.CHAT_ROUTE, arguments: activeOrderData.call());
    }
  }

  goToRiderLocationPage() => Get.toNamed(Config.RIDER_LOCATION_ROUTE, arguments: activeOrderData.call());

  fetchActiveOrders() {
    onGoingMessage(tr('loading'));
    socketService.socket?.emitWithAck('active-orders', '', ack: (response) {
      'Active orders: $response'.printWrapped();
      activeOrders(ActiveOrder.fromJson(response));
      if (activeOrders.call().status == 200) {
        onGoingMessage(tr('noActiveOrder'));
        if (activeOrders.call().data.isEmpty) {
          activeOrders.nil();
        } else {
          activeOrders(ActiveOrder.fromJson(response));
          activeOrders.call().data.sort((b, a) => a.id.compareTo(b.id));
        }
      } else {
        activeOrders.nil();
        onGoingMessage(Config.somethingWentWrong);
      }
    });
  }

  receiveUpdateOrder() {
    socketService.socket?.on('order', (response) {
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

            message = tr('orderDeclined').replaceAll('{}', name);
            pushNotificationService.showNotification(title: 'Hi ${box.read(Config.USER_NAME)}!', body: message);
          }
            break;
          case 'store-accepted': {
            final order = ActiveOrderData.fromJson(response['data']);
            final name = order.activeStore.locationName == null || order.activeStore.locationName == '' ? order.activeStore.name : '${order.activeStore.name} - ${order.activeStore.locationName}';

            message = tr('orderAccepted').replaceAll('{}', name);
            pushNotificationService.showNotification(title: 'Hi ${box.read(Config.USER_NAME)}!', body: message);
          }
            break;
          case 'rider-accepted': {
            message = tr('riderAccept');
            pushNotificationService.showNotification(title: 'Hi ${box.read(Config.USER_NAME)}!', body: message);
          }
            break;
          case 'rider-picked-up': {
            message = tr('riderPickUp');
            pushNotificationService.showNotification(title: 'Hi ${box.read(Config.USER_NAME)}!', body: message);
          }
            break;
          case 'delivered': {
            final order = ActiveOrderData.fromJson(response['data']);
            final name = order.activeStore.locationName == null || order.activeStore.locationName == '' ? order.activeStore.name : '${order.activeStore.name} - ${order.activeStore.locationName}';

            message = tr('orderDelivered').replaceAll('{}', name);
            pushNotificationService.showNotification(title: 'Hi ${box.read(Config.USER_NAME)}!', body: message);

            if (Get.currentRoute == Config.ACTIVE_ORDER_ROUTE) Get.back(closeOverlays: true);

            Get.defaultDialog(
              title: tr('yay'),
              content: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text('$message. ${tr('checkOrderHistory')}', style:  TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
              ),
              cancel: RaisedButton(
                onPressed: () => Get.back(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20) 
                ),
                color: Color(Config.LETSBEE_COLOR),
                child: Text(tr('dismiss'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
              )
            );

            // fetchRestaurantDashboard(page: countRestoPage.call());
            // fetchMartDashboard(page: countMartPage.call());
            fetchActiveOrders();
          }
            break;
        }
      }
    });
  }

  receiveChat() {
    socketService.socket?.on('order-chat', (response) {
      print('receive message: $response');
      final test = ChatData.fromJson(response['data']);
      pushNotificationService.showNotification(title: '${tr('newMessageFromRider')}', body: test.message, payload: chatDataToJson(test));
    });
  }

  cancelOrderById() {

    if (reason.call() != null) {

      if (reason.call() == "Others") {

        if (reasonController.text.trim().isEmpty) {
          errorSnackbarTop(title: Config.oops, message: tr('specifyYourReason'));
        } else {
          cancel();
        }

      } else {
        cancel();
      }

    } else {
      errorSnackbarTop(title: Config.oops, message: tr('selectReason'));
    }
  }

  cancel() {
    socketService.socket?.emitWithAck('cancel-order', {'order_id': activeOrderData.value.id}, ack: (response) {
      print(response);
      if (response['status'] == 200) {
        reasonController.clear();
        reason.nil();
        fetchActiveOrders();
        Get.back(closeOverlays: true);
        Get.defaultDialog(
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(tr('orderCancelled'), style:  TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
          ),
          cancel: RaisedButton(
            onPressed: () => Get.back(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20) 
            ),
            color: Color(Config.LETSBEE_COLOR),
            child: Text(tr('dismiss'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
          )
        );
        reason.nil();
        activeOrderData.nil();
      } else {

        if (response['code'] == 3009) {
          errorSnackbarTop(title: Config.oops, message: tr('orderHasBeenDeclined'));
        } else {
          errorSnackbarTop(title: Config.oops, message: Config.somethingWentWrong);
        }
      }
    });
  }

  refreshToken({@required int page}) {
    countMartPage(page);
    countRestoPage(page);
    restaurantErrorMessage(tr('loadingRestaurants'));
    martErrorMessage(tr('loadingShops'));
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
        socketService.connectSocket();
        // startEvery24Hours();
      } 

      Future.delayed(Duration(seconds: 1)).then((value) {
        refreshSocket();
        fetchRestaurantDashboard(page: page);
        fetchMartDashboard(page: page);
      });
      
    }).catchError((onError) {
      isLoading(false);
      _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) {
        // message(Config.NO_INTERNET_CONNECTION);
        restaurantErrorMessage(Config.noInternetConnection);
        martErrorMessage(Config.noInternetConnection);
      } else if (onError.toString().contains('Operation timed out')) {
        // message(Config.TIMED_OUT);
        restaurantErrorMessage(Config.timedOut);
        martErrorMessage(Config.timedOut);
      } else {
        restaurantErrorMessage(Config.somethingWentWrong);
        martErrorMessage(Config.somethingWentWrong);
      }
      hasMartError(true);
      hasRestaurantError(true);
      print('Refresh token: $onError');
    });
  }

  fetchRestaurantDashboard({@required int page}) {
    restaurantErrorMessage(tr('loadingRestaurants'));
    isLoading(true);
    hasRestaurantError(false);
    apiService.getRestaurantDashboard(page: page).then((response) {
      isLoading(false);
      isSelectedLocation(false);
      hasRestaurantError(false);
      _setRefreshCompleter();
      if (response.status == 200) {

        final Map<int, RestaurantStores> newMap = Map();
        response.data.recentStores.forEach((item) {
          newMap[item.id] = item;
        });
        recentRestaurants.call()..clear()..assignAll(newMap.values.toList());

        if (page == 0) {
          countRestoPage(1);
          searchRestaurants.call()..clear()..assignAll(response.data.stores);
        } else {

          if (response.data.stores.isNotEmpty) {
            countRestoPage.value++;
            searchRestaurants.call().addAll(response.data.stores);
          } else {
            print('No restaurant store at page $page');
          }
        }

        if(searchRestaurants.call().isEmpty) {
          recentRestaurants.call().clear();
          hasRestaurantError(true);
          restaurantErrorMessage(tr('noRestaurants'));
        }
        
      } else {
        restaurantErrorMessage(Config.somethingWentWrong);
      }

      isRestaurantLoadingScroll(false);
      
    }).catchError((onError) {
      isRestaurantLoadingScroll(false);
      hasRestaurantError(true);
      isLoading(false);
      isSelectedLocation(false);
      _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) {
        restaurantErrorMessage(Config.noInternetConnection);
      } else if (onError.toString().contains('Operation timed out')) {
        restaurantErrorMessage(Config.timedOut);
      } else {
        restaurantErrorMessage(Config.somethingWentWrong);
      }
      print('Error fetch restaurant: $onError');
    });
  }

  fetchMartDashboard({@required int page}) {
    martErrorMessage(tr('loadingShops'));
    isLoading(true);
    hasMartError(false);
    apiService.getMartDashboard(page: page).then((response) {
      isLoading(false);
      isSelectedLocation(false);
      hasMartError(false);
      _setRefreshCompleter();
      if (response.status == 200) {

        final Map<int, MartStores> newMap = Map();
        response.data.recentStores.forEach((item) {
          newMap[item.id] = item;
        });
        recentMarts.call()..clear()..assignAll(newMap.values.toList());

        if (page == 0) {
          countMartPage(1);
          searchMarts.call()..clear()..assignAll(response.data.stores);
        } else {

          if (response.data.stores.isNotEmpty && response.data.recentStores.isNotEmpty) {
            countMartPage.value++;
            searchMarts.call().addAll(response.data.stores);
          } else {
            print('No mart store at page $page');
          }
        }

        if(searchMarts.call().isEmpty) {
          searchMarts.call().clear();
          hasMartError(true);
          martErrorMessage(tr('noShops'));
        }
      
      } else {

        martErrorMessage(Config.somethingWentWrong);
      }
      
      isMartLoadingScroll(false);

    }).catchError((onError) {
      isMartLoadingScroll(false);
      hasMartError(true);
      isLoading(false);
      isSelectedLocation(false);
      _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) {
        martErrorMessage(Config.noInternetConnection);
      } else if (onError.toString().contains('Operation timed out')) {
        martErrorMessage(Config.timedOut);
      } else {
        martErrorMessage(Config.somethingWentWrong);
      }
      print('Error fetch mart: $onError');
    });
  }

  searchRestaurant({String restaurant}) {
    searchRestaurantValue(restaurant);
    searchRestaurants.call().where((element) => element.name.toLowerCase().contains(restaurant.trim().toLowerCase()) || element.category.toLowerCase().contains(restaurant.trim().toLowerCase()));
    restaurantErrorMessage(tr('noRestaurants'));
  }

  searchMart({String mart}) {
    searchMartValue(mart);
    searchMarts.call().where((element) => element.name.toLowerCase().contains(mart.trim().toLowerCase()) || element.category.toLowerCase().contains(mart.trim().toLowerCase()));
    martErrorMessage(tr('noShops'));
  }
}