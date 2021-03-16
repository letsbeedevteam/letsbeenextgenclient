import 'dart:async';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/active_order_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/services/socket_service.dart';
import 'package:flutter/services.dart' show rootBundle;

class RiderLocationController extends GetxController {

  final SocketService _socketService = Get.find();
  final Completer<GoogleMapController> _mapController = Completer();
  final arguments = Get.arguments;

  var markers = <MarkerId, Marker>{}.obs;
  var activeOrderData = ActiveOrderData().obs;

  var currentPosition = LatLng(0, 0).obs;
  var riderPosition = LatLng(0, 0).obs;
  var isMapLoading = true.obs;
  var isRiderLoading = true.obs;
  var message = tr('loadingMap').obs;
  var mapStyle = ''.obs;

  Uint8List riderIcon;
  Uint8List customerIcon;

final dashboardController = DashboardController.to.socketService;

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
  }

  void receiveRiderLocation() async {
    message(tr('trackingRider'));
    _socketService.socket?.on('rider-location', (response) async {
      print('Rider location: $response');
      if (response['data']['location'] != null) {
        if (activeOrderData.call() != null) {
          if (response['data']['order_id'] == activeOrderData.call().id) {
            riderPosition(LatLng(response['data']['location']['lat'],response['data']['location']['lng']));
            markers[MarkerId('rider')] = Marker(markerId: MarkerId('rider'), position: riderPosition.call(), icon: BitmapDescriptor.fromBytes(riderIcon), infoWindow: InfoWindow(title: tr('yourRider')));
            
            if (isRiderLoading.call()) {
              final bound = LatLngBounds(southwest: currentPosition.call(), northeast: riderPosition.call());
              final c = await _mapController.future;
              final u2 = CameraUpdate.newLatLngBounds(bound, 50);
              c.animateCamera(u2).then((void v){
                check(u2, c);
              });
            }
          }
        }
      }

      isRiderLoading(false);
    });
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    LatLngBounds l1=await c.getVisibleRegion();
    LatLngBounds l2=await c.getVisibleRegion();
    print(l1.toString());
    print(l2.toString());
    if(l1.southwest.latitude==-90 ||l2.southwest.latitude==-90)
    check(u, c);
  }


  void setupMarker() async {
    final c = await _mapController.future;
    rootBundle.loadString(Config.JSONS_PATH + 'map_style.json').then((string) {
      mapStyle(string);
      c.setMapStyle(mapStyle.call());
    });
    markers[MarkerId('client')] = Marker(markerId: MarkerId('client'), position: currentPosition.call(), icon: BitmapDescriptor.fromBytes(customerIcon), infoWindow: InfoWindow(title: tr('you')));
  }

  currentRiderLocation() async {
    final c = await _mapController.future;
    if (markers[MarkerId('rider')] == null) {
      alertSnackBarTop(message: tr('trackingRider'));
    } else {
      c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(markers[MarkerId('rider')].position.latitude, markers[MarkerId('rider')].position.longitude), zoom: 19)));
    }
  }

  onMapCreated(GoogleMapController controller) async  {
    _mapController.complete(controller);
    if (currentPosition.call() != null) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        setupMarker();   
        receiveRiderLocation();
        isMapLoading(false);  
      });
    }
  }

  gpsLocation() async {
    final c = await _mapController.future;
    c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: currentPosition.call(), zoom: 18)));
  }
}