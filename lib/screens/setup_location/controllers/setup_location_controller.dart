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

    await Geocoder.local.findAddressesFromCoordinates(Coordinates(currentLocation.latitude, currentLocation.longitude)).then((response) {
      response.forEach((element) {
        print(element.toMap());
      });
      userCurrentAddress(response.first.addressLine);
      hasLocation(true);

      box.write(Config.USER_CURRENT_STREET, response.first.featureName);
      box.write(Config.USER_CURRENT_COUNTRY, response.first.countryName);
      box.write(Config.USER_CURRENT_STATE, response.first.adminArea);
      box.write(Config.USER_CURRENT_CITY, response.first.locality);
      box.write(Config.USER_CURRENT_IS_CODE, response.first.countryCode);
      box.write(Config.USER_CURRENT_BARANGAY, response.first.subLocality);
      box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.call());

    }).catchError((onError) {
      hasLocation(false);
      userCurrentAddress('Getting your address...');
      _getCurrentLocation();
    });
  }

  void goToVerifyNumberPage() => Get.toNamed(Config.VERIFY_NUMBER_ROUTE);
}