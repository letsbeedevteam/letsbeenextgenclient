import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/secrets.dart';
import 'package:location/location.dart' as lct;
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class MapController extends GetxController {

  final GetStorage _box = Get.find();
  final SecretLoader _secretLoader = Get.find();
  final Completer<GoogleMapController> _mapController = Completer();
  
  var currentPosition = LatLng(0, 0).obs;
  var userCurrentAddress = 'Getting your address...'.obs;
  var isMapLoading = true.obs;
  var isBounced = false.obs;

  GoogleMapsPlaces _places;

  @override 
  void onInit() {
    setup();
    currentPosition(LatLng(_box.read(Config.USER_CURRENT_LATITUDE), _box.read(Config.USER_CURRENT_LONGITUDE)));
    super.onInit();
  }

  void setup() async {
    final secretLoad = await _secretLoader.loadKey();
    _places = GoogleMapsPlaces(apiKey: secretLoad.googleMapKey);
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

  void onCameraMovePosition(CameraPosition position) {
    isBounced(true);
    currentPosition(LatLng(position.target.latitude, position.target.longitude));
  }

  void getCurrentAddress() async {
    isBounced(false);

    _box.write(Config.USER_CURRENT_LATITUDE, currentPosition.call().latitude);
    _box.write(Config.USER_CURRENT_LONGITUDE, currentPosition.call().longitude);

    await Geocoder.local.findAddressesFromCoordinates(Coordinates(currentPosition.call().latitude, currentPosition.call().longitude)).then((response) {
      userCurrentAddress(response.first.addressLine);

      _box.write(Config.USER_CURRENT_STREET, response.first.featureName);
      _box.write(Config.USER_CURRENT_COUNTRY, response.first.countryName);
      _box.write(Config.USER_CURRENT_STATE, response.first.adminArea);
      _box.write(Config.USER_CURRENT_CITY, response.first.locality);
      _box.write(Config.USER_CURRENT_IS_CODE, response.first.countryCode);
      _box.write(Config.USER_CURRENT_BARANGAY, response.first.subLocality);
      _box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.call());
      
    }).catchError((onError) {
      getCurrentAddress();
      print('getCurrentAddress: $onError');
    });
  }

  Future<void> handleSearchLocation() async {
    final secretLoad = await _secretLoader.loadKey();

    final prediction = await PlacesAutocomplete.show(
      context: Get.context,
      apiKey: secretLoad.googleMapKey,
      onError: onError,
      mode: Mode.overlay,
      language: 'en',
      overlayBorderRadius: BorderRadius.all(Radius.circular(10)),
      logo: Container(height: 30),
      hint: 'Search your location',
      components: [Component(Component.country, 'ph')],
    );
    
    displayPrediction(prediction);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      isBounced(true);
      final detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      final c = await _mapController.future;
      c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 18)));
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    print(response.errorMessage);
  }
}