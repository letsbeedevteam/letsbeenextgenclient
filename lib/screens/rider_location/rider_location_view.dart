import 'package:easy_localization/easy_localization.dart';
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
        title: Obx(() {
          return Text(controller.isRiderLoading.call() ? controller.message.call() : tr('trackRider'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500));
        }),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () => Get.back()),
        bottom: PreferredSize(
          child: Container(height: 1, color: Colors.grey.shade200),
          preferredSize: Size.fromHeight(4.0)
        ),
        actions: [
          IconButton(icon: Icon(FontAwesomeIcons.motorcycle, color: Colors.black), onPressed: controller.currentRiderLocation),
          IconButton(icon: Icon(Icons.house, size: 30), onPressed: () => controller.gpsLocation())
        ],
      ),
      body: Column(
        children: [
          Obx(() => AnimatedContainer(
            width: double.infinity,
            color: controller.dashboardController.color.call(),
            duration: Duration(milliseconds: 500),
            height: controller.dashboardController.isConnected.call() ? 0 : 25,
            child: Center(
              child: Text(controller.dashboardController.connectMessage.call(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          )),
          Flexible(
            child: Stack(
              children: [
                FutureBuilder(
                  future: controller.mapFuture,
                  builder: (context, snapshot) {
                    return Obx(() => GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        zoom: 15,
                        target: controller.currentPosition.call()
                      ),
                      myLocationButtonEnabled: false,
                      myLocationEnabled: false,
                      compassEnabled: false,
                      markers: Set<Marker>.of(controller.markers.values),
                      onMapCreated: controller.onMapCreated,
                    ));
                  },
                ),
                Obx(() => controller.isMapLoading.call() ? Container(color: Color(Config.WHITE), child: Center(child: Text(controller.message.call(), style: TextStyle(fontSize: 15)))) : Container())
              ],
            ),
          ),
        ],
      )
    );
  }
}