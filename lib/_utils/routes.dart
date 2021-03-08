import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/binds/account_info_bind.dart';
import 'package:letsbeeclient/binds/address_bind.dart';
import 'package:letsbeeclient/binds/auth_bind.dart';
import 'package:letsbeeclient/binds/cart_bind.dart';
import 'package:letsbeeclient/binds/change_pass_bind.dart';
import 'package:letsbeeclient/binds/chat_bind.dart';
import 'package:letsbeeclient/binds/dashboard_bind.dart';
import 'package:letsbeeclient/binds/history_bind.dart';
import 'package:letsbeeclient/binds/history_detail_bind.dart';
import 'package:letsbeeclient/binds/map_bind.dart';
import 'package:letsbeeclient/binds/mart_bind.dart';
import 'package:letsbeeclient/binds/mart_cart_bind.dart';
import 'package:letsbeeclient/binds/restaurant_bind.dart';
import 'package:letsbeeclient/binds/rider_location_bind.dart';
import 'package:letsbeeclient/binds/signup_bind.dart';
import 'package:letsbeeclient/binds/splash_bind.dart';
import 'package:letsbeeclient/binds/user_details_bind.dart';
import 'package:letsbeeclient/binds/verify_number_bind.dart';
import 'package:letsbeeclient/binds/webview_bind.dart';
import 'package:letsbeeclient/screens/account_info/account_info_view.dart';
import 'package:letsbeeclient/screens/active_orders/active_on_going_view.dart';
import 'package:letsbeeclient/screens/address/address_view.dart';
import 'package:letsbeeclient/screens/auth/signUp/signup_view.dart';
import 'package:letsbeeclient/screens/auth/social/auth_view.dart';
import 'package:letsbeeclient/screens/change_password/change_password_view.dart';
import 'package:letsbeeclient/screens/chat/chat_view.dart';
import 'package:letsbeeclient/screens/dashboard/dashboard_view.dart';
import 'package:letsbeeclient/screens/food/cart/cart_view.dart';
import 'package:letsbeeclient/screens/food/restaurant/restaurant_view.dart';
import 'package:letsbeeclient/screens/grocery/mart/mart_product_view.dart';
import 'package:letsbeeclient/screens/grocery/mart_cart/mart_cart_view.dart';
import 'package:letsbeeclient/screens/history/historyDetail/history_detail_view.dart';
import 'package:letsbeeclient/screens/history/history_view.dart';
import 'package:letsbeeclient/screens/rider_location/rider_location_view.dart';
import 'package:letsbeeclient/screens/setup_location/map_view.dart';
import 'package:letsbeeclient/screens/splash/splash_view.dart';
import 'package:letsbeeclient/screens/user_details/user_details_view.dart';
import 'package:letsbeeclient/screens/verify_number/verify_number_view.dart';
import 'package:letsbeeclient/screens/webview/web_view.dart';

routes() => [
  GetPage(name: Config.SPLASH_ROUTE, page: () =>  SplashPage(), binding: SplashBind()),
  GetPage(name: Config.AUTH_ROUTE, page: () => AuthPage(), binding: AuthBind()),
  GetPage(name: Config.SIGNUP_ROUTE, page: () => SignUpPage(), binding: SignUpBind()),
  GetPage(name: Config.MAP_ROUTE, page: () => MapPage(), binding: MapBind()),
  GetPage(name: Config.VERIFY_NUMBER_ROUTE, page: () => VerifyNumberPage(), binding: VerifyNumberBind()),
  GetPage(name: Config.DASHBOARD_ROUTE, page: () => DashboardPage(), binding: DashboardBind()),
  GetPage(name: Config.CART_ROUTE, page: () => CartPage(), binding: CartBind()),
  GetPage(name: Config.RESTAURANT_ROUTE, page: () => RestaurantPage(), binding: RestaurantBind()),
  GetPage(name: Config.WEBVIEW_ROUTE, page: () => WebViewPage(), binding: WebViewBind()),
  GetPage(name: Config.CHAT_ROUTE, page: () => ChatPage(), binding: ChatBind()),
  GetPage(name: Config.RIDER_LOCATION_ROUTE, page: () => RiderLocationPage(), binding: RiderLocationBind()),
  GetPage(name: Config.HISTORY_ROUTE, page: () => HistoryPage(), binding: HistoryBind()),
  GetPage(name: Config.HISTORY_DETAIL_ROUTE, page: () => HistoryDetailPage(), binding: HistoryDetailBind()),
  GetPage(name: Config.ACTIVE_ORDER_ROUTE, page: () => ActiveOnGoingPage()),
  GetPage(name: Config.MART_ROUTE, page: () => MartProductPage(), binding: StoreBind()),
  GetPage(name: Config.MART_CART_ROUTE, page: () => MartCartPage(), binding: StoreCartBind()),
  GetPage(name: Config.ADDRESS_ROUTE, page: () => AddressPage(), binding: AddressBind()),
  GetPage(name: Config.USER_DETAILS_ROUTE, page: () => UserDetailsPage(), binding: UserDetailsBind()),
  GetPage(name: Config.ACCOUNT_INFO_ROUTE, page: () => AccountInfoPage(), binding: AccountInfoBind()),
  GetPage(name: Config.CHANGE_PASS_ROUTE, page: () => ChangePasswordPage(), binding: ChangePassBind()),
];