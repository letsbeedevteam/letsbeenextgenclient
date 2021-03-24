import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/_utils/secrets.dart';
import 'package:letsbeeclient/models/edit_address_request.dart';
import 'package:letsbeeclient/models/edit_address_response.dart';
import 'package:letsbeeclient/models/get_address_response.dart';
import 'package:letsbeeclient/models/new_address_request.dart';
import 'package:letsbeeclient/models/new_address_response.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/address/address_controller.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/services/api_service.dart';
import 'package:location/location.dart' as lct;
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapController extends GetxController {

  GoogleMapController _mapController;


  final GetStorage _box = Get.find();
  final SecretLoader _secretLoader = Get.find();
  final ApiService _apiService = Get.find();
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

  var buttonTitle = 'next'.obs;
  var addressData = AddressData().obs;

  Future mapFuture = Future.delayed(Duration(seconds: 2), () => true);

  GoogleMapsPlaces _places;
  StreamSubscription<NewAddressResponse> newAddressSub;
  StreamSubscription<EditAddressResponse> editAddressSub;

  
  @override 
  void onInit() {
    if (argument['type'] == Config.ADD_NEW_ADDRESS) {

      currentPosition(LatLng(_box.read(Config.USER_CURRENT_LATITUDE), _box.read(Config.USER_CURRENT_LONGITUDE)));
      buttonTitle('save');
      isMapLoading(false);

    } else if (argument['type'] == Config.EDIT_NEW_ADDRESS) {
      addressData(AddressData.fromJson(argument['data']));
      currentPosition(LatLng(addressData.call().location.lat, addressData.call().location.lng));

      addressLabel.text = addressData.call().name;
      addressDetails.text = addressData.call().address;
      noteToRider.text = addressData.call().note;

      buttonTitle('save');
      isMapLoading(false);

    } else {
      buttonTitle('next');
      isMapLoading(true);
      currentLocation();
    }
    setup();

    super.onInit();
  }

  @override
  void onClose() {
    newAddressSub?.cancel();
    editAddressSub?.cancel();
    super.onClose();
  }

  void currentLocation() async {
    lct.Location().getLocation().then((data) {
      currentPosition(LatLng(data.latitude, data.longitude));
      isMapLoading(false);
    });
  }

  void goToDashboardPage() {

    if (argument['type'] == Config.ADD_NEW_ADDRESS) {
      if (addressLabel.isBlank || addressDetails.text.isBlank) {
        errorSnackbarTop(title: tr('oops'), message: tr('inputFields'));
      } else {
        userCurrentAddress(addressDetails.text.trim());

        if(_box.hasData(Config.PRODUCTS)) {
       
          if (listProductFromJson(_box.read(Config.PRODUCTS)).where((data) => data.userId == _box.read(Config.USER_ID)).isEmpty) {
            addAddress(false);
          } else {
            addresssDialog();
          }

        } else {
          addAddress(false);
        }
      }

    } else if (argument['type'] == Config.EDIT_NEW_ADDRESS) {

      if (addressLabel.isBlank || addressDetails.text.isBlank) {
        errorSnackbarTop(title: tr('oops'), message: tr('inputFields'));
      } else {
        userCurrentAddress(addressDetails.text.trim());
        editAddress();
      }

    } else {
      if (addressDetails.text.isBlank) {
        errorSnackbarTop(title: tr('oops'), message: tr('inputAddressDetail'));
      } else {
        userCurrentAddress(addressDetails.text.trim());
        addAddress(false);
      }
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
    currentPosition(LatLng(currentLocation.latitude, currentLocation.longitude));
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(currentLocation.latitude, currentLocation.longitude), zoom: 15)));
    isBounced(false);
  }

  void onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    _mapController.setMapStyle(mapStyle.call());
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
      hint: tr('searchLocation'),
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
      _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 15)));
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    print(response.errorMessage);
  }

  Future<bool> willPopCallback() async {
    argument['type'] == Config.ADD_NEW_ADDRESS || argument['type'] == Config.EDIT_NEW_ADDRESS ? Get.back(closeOverlays: true) : Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
    return true;
  }

  void addAddress(bool isRemoveCart) {
    dismissKeyboard(Get.context);

    isAddAddressLoading(true);
    final request = NewAddressRequest(
      name: this.addressLabel.text.isBlank ? 'Home' : this.addressLabel.text,
      location: AddressLocation(
        lat: this.currentPosition.call().latitude,
        lng: this.currentPosition.call().longitude
      ),
      address: this.addressDetails.text,
      note: this.noteToRider.text
    );

    newAddressSub = _apiService.addNewAddress(request).asStream().listen((response) {
      isAddAddressLoading(false);
      if(response.status == Config.OK) {
        print('Success');
        userCurrentAddress(response.data.address.trim());
        _box.write(Config.USER_ADDRESS_ID, response.data.id);
        _box.write(Config.USER_CURRENT_LATITUDE, response.data.location.lat);
        _box.write(Config.USER_CURRENT_LONGITUDE,  response.data.location.lng);
        _box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.call());
        _box.write(Config.USER_CURRENT_NAME_OF_LOCATION, response.data.name);
        _box.write(Config.NOTE_TO_RIDER, response.data.note);
        
        if (argument['type'] == Config.ADD_NEW_ADDRESS) {
          
           if(isRemoveCart) {
            final list = listProductFromJson(_box.read(Config.PRODUCTS));
            list.removeWhere((data) => data.userId == _box.read(Config.USER_ID));
            _box.write(Config.PRODUCTS, listProductToJson(list));
            DashboardController.to.updateCart();
          }

          DashboardController.to
          ..isSelectedLocation(true)
          ..userCurrentNameOfLocation(response.data.name)
          ..userCurrentAddress(this.userCurrentAddress.call().trim())
          ..fetchActiveOrders()
          ..fetchRestaurantDashboard(page: 0);
          AddressController.to.refreshAddress();
          Get.back(closeOverlays: true);
          successSnackBarTop(message: tr('addedSuccessfully'));

        } else {
          _box.write(Config.IS_LOGGED_IN, true);
          Get.offAllNamed(Config.DASHBOARD_ROUTE);
        }

        
      } else {
        errorSnackbarTop(title: tr('oops'), message: tr('somethingWentWrong'));
        print('Failed to add new address');
      }

    })..onError((handleError) {
      isAddAddressLoading(false);
      errorSnackbarTop(title: tr('oops'), message: tr('somethingWentWrong'));
      print('Error add new address: $handleError');
    });
  }

  addresssDialog() => Get.defaultDialog(
    title: tr('alertAddressMessage'),
    backgroundColor: Color(Config.WHITE),
    titleStyle: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
    radius: 8,
    content: Container(),
    confirm: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      color: const Color(Config.LETSBEE_COLOR),
      onPressed: () {
        addAddress(true);
        Get.back();
      },
      child: Text(tr('yes'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
    ),
    cancel: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      color: const Color(Config.LETSBEE_COLOR),
      onPressed: () => Get.back(),
      child: Text(tr('no'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
    ),
    barrierDismissible: false
  );

  void editAddress() {
    dismissKeyboard(Get.context);

    isAddAddressLoading(true);
    final request = EditAddressRequest(
      addressId: addressData.call().id,
      name: this.addressLabel.text,
      location: EditAddressLocation(
        lat: this.currentPosition.call().latitude,
        lng: this.currentPosition.call().longitude
      ),
      address: this.addressDetails.text,
      note: this.noteToRider.text
    );

    editAddressSub = _apiService.editAddress(request).asStream().listen((response) {
      isAddAddressLoading(false);
      if(response.status == Config.OK) {
        print('Success');

        if (_box.read(Config.USER_ADDRESS_ID) == addressData.call().id) {

          userCurrentAddress(this.addressDetails.text);
          _box.write(Config.USER_ADDRESS_ID, addressData.call().id);
          _box.write(Config.USER_CURRENT_LATITUDE, this.currentPosition.call().latitude);
          _box.write(Config.USER_CURRENT_LONGITUDE, this.currentPosition.call().longitude);
          _box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress.call());
          _box.write(Config.USER_CURRENT_NAME_OF_LOCATION, this.addressLabel.text);
          _box.write(Config.NOTE_TO_RIDER, this.noteToRider.text);

          DashboardController.to
          ..isSelectedLocation(true)
          ..userCurrentNameOfLocation(this.addressLabel.text)
          ..userCurrentAddress(this.userCurrentAddress.call().trim())
          ..fetchActiveOrders()
          ..fetchRestaurantDashboard(page: 0);
        }

        AddressController.to.refreshAddress();
        Get.back(closeOverlays: true);
        successSnackBarTop(message: tr('updatedSuccessfully'));

      } else {
        errorSnackbarTop(title: tr('oops'), message: tr('somethingWentWrong'));
        print('Failed to add new address');
      }

    })..onError((handleError) {
      isAddAddressLoading(false);
      errorSnackbarTop(title: tr('oops'), message: tr('somethingWentWrong'));
      print('Error edit new address: $handleError');
    });
  }
}