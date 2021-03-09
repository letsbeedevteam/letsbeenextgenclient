import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';

class SplashController extends GetxController {

  final GetStorage _box = Get.find();

  @override
  void onInit() {
    Future.delayed(Duration(seconds: 3)).then((_) {
      if(_box.hasData(Config.IS_LOGGED_IN)) {

        if(_box.read(Config.IS_LOGGED_IN)) {

          Get.offNamedUntil(Config.DASHBOARD_ROUTE, (route) => false); 

        } else {
          Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
        }

      } else {
        Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
      }
    });
    super.onInit();
  }
}