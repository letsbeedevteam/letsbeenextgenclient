import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/setup_location/controllers/map_controller.dart';

class MapPage extends GetView<MapController> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: controller.willPopCallback),
          title: GetX<MapController>(
            builder: (_) => _.isBounced.call() || _.isLoading.call() ? Text('Loading location...', style: TextStyle(fontSize: 15)) : Container(),
          ),
          actions: [
            SizedBox(height: 45, width: 45, child: IconButton(icon: Image.asset(Config.PNG_PATH + 'search.png'), onPressed: () => controller.handleSearchLocation())),
            IconButton(icon: Image.asset(Config.PNG_PATH + 'gps.png'), onPressed: () => controller.gpsLocation())
          ],
        ),
        body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
            GetX<MapController>(
              builder: (_) {
                return Container(
                  child: Stack(
                    children: [
                      FutureBuilder(
                        future: Future.delayed(Duration(seconds: 2)),
                        builder: (context, snapshot) {
                          return GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              zoom: 18,
                              target: _.currentPosition.call()
                            ),
                            myLocationButtonEnabled: false,
                            compassEnabled: false,
                            onMapCreated: (controller) => _.onMapCreated(controller),
                            onCameraMove: (position) {
                              _.onCameraMovePosition(position);
                            },
                            onCameraIdle: () => _.getCurrentAddress(),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 25),
                        child: Stack(
                          children: [
                            Center(
                              child: AnimatedContainer(
                                duration: Duration(seconds: 1), 
                                margin: EdgeInsets.only(top: 32), 
                                height: _.isBounced.call() ? 5 : 8,
                                width: _.isBounced.call() ? 5 : 15, 
                                curve: Curves.fastLinearToSlowEaseIn,
                                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.all(Radius.elliptical(100, 70)))
                              )
                            ),
                            AnimatedContainer(
                              padding: EdgeInsets.only(bottom: _.isBounced.call() ? 20 : 0),
                              duration: Duration(seconds: 1),
                              curve: Curves.bounceOut,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(child: Text('You', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                                  Icon(FontAwesomeIcons.mapPin, color: Colors.red, size: 30),
                                  Padding(padding: EdgeInsets.symmetric(vertical: 10))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _.isMapLoading.call() ? Container(color: Colors.white, child: Center(child: Text('Loading google map...'))) : Container(),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0,2)
                    )
                  ]
                ),
                child: SizedBox(
                  child: GetBuilder<MapController>(
                    builder: (_) {
                      return RaisedButton(
                        color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                        child: Padding(
                          padding: EdgeInsets.all(13),
                          child: Text('SAVE LOCATION'),
                        ),
                        onPressed: () => _.isMapLoading.call() ? null : _.showDialog()
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      onWillPop: controller.willPopCallback,
    );
  }
}