import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as lct;
import 'package:geocoder/geocoder.dart';

class SetupLocationController extends GetxController {

  final GetStorage box = Get.find();

  lct.Location location;

  var userCurrentAddress = 'Getting your address...'.obs;

  var hasLocation = false.obs;

  @override
  void onInit() {
    _locationPermission();
    super.onInit();
  }

  void _locationPermission() async {
    Map<Permission, PermissionStatus> statuses = await [Permission.location].request();
    var status = statuses[Permission.locationAlways];
    if (status == PermissionStatus.denied) {
      _locationPermission();
    } else {
      _gpsEnable();
    }
  }

  void _gpsEnable() async {
    location = lct.Location();
    bool statusResult = await location.requestService();
    if (!statusResult) {
      _gpsEnable();
    } else {
      _getCurrentLocation();
    }
  }

  void _getCurrentLocation() async {
    var currentLocation = await location.getLocation();

    box.write(Config.USER_CURRENT_LATITUDE, currentLocation.latitude);
    box.write(Config.USER_CURRENT_LONGITUDE, currentLocation.longitude);
    await Geocoder.local.findAddressesFromCoordinates(Coordinates(currentLocation.latitude, currentLocation.longitude)).then((value) {
      userCurrentAddress.value = value.first.addressLine;
      hasLocation.value = true;

      box.write(Config.USER_CURRENT_STREET, value.first.featureName);
      box.write(Config.USER_CURRENT_COUNTRY, value.first.countryName);
      box.write(Config.USER_CURRENT_STATE, value.first.adminArea);
      box.write(Config.USER_CURRENT_CITY, value.first.locality);
      box.write(Config.USER_CURRENT_IS_CODE, value.first.countryCode);
      box.write(Config.USER_CURRENT_BARANGAY, value.first.subLocality);
      box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.value);
      box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.value);

    }).catchError((onError) {
      hasLocation.value = false;
      userCurrentAddress.value = 'Getting your address...';
      _getCurrentLocation();
    });
    update();
  }

  void goToVerifyNumberPage() {
    box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.value);
    Get.toNamed(Config.VERIFY_NUMBER_ROUTE);
  }
}