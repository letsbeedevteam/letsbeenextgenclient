import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/active_order_response.dart';
import 'package:letsbeeclient/models/chat_response.dart';
import 'package:letsbeeclient/models/get_address_response.dart';
import 'package:letsbeeclient/models/mart_dashboard_response.dart';
import 'package:letsbeeclient/models/restaurant_dashboard_response.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/search_history.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/services/api_service.dart';
import 'package:letsbeeclient/services/push_notification_service.dart';
import 'package:letsbeeclient/services/socket_service.dart';


class DashboardController extends GetxController with SingleGetTickerProviderMixin {
  
  PageController pageController;
  Completer<void> refreshCompleter;

  final ApiService apiService = Get.find();
  final PushNotificationService pushNotificationService = Get.find();
  final SocketService socketService = Get.find();
  final GetStorage box = Get.find();
  final GoogleSignIn _googleSignIn = Get.find();
  final FacebookLogin _facebookLogin = Get.find();
  
  final restaurantSearchController = TextEditingController().obs;
  final martSearchController = TextEditingController().obs;
  final reasonController = TextEditingController();

  final foodScrollController = ScrollController();
  final martScrollController = ScrollController();

  var isFloatVisible = false.obs;
  var isHideAppBar = false.obs;
  var isLoading = false.obs;
  var isCancelOrderLoading = false.obs;
  var isSearchLoading = false.obs;
  var isOnSearch = false.obs;
  var isSelectedLocation = false.obs;
  var isSigningOut = false.obs;

  var pageIndex = 0.obs;
  var userCurrentNameOfLocation = ''.obs;
  var userCurrentAddress = ''.obs;
  var onGoingMessage = ''.obs;
  var cancelMessage = ''.obs;
  var reason = ''.obs;

  var connectMessage = tr('connecting').obs;
  var isConnected = true.obs;
  var color = Colors.orange.obs;

  var restaurantErrorMessage = tr('loadingRestaurants').obs;
  var martErrorMessage = tr('loadingShops').obs;
  var searchRestaurantErrorMessage = tr('searching').obs;
  var searchMartErrorMessage = tr('searching').obs;

  var restaurants = RxList<RestaurantStores>().obs;
  var recentRestaurants = RxList<RestaurantStores>().obs;
  var searchRestaurants = RxList<RestaurantStores>().obs;

  var marts = RxList<MartStores>().obs;
  var recentMarts = RxList<MartStores>().obs;
  var searchMarts = RxList<MartStores>().obs;

  var activeOrderData = ActiveOrderData().obs;
  var activeOrders = ActiveOrder().obs;

  var searchHistoryList = RxMap<String, SearchHistory>().obs;

  var hasRestaurantError = false.obs;
  var hasMartError = false.obs;

  var isDisableDeliveryPushNotif = false.obs;
  var isDisablePromotionalPushNotif = false.obs;

  var countRestoPage = 0.obs;
  var isRestaurantLoadingScroll = true.obs;
  var isSearchRestaurantLoading = false.obs;
  var searchRestaurantValue = ''.obs;
  
  var countMartPage = 0.obs;
  var isMartLoadingScroll = true.obs;
  var isSearchMartLoading = false.obs;
  var searchMartValue = ''.obs;

  var language = ''.obs;

  var cart = Config.RESTAURANT.obs;
  var products = RxList<Product>().obs;

  static DashboardController get to => Get.find();

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
    setupTabs();
    refreshToken(page: 0);
    updateCart();

    if (box.hasData(Config.LANGUAGE))language(box.read(Config.LANGUAGE)); else language('EN');
    
    foodScrollController.addListener(() {
      if (foodScrollController.position.atEdge) {
        if (foodScrollController.position.pixels != 0) {
          if (!isOnSearch.call()) fetchRestaurantDashboard(page: countRestoPage.call());
        } 
      }
    });

    martScrollController.addListener(() {
      if (martScrollController.position.atEdge) {
        if (martScrollController.position.pixels != 0) {
          if (!isOnSearch.call()) fetchMartDashboard(page: countMartPage.call());
        }
      }
    });

