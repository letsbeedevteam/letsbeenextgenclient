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

          if (_box.hasData(Config.IS_VERIFY_NUMBER)) {
           
            if (_box.read(Config.IS_VERIFY_NUMBER)) {

              if (_box.hasData(Config.IS_SETUP_LOCATION)) {

                Get.offNamedUntil(_box.read(Config.IS_SETUP_LOCATION) ? Config.DASHBOARD_ROUTE : Config.SETUP_LOCATION_ROUTE, (route) => false); 
                
              } else {

                Get.offNamedUntil(Config.SETUP_LOCATION_ROUTE, (route) => false);
              }

            } else {
              Get.offNamedUntil(Config.VERIFY_NUMBER_ROUTE, (route) => false);
            }

          } else {
            Get.offNamedUntil(Config.VERIFY_NUMBER_ROUTE, (route) => false);
          }

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