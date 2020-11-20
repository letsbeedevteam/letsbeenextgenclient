import 'package:get/get.dart';
import 'package:letsbeeclient/binds/auth_bind.dart';
import 'package:letsbeeclient/binds/dashboard_bind.dart';
import 'package:letsbeeclient/binds/map_bind.dart';
import 'package:letsbeeclient/binds/setup_location_bind.dart';
import 'package:letsbeeclient/binds/splash_bind.dart';
import 'package:letsbeeclient/screens/auth_view.dart';
import 'package:letsbeeclient/screens/confirm_code_view.dart';
import 'package:letsbeeclient/screens/dashboard_view.dart';
import 'package:letsbeeclient/screens/map_view.dart';
import 'package:letsbeeclient/screens/location_view.dart';
import 'package:letsbeeclient/screens/signup_confirmation_view.dart';
import 'package:letsbeeclient/screens/signup_view.dart';
import 'package:letsbeeclient/screens/splash_view.dart';
import 'package:letsbeeclient/screens/verify_number_view.dart';
import 'package:letsbeeclient/_utils/config.dart';

routes() => [
  GetPage(name: Config.SPLASH_ROUTE, page: () =>  SplashPage(), binding: SplashBind()),
  GetPage(name: Config.AUTH_ROUTE, page: () => AuthPage(), binding: AuthBind()),
  GetPage(name: Config.SIGNUP_ROUTE, page: () => SignUpPage()),
  GetPage(name: Config.SIGNUP_CONFIRMATION_ROUTE, page: () => SignUpConfirmationPage()),
  GetPage(name: Config.SETUP_LOCATION_ROUTE, page: () => SetupLocationPage(), binding: SetupLocationBind()),
  GetPage(name: Config.MAP_ROUTE, page: () => MapPage(), binding: MapBind()),
  GetPage(name: Config.VERIFY_NUMBER_ROUTE, page: () => VerifyNumberPage()),
  GetPage(name: Config.CONFIRM_CODE_ROUTE, page: () => ConfirmCodePage()),
  GetPage(name: Config.DASHBOARD_ROUTE, page: () => DashboardPage(), binding: DashboardBind()),
];