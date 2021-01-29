import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/rider_location/rider_location_controller.dart';

class RiderLocationPage extends GetView<RiderLocationController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Rider Tracker'),
        centerTitle: false,
        leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => Get.back()),
        actions: [
          IconButton(icon: Icon(FontAwesomeIcons.motorcycle, color: Colors.black), onPressed: controller.currentRiderLocation),
          IconButton(icon: Image.asset(Config.PNG_PATH + 'gps.png'), onPressed: () => controller.gpsLocation())
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey)
          )
        ),
        child: Stack(
          children: [
            GetX<RiderLocationController>(
              builder: (_) {
                return GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      zoom: 18,
                      target: _.currentPosition.call()
                    ),
                    myLocationButtonEnabled: true,
                    myLocationEnabled: false,
                    compassEnabled: false,
                    markers: Set<Marker>.of(_.markers.values),
                    polylines: Set<Polyline>.of(_.polylines.values),
                    onMapCreated: _.onMapCreated,
                    // onCameraMove: _.onCameraMovePosition
                  );
              },
            ),
            GetX<RiderLocationController>(
              builder: (_) {
                return _.isMapLoading.call() ? Container(color: Colors.white, child: Center(child: Text(_.message.call()))) : Container();
              }, 
            )
          ],
        )
      )
    );
  }
}