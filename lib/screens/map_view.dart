import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/controllers/map/map_controller.dart';

class MapPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          Config.PNG_PATH + 'letsbee_bg.png',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Color(Config.LETSBEE_COLOR).withOpacity(1),
            title: Container(
              height: 40,
              margin: EdgeInsets.only(right: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search your location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 0, 
                      style: BorderStyle.none,
                    )
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.only(top: 10, left: 10, bottom: 10)
                ),
                enableSuggestions: false,
                textAlign: TextAlign.start,
                cursorColor: Colors.black,
              ),
            ),
            actions: [
              GetBuilder<MapController>(
                builder: (_) => IconButton(icon: Icon(Icons.gps_fixed), onPressed: () => _.gpsLocation())
              )
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
                                target: _.currentPosition.value
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
                                  height: _.isBounced.value ? 5 : 8,
                                  width: _.isBounced.value ? 5 : 15, 
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.all(Radius.elliptical(100, 70)))
                                )
                              ),
                              AnimatedContainer(
                                padding: EdgeInsets.only(bottom: _.isBounced.value ? 20 : 0),
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
                        _.isMapLoading.value ? Container(color: Colors.white, child: Center(child: Text('Loading google map...'))) : Container(),
                      ],
                    ),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.only(bottom: 35),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0,2)
                    )
                  ]
                ),
                child: SizedBox(
                  height: 40,
                  child: GetBuilder<MapController>(
                    builder: (_) {
                      return RaisedButton(
                        color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(13),
                          child: Text('SAVE LOCATION'),
                        ),
                        onPressed: () => _.isMapLoading.value ? null : _showDialog(_.userCurrentAddress.value)
                      );
                    },
                  ),
                  width: Get.width * 0.80,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  _goToVerifyNumberPage() => Get.offAndToNamed(Config.VERIFY_NUMBER_ROUTE);

  _showDialog(String address) {
    Get.defaultDialog(
      title: 'Confirm your location',
      middleText: address,
      barrierDismissible: false,
      cancel: RaisedButton(
        color: Color(Config.LETSBEE_COLOR).withOpacity(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text('Cancel'), 
        onPressed: () => Get.back()
      ),
      confirm: RaisedButton(
        color: Color(Config.LETSBEE_COLOR).withOpacity(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text('Looks good'), 
        onPressed: () => _goToVerifyNumberPage()
      ),
    );
  }
}