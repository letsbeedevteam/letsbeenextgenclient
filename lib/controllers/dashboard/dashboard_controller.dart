import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letsbeeclient/screens/tabs/account_view.dart';
import 'package:letsbeeclient/screens/tabs/home_view.dart';
import 'package:letsbeeclient/screens/tabs/order_view.dart';
import 'package:letsbeeclient/screens/tabs/search_view.dart';
import 'package:letsbeeclient/services/socket_service.dart';
import 'package:letsbeeclient/_utils/config.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.find();

  final GetStorage box = Get.find();

  final SocketService _socketService = Get.find();

  final GoogleSignIn _googleSignIn = Get.find();

  final FacebookLogin _facebookLogin = Get.find();

  var widgets;
  var pageIndex = 0.obs;

  var userCurrentAddress = ''.obs;

  @override
  void onInit() {

    var socialType = box.read(Config.SOCIAL_LOGIN_TYPE);
    var token = box.read(Config.USER_TOKEN);
    print('$socialType: $token');

    widgets = [HomePage(), SearchPage(), OrderPage(), AccountPage()];
    _socketService.createSocketConnection();

    userCurrentAddress.value = box.read(Config.USER_CURRENT_ADDRESS);

    super.onInit();
  }

  void sendData() {
    _socketService.sendData();
  }

  void tapped(int tappedIndex) {
    pageIndex.value = tappedIndex;
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
      default: _kakaoSignOut();
    }
    _socketService.disconnectSocket();
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
}