    if(box.hasData(Config.SEARCH_HISTORY)) {
      searchHistoryFromJson(box.read(Config.SEARCH_HISTORY)).forEach((data) {
        searchHistoryList.value[data.name] = data;
      });
    }

    super.onInit();
  }
  
  refreshSocket() {

    socketService.socket?.on('connect', (_) {
      socketService.socket?.clearListeners();
      isConnected(true);
      color(Colors.green);
      connectMessage(tr('connected'));
      print('Connected');
      fetchActiveOrders();
      receiveUpdateOrder();
      receiveChat();
    });
    socketService.socket?.on('connecting', (_) {
      isConnected(false);
      color(Colors.orange);
      connectMessage(tr('connecting'));
      print('Connecting');
      onGoingMessage(tr('loading'));
    });
    socketService.socket?.on('reconnecting', (_) {
      isConnected(false);
      color(Colors.orange);
      connectMessage(tr('reconnecting'));
      print('Reconnecting');
      onGoingMessage(tr('loading'));
    });
    socketService.socket?.on('disconnect', (_) {
      isConnected(false);
      color(Colors.orange);
      connectMessage(tr('reconnecting'));
      onGoingMessage(tr('loading'));
      print('Disconnected');
    });
    socketService.socket?.on('error', (_) {
      onGoingMessage(tr('loading'));
      print('Error socket: $_');
    });
  }

  void changeLanguage(String lang) {
    language(lang);
    box.write(Config.LANGUAGE, lang);
    Get.context.locale = lang == 'EN' ? Locale('en', 'US') : Locale('ko', 'KR');
    Get.back();
    update();
  } 

  void setupRefreshIndicator() {
    refreshCompleter = Completer();
  }

  void setupTabs() {
    pageController = PageController();

    pageController.addListener(() {
      if (pageController.page == 0.0 || pageController.page == 1.0) isOnSearch(false);
    });
  }

  void tapped(int tappedIndex) {
    if (tappedIndex == 0) {
      cart(Config.RESTAURANT);
      if (foodScrollController.hasClients) foodScrollController.animateTo(1, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    } else if (tappedIndex == 1) {
      cart(Config.MART);
      if (martScrollController.hasClients) martScrollController.animateTo(1, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    }
    isOnSearch(false);
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
    restaurants.call().clear();
    marts.call().clear();
    activeOrders.nil();
    searchRestaurants.call().clear();
    searchMarts.call().clear();
   
    box.remove(Config.USER_TOKEN);
    box.remove(Config.USER_ADDRESS_ID);
    box.remove(Config.USER_ID);
    box.remove(Config.USER_CURRENT_LATITUDE);
    box.remove(Config.USER_CURRENT_LONGITUDE);
    box.remove(Config.USER_CURRENT_ADDRESS);
    box.remove(Config.USER_CURRENT_NAME_OF_LOCATION);
    box.remove(Config.IS_LOGGED_IN);
    box.remove(Config.SEARCH_HISTORY);
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
    isSigningOut(true);
    await _facebookLogin.logOut().then((data) {
      Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false).whenComplete(() => isSigningOut(false));
    });
  }

  void _googleSignOut() async {
    isSigningOut(true);
    await _googleSignIn.disconnect().then((data) {
      Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false).whenComplete(() => isSigningOut(false));
    });
  }

  void _signOut() {
    isSigningOut(true);
    Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false).whenComplete(() => isSigningOut(false));
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
      if (activeOrders.call().status == Config.OK) {
        onGoingMessage(tr('noActiveOrder'));
        if (activeOrders.call().data.isEmpty) {
          activeOrders.nil();
        } else {
          activeOrders(ActiveOrder.fromJson(response));
          activeOrders.call().data.sort((b, a) => a.id.compareTo(b.id));
        }
      } else {
        activeOrders.nil();
        onGoingMessage(tr('somethingWentWrong'));
      }
    });
  }

  receiveUpdateOrder() {
    socketService.socket?.on('order', (response) {
      'Receive update: $response'.printWrapped();
      fetchActiveOrders();
      String message;
      if (response['status'] == Config.OK) {
        
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

            if(Get.currentRoute == Config.DASHBOARD_ROUTE) {
              if (Get.isDialogOpen) Get.back();
              Get.defaultDialog(
                title: tr('oops'),
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
            }
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

            // if (Get.currentRoute == Config.ACTIVE_ORDER_ROUTE) Get.back(closeOverlays: true);

            if(Get.currentRoute == Config.DASHBOARD_ROUTE) {
              if (Get.isDialogOpen) Get.back();
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
            }

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
          errorSnackbarTop(title: tr('oops'), message: tr('specifyYourReason'));
        } else {
          cancelOrderRequest();
        }

      } else {
        cancelOrderRequest();
      }

    } else {
      errorSnackbarTop(title: tr('oops'), message: tr('selectReason'));
    }
  }

  cancelOrderRequest() {
    isCancelOrderLoading(true);
    
    apiService.cancelOrder(orderId: activeOrderData.value.id, note: reasonController.text.trim()).then((response) {
      if(response.status == Config.OK) {
        reasonController.clear();
        reason.nil();
        activeOrderData.nil();
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
      } else {

        if (response.status == Config.INVALID) {
          errorSnackbarTop(title: tr('oops'), message: tr('orderHasBeenDeclined'));
        } else {
          errorSnackbarTop(title: tr('oops'), message: tr('somethingWentWrong'));
        }
      }

      isCancelOrderLoading(false);

    }).catchError((onError) {
      isCancelOrderLoading(false);
      errorSnackbarTop(title: 'Oops', message: tr('somethingWentWrong'));
      print('Error cancel order: $onError');
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
    apiService.refreshToken().then((response) {
      _setRefreshCompleter();
      if(response.status == Config.OK) {

        box.write(Config.USER_TOKEN, response.data.accessToken);

        if (socketService.socket == null) {
          socketService.connectSocket(box.read(Config.USER_TOKEN));
        } else {
          socketService.reconnectSocket(response.data.accessToken);
        }

        refreshSocket();
        fetchRestaurantDashboard(page: page);
        fetchMartDashboard(page: page);

      } else if (response.status == Config.UNAUTHORIZED) {
        
        print('SESSION EXPIRED!');

      } else {
        restaurantErrorMessage(tr('somethingWentWrong'));
        martErrorMessage(tr('somethingWentWrong'));
        box.remove(Config.PRODUCTS);
      }
      
    }).catchError((onError) {
      isLoading(false);
      _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) {
        // message(Config.NO_INTERNET_CONNECTION);
        restaurantErrorMessage(tr('noInternetConnection'));
        martErrorMessage(tr('noInternetConnection'));
      } else if (onError.toString().contains('Operation timed out')) {
        // message(Config.TIMED_OUT);
        restaurantErrorMessage(tr('timedOut'));
        martErrorMessage(tr('timedOut'));
      } else {
        restaurantErrorMessage(tr('somethingWentWrong'));
        martErrorMessage(tr('somethingWentWrong'));
        box.remove(Config.PRODUCTS);
      }
      hasMartError(true);
      hasRestaurantError(true);
      print('Refresh token: $onError');
    });
  }

  fetchRestaurantDashboard({@required int page}) {
    restaurantErrorMessage(tr('loadingRestaurants'));
    isLoading(true);
    isRestaurantLoadingScroll(true);
    hasRestaurantError(false);
    apiService.getRestaurantDashboard(page: page).then((response) {
      isLoading(false);
      isSelectedLocation(false);
      hasRestaurantError(false);
      _setRefreshCompleter();
      if (response.status == Config.OK) {

        if(response.data.recentStores.isNotEmpty) {
          final Map<int, RestaurantStores> newMap = Map();
          response.data.recentStores.forEach((item) {
            newMap[item.id] = item;
          });
          recentRestaurants.call()..clear()..assignAll(newMap.values.toList());
        }

        if (page == 0) {
          countRestoPage(1);
          restaurants.call()..clear()..assignAll(response.data.stores);
          isRestaurantLoadingScroll(false);
        } else {

          if (response.data.stores.isNotEmpty) {
            countRestoPage.value++;
            restaurants.call().addAll(response.data.stores);
          } else {
            isRestaurantLoadingScroll(false);
            print('No restaurant store at page $page');
          }
        }

        if(restaurants.call().isEmpty) {
          recentRestaurants.call().clear();
          hasRestaurantError(true);
          restaurantErrorMessage(tr('noRestaurants'));
        }
        
      } else {
        isRestaurantLoadingScroll(false);
        restaurantErrorMessage(tr('somethingWentWrong'));
      }
      
    }).catchError((onError) {
      isRestaurantLoadingScroll(false);
      hasRestaurantError(true);
      isLoading(false);
      isSelectedLocation(false);
      _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) {
        restaurantErrorMessage(tr('noInternetConnection'));
      } else if (onError.toString().contains('Operation timed out')) {
        restaurantErrorMessage(tr('timedOut'));
      } else {
        restaurantErrorMessage(tr('somethingWentWrong'));
      }
      print('Error fetch restaurant: $onError');
    });
  }

  fetchMartDashboard({@required int page}) {
    martErrorMessage(tr('loadingShops'));
    isLoading(true);
    isMartLoadingScroll(true);
    hasMartError(false);
    apiService.getMartDashboard(page: page).then((response) {
      isLoading(false);
      isSelectedLocation(false);
      hasMartError(false);
      _setRefreshCompleter();
      if (response.status == Config.OK) {

        if (response.data.recentStores.isNotEmpty) {
          final Map<int, MartStores> newMap = Map();
          response.data.recentStores.forEach((item) {
            newMap[item.id] = item;
          });
          recentMarts.call()..clear()..assignAll(newMap.values.toList());
        }

        if (page == 0) {
          countMartPage(1);
          marts.call()..clear()..assignAll(response.data.stores);
          isMartLoadingScroll(false);
        } else {

          if (response.data.stores.isNotEmpty) {
            countMartPage.value++;
            marts.call().addAll(response.data.stores);
          } else {
            isMartLoadingScroll(false);
            print('No mart store at page $page');
          }
        }

        if(marts.call().isEmpty) {
          marts.call().clear();
          hasMartError(true);
          martErrorMessage(tr('noShops'));
        }
      
      } else {
        isMartLoadingScroll(false);
        martErrorMessage(tr('somethingWentWrong'));
      }
      
    }).catchError((onError) {
      isMartLoadingScroll(false);
      hasMartError(true);
      isLoading(false);
      isSelectedLocation(false);
      _setRefreshCompleter();
      if (onError.toString().contains('Connection failed')) {
        martErrorMessage(tr('noInternetConnection'));
      } else if (onError.toString().contains('Operation timed out')) {
        martErrorMessage(tr('timedOut'));
      } else {
        martErrorMessage(tr('somethingWentWrong'));
      }
      print('Error fetch mart: $onError');
    });
  }

  fetchSearchRestaurant(String restaurant) {

    if (restaurant.trim().isEmpty) {
      errorSnackBarBottom(message: tr('inputSearchField'));
    } else {

      searchRestaurants.call().clear();
      searchRestaurantValue(restaurant);
      searchRestaurantErrorMessage(tr('loadingRestaurants'));
      isSearchRestaurantLoading(true);
      isOnSearch(true);
      hasRestaurantError(false);
      
      if (Get.isSnackbarOpen) {
        Get.back();
        Future.delayed(Duration(milliseconds: 300));
        Get.back();
      } else {
        Get.back();
      }
      
      restaurantSearchController.update((data) {
        data.text = restaurant;
      });

      apiService.searchRestaurant(name: restaurant.trim()).then((response) {
        _setRefreshCompleter();
        if (response.status == Config.OK) {
          
          if (response.data.isNotEmpty) {
            
           
            if (searchHistoryList.call().values.where((data) => data.type == Config.MART).length == 5) {
              final getLastIndex = searchHistoryList.call().values.lastWhere((data) => data.type == Config.MART);
              searchHistoryList.call().removeWhere((key, value) => value.type == Config.MART && value.name == getLastIndex.name);
            }

            searchRestaurants.call().assignAll(response.data);
            
            searchHistoryList.update((data) {
              data[restaurant.trim()] = SearchHistory(name: restaurant.trim(), date: DateTime.now(), type: Config.RESTAURANT);
            });

            box.write(Config.SEARCH_HISTORY, searchHistoryToJson(searchHistoryList.call().values.toList()));
          } else {
            searchRestaurants.call().clear();
            hasRestaurantError(true);
            searchRestaurantErrorMessage(tr('noRestaurants'));
          }

          isSearchRestaurantLoading(false);
        
        } else {
          hasRestaurantError(true);
          isSearchRestaurantLoading(false);
          searchRestaurantErrorMessage(tr('somethingWentWrong'));
        }

      }).catchError((onError) {
        _setRefreshCompleter();
        hasRestaurantError(true);
        isSearchRestaurantLoading(false);
        if (onError.toString().contains('Connection failed')) {
          searchRestaurantErrorMessage(tr('noInternetConnection'));
        } else if (onError.toString().contains('Operation timed out')) {
          searchRestaurantErrorMessage(tr('timedOut'));
        } else {
          searchRestaurantErrorMessage(tr('somethingWentWrong'));
        }
        print('Search restaurant error: $onError');
      });
    }
  }

  fetchSearchMart(String mart) {
    
    if (mart.trim().isEmpty) {
      errorSnackBarBottom(message: tr('inputSearchField'));
    } else {
      searchMarts.call().clear();
      searchMartValue(mart);
      searchMartErrorMessage(tr('loadingShops'));
      isSearchMartLoading(true);
      isOnSearch(true);
      hasMartError(false);

      if (Get.isSnackbarOpen) {
        Get.back();
        Future.delayed(Duration(milliseconds: 300));
        Get.back();
      } else {
        Get.back();
      }

      martSearchController.update((data) {
        data.text = mart;
      });

      apiService.searchMart(name: mart.trim()).then((response) {
        _setRefreshCompleter();
        if (response.status == Config.OK) {
          
          if (response.data.isNotEmpty) {
            
            
            if (searchHistoryList.call().values.where((data) => data.type == Config.MART).length == 5) {
              final getLastIndex = searchHistoryList.call().values.lastWhere((data) => data.type == Config.MART);
              searchHistoryList.call().removeWhere((key, value) => value.type == Config.MART && value.name == getLastIndex.name);
            }

            searchMarts.call().assignAll(response.data);

            searchHistoryList.update((data) {
              data[mart.trim()] = SearchHistory(name: mart.trim(), date:  DateTime.now(), type: Config.MART);
            });
            box.write(Config.SEARCH_HISTORY, searchHistoryToJson(searchHistoryList.call().values.toList()));
          } else {
            hasMartError(true);
            searchMartErrorMessage(tr('noShops'));
          }

          isSearchMartLoading(false);
        
        } else {
          hasMartError(true);
          isSearchMartLoading(false);
          searchMartErrorMessage(tr('somethingWentWrong'));
        }

      }).catchError((onError) {
        hasMartError(true);
        _setRefreshCompleter();
        isSearchMartLoading(false);
        if (onError.toString().contains('Connection failed')) {
          searchMartErrorMessage(tr('noInternetConnection'));
        } else if (onError.toString().contains('Operation timed out')) {
          searchMartErrorMessage(tr('timedOut'));
        } else {
          searchMartErrorMessage(tr('somethingWentWrong'));
        }
        print('Search mart error: $onError');
      });
    }
  }

  clearSearchHistory({@required String type}) {
    searchHistoryList.call().removeWhere((key, value) => value.type == type);
    box.write(Config.SEARCH_HISTORY, searchHistoryToJson(searchHistoryList.call().values.toList()));
    update();
  }

  updateCart() {
    if(box.hasData(Config.PRODUCTS)) {
      products.call().assignAll(listProductFromJson(box.read(Config.PRODUCTS)));
    } else {
      products.call().clear();
    }
  }
}