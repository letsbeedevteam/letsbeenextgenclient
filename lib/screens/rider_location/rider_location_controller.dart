import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/secrets.dart';
import 'package:letsbeeclient/models/activeOrderResponse.dart';
import 'package:letsbeeclient/services/socket_service.dart';

class RiderLocationController extends GetxController {

  final GetStorage _box = Get.find();
  final SocketService _socketService = Get.find();
  final Completer<GoogleMapController> _mapController = Completer();
  final polylinePoints = PolylinePoints();
  final arguments = Get.arguments;

  var markers = <MarkerId, Marker>{}.obs;
  var polylines = <PolylineId, Polyline>{}.obs;
  var polylineCoordinates =  RxList<LatLng>().obs;
  var activeOrderData = ActiveOrderData().obs;

  var currentPosition = LatLng(0, 0).obs;
  var isMapLoading = true.obs;
  var message = 'Loading google map...'.obs;

  @override
  void onInit() {
    
    currentPosition(LatLng(_box.read(Config.USER_CURRENT_LATITUDE), _box.read(Config.USER_CURRENT_LONGITUDE)));
    activeOrderData(arguments);
    fetchRiderLocation();
    super.onInit();
  }

  void fetchRiderLocation() {

    _socketService.socket.on('rider-location', (data) {
      print('Rider location: $data');
      markers[MarkerId('rider')].copyWith(
        positionParam: LatLng(15.162861, 120.555717)
      );
    });
  }

  void setupMarker() async {

    final riderIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), Config.PNG_PATH + 'driver_marker.png');
    final restaurantLocation = LatLng(activeOrderData.value.activeRestaurant.location.lat, activeOrderData.value.activeRestaurant.location.lng);

    markers[MarkerId('client')] = Marker(markerId: MarkerId('client'), position: currentPosition.value, infoWindow: InfoWindow(title: 'You'));
    markers[MarkerId('restaurant')] = Marker(markerId: MarkerId('restaurant'), position: restaurantLocation, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure), infoWindow: InfoWindow(title: 'Restaurant'));
    markers[MarkerId('rider')] = Marker(markerId: MarkerId('rider'), position: LatLng(0, 0), icon: riderIcon, infoWindow: InfoWindow(title: 'Rider'));

    _setupPolylines(destLocation: currentPosition.value, sourceLocation: restaurantLocation);
  }

  void _setupPolylines({LatLng destLocation, LatLng sourceLocation}) async {
    message('Loading coordinates...');

    final secretLoad = await Get.find<SecretLoader>().loadKey();

    await polylinePoints.getRouteBetweenCoordinates(secretLoad.googleMapKey, PointLatLng(sourceLocation.latitude, sourceLocation.longitude), PointLatLng(destLocation.latitude, destLocation.longitude)).then((result) {
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point){
          polylineCoordinates.value.add(LatLng(point.latitude,point.longitude));
        });
          
        polylines[PolylineId('poly')] =  Polyline(polylineId: PolylineId('poly'), width: 5, color: Colors.red, points: polylineCoordinates.value);
        isMapLoading(false);
      }
    }).catchError((onError) {
      _setupPolylines();
      print('Polyline error: $onError');
    });
  }

  currentRiderLocation() async {
    final c = await _mapController.future;
    c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(markers[MarkerId('rider')].position.latitude, markers[MarkerId('rider')].position.longitude), zoom: 18)));
  }

  onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
    setupMarker();
  }

  onCameraMovePosition(CameraPosition position) {
    currentPosition(LatLng(position.target.latitude, position.target.longitude));
  }
}