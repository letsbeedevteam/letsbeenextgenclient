import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letsbeeclient/models/restaurant.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/account_settings_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/home_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/notification_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/order/order_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/reviews_view.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/services/api_service.dart';

class DashboardController extends GetxController with SingleGetTickerProviderMixin {
  
  TabController tabController;
  AnimationController animationController;
  PageController pageController;
  Animation<Offset> offsetAnimation;
  Completer<void> refreshCompleter;
  // GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  final ApiService apiService = Get.find();
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
  var restaurants = Restaurant().obs;
  var searchRestaurants = RxList<RestaurantElement>().obs;
  var recentRestaurants = RxList<dynamic>().obs;

  static DashboardController get to => Get.find();

  @override
  void onInit() {

    userCurrentAddress.value = box.read(Config.USER_CURRENT_ADDRESS);
 
    setupRefreshIndicator();
    setupAnimation();
    setupTabs();
    fetchRestaurants();
 
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
    this.isOpenLocationSheet.value = isOpenLocationSheet;
    update(['pageIndex']);
  }

  void tapped(int tappedIndex) {

    tappedIndex == 0 ? isHideAppBar.value = false : isHideAppBar.value = true; 
    pageIndex.value = tappedIndex;
    pageController.animateToPage(pageIndex.value, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
    update(['pageIndex']);
  }

  void updateCurrentLocation(String address) {
     userCurrentAddress.value = address;
     box.write(Config.USER_CURRENT_ADDRESS, address);
     showLocationSheet(false);
     update();
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

  fetchRestaurants() {

    isLoading.value = true;
   
    Future.delayed(Duration(seconds: 2)).then((value) {

      apiService.getAllRestaurants().then((restaurant) {
        isLoading.value = false;
        _setRefreshCompleter();
        if (restaurant.status == 200) {
          
          restaurants.value = restaurant;
          searchRestaurants.value..clear()..addAll(restaurant.data.restaurants);
          recentRestaurants.value..clear()..addAll(restaurant.data.recentOrders);

          if(searchRestaurants.value.isEmpty) message.value = 'No restaurant found';
        
        } else {
          message.value = Config.SOMETHING_WENT_WRONG;
        }
        update();
        
      }).catchError((onError) {
          isLoading.value = false;
          _setRefreshCompleter();
          if (onError.toString().contains('Connection failed')) message.value = Config.NO_INTERNET_CONNECTION; else message.value = Config.SOMETHING_WENT_WRONG;
          print('Error fetch restaurant: $onError');
          update();
      });

    });
  }

  searchRestaurant(String value) {
    
    isSearching.value = value.isNotEmpty;
    searchRestaurants.value.clear();
    if (isSearching.value) {
      
      var restaurant = restaurants.value.data.restaurants.where((element) => element.name.toLowerCase().contains(value.toLowerCase()));

      if (restaurant.isEmpty) {
        searchRestaurants.value.clear();
        message.value = 'No restaurant found';
      } else {
        searchRestaurants.value.addAll(restaurant);
      }
     
    } else {
      searchRestaurants.value.addAll(restaurants.value.data.restaurants);
    }
    update();
  } 
}