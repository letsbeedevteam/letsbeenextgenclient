import 'dart:async';
import 'dart:typed_data';
// import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
// import 'package:letsbeeclient/_utils/secrets.dart';
import 'package:letsbeeclient/models/activeOrderResponse.dart';
// import 'package:letsbeeclient/models/riderLocationResponse.dart';
import 'package:letsbeeclient/services/socket_service.dart';
import 'package:flutter/services.dart' show rootBundle;

class RiderLocationController extends GetxController {

  // final GetStorage _box = Get.find();
  // final SecretLoader _secretLoader = Get.find();
  final SocketService _socketService = Get.find();
  final Completer<GoogleMapController> _mapController = Completer();
  final polylinePoints = PolylinePoints();
  final arguments = Get.arguments;

  var markers = <MarkerId, Marker>{}.obs;
  // var polylines = <PolylineId, Polyline>{}.obs;
  // var polylineCoordinates =  RxList<LatLng>().obs;
  var activeOrderData = ActiveOrderData().obs;

  var currentPosition = LatLng(0, 0).obs;
  var riderPosition = LatLng(0, 0).obs;
  var isMapLoading = true.obs;
  var message = 'Loading map...'.obs;

  // var hasPolyline = false.obs;
  var mapStyle = ''.obs;

  // BitmapDescriptor riderIcon;
  Uint8List riderIcon;
  Uint8List customerIcon;

  @override
  void onInit() {
    setupIcon();
    activeOrderData(arguments);
    currentPosition(LatLng(activeOrderData.call().address.location.lat, activeOrderData.call().address.location.lng));
    super.onInit();
  }

  @override
  void onClose() {
    // hasPolyline(false);
    super.onClose();
  }

  void setupIcon() async {
    riderIcon = await getBytesFromAsset(Config.PNG_PATH + 'rider_marker.png', 100);
    customerIcon = await getBytesFromAsset(Config.PNG_PATH + 'customer_marker.png', 100);
    // riderIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), Config.PNG_PATH + 'driver_marker.png');
  }

  void receiveRiderLocation() async {
    message('Tracking rider...');
    _socketService.socket.on('rider-location', (response) {
      print('Rider location: $response');
      isMapLoading(false);
      if (response['data']['location'] != null) {
        if (activeOrderData.call() != null) {
          if (response['data']['order_id'] == activeOrderData.call().id) {
            riderPosition(LatLng(response['data']['location']['lat'],response['data']['location']['lng']));
            markers[MarkerId('rider')] = Marker(markerId: MarkerId('rider'), position: riderPosition.call(), icon: BitmapDescriptor.fromBytes(riderIcon), infoWindow: InfoWindow(title: 'Your Rider'));
            // _setupPolylines(sourceLocation: riderPosition.call());
          }
        }
      }
    });
  }

  void setupMarker() async {
    // double latitude = double.parse(activeOrderData.call().activeRestaurant.latitude);
    // double longitude = double.parse(activeOrderData.call().activeRestaurant.longitude);
    // // final restaurantLocation = LatLng(latitude, longitude);
    final c = await _mapController.future;
    rootBundle.loadString(Config.JSONS_PATH + 'map_style.json').then((string) {
      mapStyle(string);
      c.setMapStyle(mapStyle.call());
    });
    markers[MarkerId('client')] = Marker(markerId: MarkerId('client'), position: currentPosition.call(), icon: BitmapDescriptor.fromBytes(customerIcon), infoWindow: InfoWindow(title: 'You'));

    // markers[MarkerId('restaurant')] = Marker(markerId: MarkerId('restaurant'), position: restaurantLocation, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure), infoWindow: InfoWindow(title: 'Restaurant'));
    // markers[MarkerId('rider')] = Marker(markerId: MarkerId('rider'), position: riderPosition.call(), icon: riderIcon, infoWindow: InfoWindow(title: 'Rider'));
  }

  // void _setupPolylines({LatLng sourceLocation}) async {
  //   message('Loading coordinates...');
  //   final secretLoad = await _secretLoader.loadKey();
  //   await polylinePoints.getRouteBetweenCoordinates(secretLoad.googleMapKey, PointLatLng(sourceLocation.latitude, sourceLocation.longitude), PointLatLng(currentPosition.call().latitude, currentPosition.call().longitude)).then((result) {
  //     polylineCoordinates.call().clear();
  //     if (result.points.isNotEmpty) {
        
  //       result.points.forEach((PointLatLng point){
  //         polylineCoordinates.call().add(LatLng(point.latitude,point.longitude));
  //       });
          
  //       polylines[PolylineId('poly')] = Polyline(polylineId: PolylineId('poly'), width: 5, geodesic: true, jointType: JointType.round, color: Colors.red, points: polylineCoordinates.call());
  //       isMapLoading(false);
  //     }
  //   }).catchError((onError) {
  //     _setupPolylines(sourceLocation: riderPosition.call());
  //     print('Polyline error: $onError');
  //   });
  // }

  currentRiderLocation() async {
    final c = await _mapController.future;
    c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(markers[MarkerId('rider')].position.latitude, markers[MarkerId('rider')].position.longitude), zoom: 19)));
  }

  onMapCreated(GoogleMapController controller) async  {
    _mapController.complete(controller);
    if (currentPosition.call() != null) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        setupMarker();   
        receiveRiderLocation();
      });
    }
  }

  gpsLocation() async {
    final c = await _mapController.future;
    c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: currentPosition.call(), zoom: 18)));
  }

  // onCameraMovePosition(CameraPosition position) => currentPosition(LatLng(position.target.latitude, position.target.longitude));
}