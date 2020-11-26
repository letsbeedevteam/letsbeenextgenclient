import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/account_settings_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/home_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/notification_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/order/order_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/reviews/reviews_view.dart';
import 'package:letsbeeclient/_utils/config.dart';

class DashboardController extends GetxController with SingleGetTickerProviderMixin {
  
  TabController tabController;

  AnimationController animationController;

  PageController pageController;

  Animation<Offset> offsetAnimation;

  static DashboardController get to => Get.find();

  final GetStorage box = Get.find();

  final GoogleSignIn _googleSignIn = Get.find();

  final FacebookLogin _facebookLogin = Get.find();

  final widgets = [HomePage(), NotificationPage(), AccountSettingsPage(), ReviewsPage(), OrderPage()];

  var pageIndex = 0.obs;

  var userCurrentAddress = ''.obs;

  var isHideAppBar = false.obs;

  @override
  void onInit() {

    animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this
    );

    offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticInOut,
    ));

    tabController = TabController(length: 2, vsync: this)..addListener(() {
      tabController.index == 0 ?  animationController.reverse() :  animationController.forward();
    });

    pageController = PageController();

    userCurrentAddress.value = box.read(Config.USER_CURRENT_ADDRESS);
    super.onInit();
  }

  void tapped(int tappedIndex) {

    tappedIndex == 0 ? isHideAppBar.value = false : isHideAppBar.value = true; 
    pageIndex.value = tappedIndex;
    pageController.animateToPage(pageIndex.value, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
    update(['pageIndex']);
  }

  void signOut() {
   switch (box.read(Config.SOCIAL_LOGIN_TYPE)) {
      case Config.GOOGLE: _googleSignOut();
      break;
      case Config.FACEBOOK: _facebookSignOut();
      break;
      case Config.APPLE: _appleSignOut();
      break;
      case Config.KAKAO: _kakaoSignOut();
      break;
      default: _emailSignOut();
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

  void _kakaoSignOut() {
    box.write(Config.IS_LOGGED_IN, false);
    box.write(Config.IS_SETUP_LOCATION, false);
    box.remove(Config.USER_TOKEN);
    Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
  }

  void _appleSignOut() async {
    box.write(Config.IS_LOGGED_IN, false);
    box.write(Config.IS_SETUP_LOCATION, false);
    box.remove(Config.USER_TOKEN);
    Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
  }

  void _emailSignOut() async {
    box.write(Config.IS_LOGGED_IN, false);
    box.write(Config.IS_SETUP_LOCATION, false);
    box.remove(Config.USER_TOKEN);
    Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
  }
}