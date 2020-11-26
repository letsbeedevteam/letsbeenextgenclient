import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:letsbeeclient/binds/splash_bind.dart';
import 'package:letsbeeclient/screens/splash/splash_view.dart';
import 'package:letsbeeclient/services/auth_service.dart';
import 'package:letsbeeclient/services/socket_service.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/routes.dart';
import 'package:letsbeeclient/_utils/secrets.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(MyApp());
}

Future initServices() async {
  print('Starting services...');
  await Get.putAsync<IO.Socket>(() async {
     final socket = IO.io(Config.BASE_URL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    return socket;
  });
  await Get.putAsync<SecretLoader>(() async => SecretLoader(jsonPath: Config.JSONS_PATH + 'secrets.json'));
  await Get.putAsync(() async {
    final secretLoad = await Get.find<SecretLoader>().loadKey();
    KakaoContext.clientId = secretLoad.nativeAppKey;
  });
  await Get.putAsync<GoogleSignIn>(() async => GoogleSignIn());
  await Get.putAsync<FacebookLogin>(() async => FacebookLogin());
  await Get.putAsync(() => GetStorage.init(Config.LETSBEE_STORAGE));
  await Get.putAsync<GetStorage>(() async => GetStorage());
  await Get.putAsync<AuthService>(() async => AuthService());
  await Get.putAsync<SocketService>(() async => SocketService());
  print('All services started...');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Config.LETS_BEE,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          brightness: Brightness.light
        ),
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.yellow,
      ),
      enableLog: true,
      debugShowCheckedModeBanner: false,
      getPages: routes(),
      transitionDuration: Duration(milliseconds: 500),
      defaultTransition: Transition.fade,
      initialBinding: SplashBind(),
      home: SplashPage(),
    );
  }
}
