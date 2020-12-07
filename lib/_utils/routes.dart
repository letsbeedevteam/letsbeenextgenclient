import 'package:get/get.dart';
import 'package:letsbeeclient/binds/auth_bind.dart';
import 'package:letsbeeclient/binds/cart_bind.dart';
import 'package:letsbeeclient/binds/dashboard_bind.dart';
import 'package:letsbeeclient/binds/map_bind.dart';
import 'package:letsbeeclient/binds/menu_bind.dart';
import 'package:letsbeeclient/binds/restaurant_bind.dart';
import 'package:letsbeeclient/binds/setup_location_bind.dart';
import 'package:letsbeeclient/binds/signup_bind.dart';
import 'package:letsbeeclient/binds/splash_bind.dart';
import 'package:letsbeeclient/binds/verify_number_bind.dart';
import 'package:letsbeeclient/binds/webview_bind.dart';
import 'package:letsbeeclient/screens/auth/auth_view.dart';
import 'package:letsbeeclient/screens/cart/cart_view.dart';
import 'package:letsbeeclient/screens/dashboard/dashboard_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/reviews/review_detail_view.dart';
import 'package:letsbeeclient/screens/menu/menu_view.dart';
import 'package:letsbeeclient/screens/restaurant/restaurant_view.dart';
import 'package:letsbeeclient/screens/setup_location/location_view.dart';
import 'package:letsbeeclient/screens/setup_location/map_view.dart';
import 'package:letsbeeclient/screens/signup/tab_signup_view.dart';
import 'package:letsbeeclient/screens/splash/splash_view.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/verify_number/tab_verify_number_view.dart';
import 'package:letsbeeclient/screens/webview/web_view.dart';

routes() => [
  GetPage(name: Config.SPLASH_ROUTE, page: () =>  SplashPage(), binding: SplashBind()),
  GetPage(name: Config.AUTH_ROUTE, page: () => AuthPage(), binding: AuthBind()),
  GetPage(name: Config.SIGNUP_ROUTE, page: () => SignUpPage(), binding: SignUpBind()),
  GetPage(name: Config.SETUP_LOCATION_ROUTE, page: () => SetupLocationPage(), binding: SetupLocationBind()),
  GetPage(name: Config.MAP_ROUTE, page: () => MapPage(), binding: MapBind()),
  GetPage(name: Config.VERIFY_NUMBER_ROUTE, page: () => VerifyNumberPage(), binding: VerifyNumberBind()),
  GetPage(name: Config.DASHBOARD_ROUTE, page: () => DashboardPage(), binding: DashboardBind()),
  GetPage(name: Config.CART_ROUTE, page: () => CartPage(), binding: CartBind()),
  GetPage(name: Config.RESTAURANT_ROUTE, page: () => RestaurantPage(), binding: RestaurantBind()),
  GetPage(name: Config.MENU_ROUTE, page: () => MenuPage(), binding: MenuBind()),
  GetPage(name: Config.REVIEW_DETAIL_ROUTE, page: () => ReviewDetailPage()),
  GetPage(name: Config.WEBVIEW_ROUTE, page: () => WebViewPage(), binding: WebViewBind())
];