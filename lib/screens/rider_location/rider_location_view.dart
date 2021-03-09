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
        title: Text('Track Rider', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () => Get.back()),
        bottom: PreferredSize(
          child: Container(height: 2, color: Colors.grey.shade200),
          preferredSize: Size.fromHeight(4.0)
        ),
        actions: [
          IconButton(icon: Icon(FontAwesomeIcons.motorcycle, color: Colors.black), onPressed: controller.currentRiderLocation),
          IconButton(icon: Icon(Icons.house, size: 30), onPressed: () => controller.gpsLocation())
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Obx(() {
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  zoom: 15,
                  target: controller.currentPosition.call()
                ),
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
                compassEnabled: false,
                markers: Set<Marker>.of(controller.markers.values),
                // polylines: Set<Polyline>.of(_.polylines.values),
                onMapCreated: controller.onMapCreated,
                // onCameraMove: _.onCameraMovePosition
              );
            }),
            Obx(() => controller.isMapLoading.call() ? Container(color: Color(Config.WHITE), child: Center(child: Text(controller.message.call()))) : Container())
          ],
        )
      )
    );
  }
}