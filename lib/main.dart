import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:letsbeeclient/binds/splash_bind.dart';
import 'package:letsbeeclient/services/api_service.dart';
import 'package:letsbeeclient/services/auth_service.dart';
import 'package:letsbeeclient/services/push_notification_service.dart';
import 'package:letsbeeclient/services/socket_service.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/routes.dart';
import 'package:letsbeeclient/_utils/secrets.dart';
import 'generated/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();

  runApp(
    EasyLocalization(
      path: Config.TRANSLATION_PATH,
      supportedLocales: [Locale('ko', 'KR'), Locale('en', 'US')],
      fallbackLocale: Locale('en', 'US'),
      assetLoader: CodegenLoader(),
      child: MyApp(),
    )
  );
}

Future initServices() async {
  print('Starting services...');
  await Get.putAsync<SecretLoader>(() async {
    final secretLoad = SecretLoader(jsonPath: Config.JSONS_PATH + 'secrets.json');
    final load = await secretLoad.loadKey();
    KakaoContext.clientId = load.nativeAppKey;
    return secretLoad;
  });
  await Get.putAsync<GoogleSignIn>(() async => GoogleSignIn());
  await Get.putAsync<FacebookLogin>(() async => FacebookLogin());
  await Get.putAsync(() => GetStorage.init(Config.LETSBEE_STORAGE));
  await Get.putAsync<GetStorage>(() async => GetStorage());
  await Get.putAsync<PushNotificationService>(() async => PushNotificationService());
  await Get.putAsync<ApiService>(() async => ApiService());
  await Get.putAsync<AuthService>(() async => AuthService());
  await Get.putAsync<SocketService>(() async => SocketService());
  print('All services started...');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: Config.LETS_BEE,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          brightness: Brightness.light
        ),
        backgroundColor: Color(Config.WHITE),
        scaffoldBackgroundColor: Color(Config.WHITE),
        primaryColor: Color(Config.LETSBEE_COLOR),
        primarySwatch: Colors.yellow
      ),
      enableLog: true,
      debugShowCheckedModeBanner: false,
      getPages: routes(),
      transitionDuration: Duration(milliseconds: 300),
      defaultTransition: Transition.topLevel,
      initialBinding: SplashBind(),
      initialRoute: Config.SPLASH_ROUTE,
    );
  }
}
