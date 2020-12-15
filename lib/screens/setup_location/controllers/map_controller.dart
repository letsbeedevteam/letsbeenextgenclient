import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:location/location.dart' as lct;

class MapController extends GetxController {

  final GetStorage _box = Get.find();

  final Completer<GoogleMapController> _mapController = Completer();

  var currentPosition = LatLng(0, 0).obs;

  var userCurrentAddress = 'Getting your address...'.obs;

  var isMapLoading = true.obs;

  var isBounced = false.obs;

  @override 
  void onInit() {
    currentPosition.value = LatLng(_box.read(Config.USER_CURRENT_LATITUDE), _box.read(Config.USER_CURRENT_LONGITUDE));
    super.onInit();
  }

  void gpsLocation() async {
    isBounced(true);
    final currentLocation = await lct.Location().getLocation();
    final c = await _mapController.future;
    c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(currentLocation.latitude, currentLocation.longitude), zoom: 18)));
    isBounced(false);
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
    if (currentPosition.call() != null) {
      Future.delayed(Duration(seconds: 2)).then((value) => isMapLoading(false));
    }
  }

  void _updateCurrentPosition(double latitude, double longitude) async {
    currentPosition(LatLng(latitude, longitude));
  }

  void onCameraMovePosition(CameraPosition position) {
    isBounced(true);
    currentPosition(LatLng(position.target.latitude, position.target.longitude));
    _updateCurrentPosition(currentPosition.value.latitude, currentPosition.value.longitude);
  }

  void getCurrentAddress() async {
    isBounced(false);
    await Geocoder.local.findAddressesFromCoordinates(Coordinates(currentPosition.value.latitude, currentPosition.value.longitude)).then((value) {
      userCurrentAddress(value.first.addressLine);

      _box.write(Config.USER_CURRENT_STREET, value.first.featureName);
      _box.write(Config.USER_CURRENT_COUNTRY, value.first.countryName);
      _box.write(Config.USER_CURRENT_STATE, value.first.adminArea);
      _box.write(Config.USER_CURRENT_CITY, value.first.locality);
      _box.write(Config.USER_CURRENT_IS_CODE, value.first.countryCode);
      _box.write(Config.USER_CURRENT_BARANGAY, value.first.subLocality);
      _box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.value);
      
    }).catchError((onError) {
      print('getCurrentAddress: $onError');
    });
  }
}