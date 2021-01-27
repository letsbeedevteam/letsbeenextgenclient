import 'package:flutter/material.dart';
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

  final streetTFController = TextEditingController();
  final barangayTFController = TextEditingController();
  final cityTFController = TextEditingController();

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

  void logout() {
    box.write(Config.IS_LOGGED_IN, false);
    box.write(Config.IS_VERIFY_NUMBER, false);
    Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
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

      streetTFController.text = response.first.featureName;
      barangayTFController.text = response.first.thoroughfare;
      cityTFController.text = response.first.locality;

      box.write(Config.USER_CURRENT_STREET, response.first.featureName);
      box.write(Config.USER_CURRENT_COUNTRY, response.first.countryName);
      box.write(Config.USER_CURRENT_STATE, response.first.adminArea);
      box.write(Config.USER_CURRENT_CITY, response.first.locality);
      box.write(Config.USER_CURRENT_IS_CODE, response.first.countryCode);
      box.write(Config.USER_CURRENT_BARANGAY, response.first.thoroughfare);
      box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.call());
      box.write(Config.USER_CURRENT_NAME_OF_LOCATION, 'Home');

    }).catchError((onError) {
      hasLocation(false);
      userCurrentAddress('Getting your address...');
      _getCurrentLocation();
      // Future.delayed(Duration(seconds: 3)).then((value) => _getCurrentLocation());
    });
  }

  void goToDashboardPage() {
    userCurrentAddress('${streetTFController.text}, ${barangayTFController.text}, ${cityTFController.text}');
    box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.call());
    box.write(Config.IS_SETUP_LOCATION, true);
    Get.offAllNamed(Config.DASHBOARD_ROUTE);
  }
}