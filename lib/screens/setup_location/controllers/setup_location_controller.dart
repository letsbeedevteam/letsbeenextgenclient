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
    }).catchError((onError) {
      userCurrentAddress.value = 'Getting your address...';
      _getCurrentLocation();
    });
  }

  void goToVerifyNumberPage() {
    box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.value);
    Get.toNamed(Config.VERIFY_NUMBER_ROUTE);
  }
}