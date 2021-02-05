import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/_utils/secrets.dart';
import 'package:letsbeeclient/models/newAddressRequest.dart';
import 'package:letsbeeclient/models/newAddressResponse.dart';
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

  var currentPosition = LatLng(0, 0).obs;
  var userCurrentAddress = 'Getting your address...'.obs;
  var country = ''.obs;
  var state = ''.obs;
  var city = ''.obs;
  var barangay = ''.obs;
  var street = ''.obs;
  var isoCode = ''.obs;
  var mapStyle = ''.obs;

  final nameTF = TextEditingController();
  final streetTFController = TextEditingController();
  final barangayTFController = TextEditingController();
  final cityTFController = TextEditingController();

  final nameNode = FocusNode();
  final streetNode = FocusNode();
  final barangayNode = FocusNode();
  final cityNode = FocusNode();

  GoogleMapsPlaces _places;
  StreamSubscription<NewAddressResponse> newAddressSub;

  @override 
  void onInit() {
    setup();
    currentPosition(LatLng(_box.read(Config.USER_CURRENT_LATITUDE), _box.read(Config.USER_CURRENT_LONGITUDE)));
    super.onInit();
  }

  void goToDashboardPage() {

    if(argument['type'] == Config.ADD_NEW_ADDRESS) {
      if (nameTF.text.isBlank) {
        errorSnackbarTop(title: 'Oops!', message: 'Please input the required field');
      } else {
        if (!isAddAddressLoading.call()) addAddress();
      }
    } else {
      userCurrentAddress('${streetTFController.text}, ${barangayTFController.text}, ${cityTFController.text}'.trim());
      _box.write(Config.USER_CURRENT_STREET, streetTFController.text);
      _box.write(Config.USER_CURRENT_BARANGAY, barangayTFController.text);
      _box.write(Config.USER_CURRENT_CITY, cityTFController.text);
      _box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.call());
      _box.write(Config.IS_SETUP_LOCATION, true);
      Get.offAllNamed(Config.DASHBOARD_ROUTE);
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
    c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(currentLocation.latitude, currentLocation.longitude), zoom: 18)));
    isBounced(false);
  }

  void onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    final c = await _mapController.future;
    c.setMapStyle(mapStyle.call());
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
    isLoading(true);

    if (argument['type'] != Config.ADD_NEW_ADDRESS) {
      _box.write(Config.USER_CURRENT_LATITUDE, currentPosition.call().latitude);
      _box.write(Config.USER_CURRENT_LONGITUDE, currentPosition.call().longitude);
    }

    await placemarkFromCoordinates(currentPosition.call().latitude, currentPosition.call().longitude).then((response) {
      isLoading(false);
      hasLocation(true);

      print(response.asMap());

      // final address = '${response.first.subLocality}, ${response.first.locality}, ${response.first.adminArea}';

      // streetTFController.text = response.first.addressLine;
      // barangayTFController.text = response.first.subThoroughfare == null ? '${response.first.thoroughfare}' : '${response.first.subThoroughfare} ${response.first.thoroughfare}';
      // barangayTFController.text = response.first.addressLine;
      // cityTFController.text = '${response.first.locality == null ? response.first.subLocality : response.first.locality} ${response.first.subAdminArea == null ? response.first.adminArea : response.first.subAdminArea}';
      streetTFController.text = response.first.street;
      barangayTFController.text = response.first.subLocality;
      cityTFController.text = '${response.first.locality} ${response.first.administrativeArea}';

      userCurrentAddress('${streetTFController.text} ${barangayTFController.text} ${cityTFController.text}'.trim());

      if (argument['type'] == Config.ADD_NEW_ADDRESS) {
        
        this.country(response.first.name);
        this.state(response.first.administrativeArea);
        // this.city(response.first.locality);
        this.city(cityTFController.text);
        // this.barangay(response.first.subLocality);
        this.barangay(barangayTFController.text);
        // this.street(response.first.featureName);
        this.street(streetTFController.text);
        this.isoCode(response.first.isoCountryCode);

      } else {
      
        // _box.write(Config.USER_CURRENT_STREET, response.first.featureName);
        _box.write(Config.USER_CURRENT_STREET, streetTFController.text);
        _box.write(Config.USER_CURRENT_COUNTRY, response.first.name);
        _box.write(Config.USER_CURRENT_STATE, response.first.administrativeArea);
        // _box.write(Config.USER_CURRENT_CITY, response.first.locality);
        _box.write(Config.USER_CURRENT_CITY, cityTFController.text);
        _box.write(Config.USER_CURRENT_IS_CODE, response.first.isoCountryCode);
        // _box.write(Config.USER_CURRENT_BARANGAY, response.first.subLocality);
        _box.write(Config.USER_CURRENT_BARANGAY, barangayTFController.text);
        _box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.call());
        _box.write(Config.USER_CURRENT_NAME_OF_LOCATION, 'Home');
      }
      
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
    Get.back(closeOverlays: true);
    return true;
  }

  void addAddress() {
    dismissKeyboard(Get.context);

    print(streetTFController.text);
    isAddAddressLoading(true);
    final request = NewAddressRequest(
      name: this.nameTF.text,
      location: AddressLocation(
        lat: this.currentPosition.call().latitude,
        lng: this.currentPosition.call().longitude
      ),
      country: this.country.call(),
      state: this.state.call(),
      city: cityTFController.text,
      barangay: barangayTFController.text,
      street: streetTFController.text,
      isoCode: this.isoCode.call()
    );

    newAddressSub = _apiService.addNewAddress(request).asStream().listen((response) {
      isAddAddressLoading(false);
      if(response.status == 200) {
        print('Success');
        userCurrentAddress('${response.data.street} ${response.data.barangay} ${response.data.city}'.trim());
        _box.write(Config.USER_CURRENT_STREET, response.data.street);
        _box.write(Config.USER_CURRENT_COUNTRY, response.data.country);
        _box.write(Config.USER_CURRENT_STATE, response.data.state);
        _box.write(Config.USER_CURRENT_CITY, response.data.city);
        _box.write(Config.USER_CURRENT_IS_CODE, response.data.isoCode);
        _box.write(Config.USER_CURRENT_BARANGAY, response.data.barangay);
        _box.write(Config.USER_CURRENT_LATITUDE, response.data.location.lat);
        _box.write(Config.USER_CURRENT_LONGITUDE,  response.data.location.lng);
        _box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.call());
        _box.write(Config.USER_CURRENT_NAME_OF_LOCATION, nameTF.text);
        DashboardController.to
        ..isSelectedLocation(true)
        ..userCurrentNameOfLocation(nameTF.text)
        ..userCurrentAddress(this.userCurrentAddress.call().trim())
        ..isOpenLocationSheet(false)
        ..fetchAllAddresses()
        ..fetchRestaurantDashboard();
        // ..fetchRestaurants();
        Get.back(closeOverlays: true);
        
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