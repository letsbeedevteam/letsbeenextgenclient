import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/_utils/secrets.dart';
import 'package:letsbeeclient/models/newAddressRequest.dart';
import 'package:letsbeeclient/models/newAddressResponse.dart';
import 'package:letsbeeclient/screens/address/address_controller.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';
import 'package:location/location.dart' as lct;
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapController extends GetxController {

  final GetStorage _box = Get.find();
  final SecretLoader _secretLoader = Get.find();
  final ApiService _apiService = Get.find();
  final Completer<GoogleMapController> _mapController = Completer();
  final argument = Get.arguments;
  
  var isMapLoading = true.obs;
  var isBounced = false.obs;
  var isLoading = false.obs;
  var isAddAddressLoading = false.obs;
  var hasLocation = false.obs;
  var isKeyboardVisible = false.obs;

  var currentPosition = LatLng(0, 0).obs;
  var userCurrentAddress = 'Getting your address...'.obs;
  var mapStyle = ''.obs;

  final addressLabel = TextEditingController();
  final addressDetails = TextEditingController();
  final noteToRider = TextEditingController();

  final addressLabelNode = FocusNode();
  final noteToRiderNode = FocusNode();
  final addressDetailsNode = FocusNode();

  var buttonTitle = 'Next'.obs;

  GoogleMapsPlaces _places;
  StreamSubscription<NewAddressResponse> newAddressSub;

  @override 
  void onInit() {
    if (argument['type'] == Config.ADD_NEW_ADDRESS) {
      currentPosition(LatLng(_box.read(Config.USER_CURRENT_LATITUDE), _box.read(Config.USER_CURRENT_LONGITUDE)));
      buttonTitle('Save');
      isMapLoading(false);

    } else {
      buttonTitle('Next');
      isMapLoading(true);
      currentLocation();
    }
    setup();

    super.onInit();
  }

  void currentLocation() async {
    lct.Location().getLocation().then((data) {
      currentPosition(LatLng(data.latitude, data.longitude));
      isMapLoading(false);
    });
  }

  void goToDashboardPage() {

    if (noteToRider.text.isBlank || addressLabel.text.isBlank || addressDetails.text.isBlank) {
      errorSnackbarTop(title: 'Oops!', message: 'Please input the required field(s)');
    } else {
      userCurrentAddress(addressDetails.text.trim());
      addAddress();
    }
  }

  void setup() async {
    final secretLoad = await _secretLoader.loadKey();
    _places = GoogleMapsPlaces(apiKey: secretLoad.googleMapKey);
    rootBundle.loadString(Config.JSONS_PATH + 'map_style.json').then((string) {
      mapStyle(string);
    });
  }

  void gpsLocation() async {
    isBounced(true);
    final currentLocation = await lct.Location().getLocation();
    final c = await _mapController.future;
    currentPosition(LatLng(currentLocation.latitude, currentLocation.longitude));
    c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(currentLocation.latitude, currentLocation.longitude), zoom: 18)));
    isBounced(false);
  }

  void onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    final c = await _mapController.future;
    c.setMapStyle(mapStyle.call());
  }

  void onCameraMovePosition(CameraPosition position) {
    isBounced(true);
    currentPosition(LatLng(position.target.latitude, position.target.longitude));
  }

  void getCurrentAddress() async {
    isBounced(false);
    isLoading(true);

    if (argument['type'] != Config.ADD_NEW_ADDRESS) {
      _box.write(Config.USER_CURRENT_LATITUDE, currentPosition.call().latitude);
      _box.write(Config.USER_CURRENT_LONGITUDE, currentPosition.call().longitude);
    }

    await placemarkFromCoordinates(currentPosition.call().latitude, currentPosition.call().longitude).then((response) {
      isLoading(false);
      hasLocation(true);

      print(response.asMap());

      final street = response.first.street;
      final barangay = response.first.subLocality;
      final city = '${response.first.locality} ${response.first.administrativeArea}';

      print(response.first.name);

      userCurrentAddress('$street $barangay, $city'.trim());
      addressDetails.text = userCurrentAddress.call();
      
    }).catchError((onError) {
      // isLoading(false);
      hasLocation(false);
      getCurrentAddress();
      // Future.delayed(Duration(seconds: 3)).then((value) => getCurrentAddress());
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

  Future<bool> willPopCallback() async {
    argument['type'] == Config.ADD_NEW_ADDRESS ? Get.back(closeOverlays: true) : Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
    return true;
  }

  void addAddress() {
    dismissKeyboard(Get.context);

    isAddAddressLoading(true);
    final request = NewAddressRequest(
      name: this.addressLabel.text,
      location: AddressLocation(
        lat: this.currentPosition.call().latitude,
        lng: this.currentPosition.call().longitude
      ),
      address: this.addressDetails.text,
      note: this.noteToRider.text
    );

    newAddressSub = _apiService.addNewAddress(request).asStream().listen((response) {
      isAddAddressLoading(false);
      if(response.status == 200) {
        print('Success');
        userCurrentAddress(response.data.address.trim());
        _box.write(Config.USER_ADDRESS_ID, response.data.id);
        _box.write(Config.USER_CURRENT_LATITUDE, response.data.location.lat);
        _box.write(Config.USER_CURRENT_LONGITUDE,  response.data.location.lng);
        _box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.call());
        _box.write(Config.USER_CURRENT_NAME_OF_LOCATION, response.data.name);
        _box.write(Config.NOTE_TO_RIDER, response.data.note);
        
        if (argument['type'] == Config.ADD_NEW_ADDRESS) {

          DashboardController.to
          ..isSelectedLocation(true)
          ..userCurrentNameOfLocation(response.data.name)
          ..userCurrentAddress(this.userCurrentAddress.call().trim())
          ..fetchActiveOrders()
          ..fetchRestaurantDashboard();
          AddressController.to.refreshAddress();
          Get.back(closeOverlays: true);
        } else {
          _box.write(Config.IS_LOGGED_IN, true);
          Get.offAllNamed(Config.DASHBOARD_ROUTE);
        }

        
      } else {
        errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
        print('Failed to add new address');
      }

    });
    
    newAddressSub.onError((handleError) {
      isAddAddressLoading(false);
      errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
      print('Error add new address: $handleError');
    });
  }
}