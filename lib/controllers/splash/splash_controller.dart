import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';

class SplashController extends GetxController {

  final GetStorage _box = Get.find();

  @override
  void onInit() {
    Future.delayed(Duration(seconds: 8)).then((_) {
      if(_box.hasData(Config.IS_LOGGED_IN)) {

        if(_box.read(Config.IS_LOGGED_IN)) {
          
          if (_box.hasData(Config.IS_SETUP_LOCATION)) {
            
             Get.offAllNamed(_box.read(Config.IS_SETUP_LOCATION) ? Config.DASHBOARD_ROUTE : Config.SETUP_LOCATION_ROUTE); 
          
          } else {
            Get.offAllNamed(Config.SETUP_LOCATION_ROUTE);
          }

        } else {
          Get.offAllNamed(Config.AUTH_ROUTE);
        }

      } else {
        Get.offAllNamed(Config.AUTH_ROUTE);
      }
    });
    super.onInit();
  }
}