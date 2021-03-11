import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/screens/setup_location/controllers/map_controller.dart';

class MapPage extends GetView<MapController> {

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      child: GestureDetector(
        onTap: () => dismissKeyboard(Get.context),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          // resizeToAvoidBottomPadding: false,
          backgroundColor: Color(Config.WHITE),
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Color(Config.WHITE),
            leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () => controller.willPopCallback()),
            // title: GetX<MapController>(
            //   builder: (_) => _.isBounced.call() || _.isLoading.call() ? Text('Loading location...', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)) : Container(),
            // ),
            title: Obx((){
              return Text(tr('${controller.isBounced.call() || controller.isLoading.call() ? 'loadingAddress' : 'addressSetting'}'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black));
            }),
            centerTitle: true,
            bottom: PreferredSize(
              child: Container(height: 1, color: Colors.grey.shade200),
              preferredSize: Size.fromHeight(5.0)
            ),
            actions: [
              // SizedBox(height: 45, width: 45, child: IconButton(icon: Image.asset(Config.PNG_PATH + 'search.png'), onPressed: () => controller.handleSearchLocation())),
              IconButton(icon: Image.asset(Config.PNG_PATH + 'gps.png'), onPressed: () => controller.gpsLocation())
            ],
          ),
          body: Container(
            child: Column(
              children: [
                _buildMap(),
                _buildFields(),
              ],
            ),
          )
        ),
      ),
      onWillPop: () => controller.willPopCallback(),
    );
  }

  Widget _buildMap() {
    return Obx(() {
      return Flexible(
        child: Stack(
          children: [
            Container(
              height: Get.height,
              child: controller.isMapLoading.call() ? Center(
                child: Text(tr('loadingCoordinates'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
              ) : GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      zoom: 18,
                      target: controller.currentPosition.call()
                    ),
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    compassEnabled: false,
                    onMapCreated: (mapController) => controller.onMapCreated(mapController),
                    onCameraMove: (position) {
                      controller.onCameraMovePosition(position);
                    },
                    onCameraIdle: () => controller.getCurrentAddress(),
                  ),
            ),
            controller.isMapLoading.call() ? Container() : Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Stack(
                children: [
                  Center(
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1), 
                      margin: EdgeInsets.only(top: 35), 
                      height: controller.isBounced.call() ? 8 : 8,
                      width: controller.isBounced.call() ? 8 : 18, 
                      curve: Curves.fastLinearToSlowEaseIn,
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.all(Radius.elliptical(100, 70)))
                    )
                  ),
                  AnimatedContainer(
                    padding: EdgeInsets.only(bottom: controller.isBounced.call() ? 20 : 0),
                    duration: Duration(seconds: 1),
                    curve: Curves.bounceOut,
                    child: Center(
                      child: Image.asset(Config.PNG_PATH + 'point.png', height: 35, width: 35),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      );
    });
  }

  Widget _buildFields() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            _buildAddressLabel(),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            _buildAddressDetails(),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            _buildNoteToRider(),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            SizedBox(
              width: Get.width * 0.85,
              child: _buildNextButton()
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAddressLabel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('addressLabel'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        Obx(() {
          return SizedBox(
            height: 40,
            child: TextFormField(
                enabled: !controller.isAddAddressLoading.call(),
                controller: controller.addressLabel,
                focusNode: controller.addressLabelNode,
                onEditingComplete: () {
                  controller.addressDetails.selection = TextSelection.fromPosition(TextPosition(offset: controller.addressDetails.text.length));
                  controller.addressDetailsNode.requestFocus();
                },
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15),
                keyboardType: TextInputType.text, 
                textInputAction: TextInputAction.next,
                enableSuggestions: false,
                autocorrect: false,
                obscureText: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(Config.PNG_PATH + 'bookmark.png', width: 10,),
                  ),
                  filled: true,
                  fillColor: controller.isAddAddressLoading.call() ? Colors.grey.shade200 : Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  ),
                  contentPadding: EdgeInsets.only(left: 15, right: 15)
                )
              ),
          );
        })
      ],
    );
  }

  Widget _buildAddressDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('addressDetails'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        Obx(() {
          return SizedBox(
            height: 40,
            child: TextFormField(
                enabled: !controller.isAddAddressLoading.call(),
                controller: controller.addressDetails,
                focusNode: controller.addressDetailsNode,
                onEditingComplete: () {
                  controller.noteToRider.selection = TextSelection.fromPosition(TextPosition(offset: controller.noteToRider.text.length));
                  controller.noteToRiderNode.requestFocus();
                },
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15),
                keyboardType: TextInputType.text, 
                textInputAction: TextInputAction.next,
                enableSuggestions: false,
                autocorrect: false,
                obscureText: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(Config.PNG_PATH + 'email.png', width: 10,),
                  ),
                  filled: true,
                  fillColor: controller.isAddAddressLoading.call() ? Colors.grey.shade200 : Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  ),
                  contentPadding: EdgeInsets.only(left: 15, right: 15)
                )
              ),
          );
        })
      ],
    );
  }

  Widget _buildNoteToRider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('noteToRider'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        Obx(() {
          return SizedBox(
            height: 40,
            child: TextFormField(
                enabled: !controller.isAddAddressLoading.call(),
                controller: controller.noteToRider,
                focusNode: controller.noteToRiderNode,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15),
                keyboardType: TextInputType.text, 
                textInputAction: TextInputAction.done,
                enableSuggestions: false,
                autocorrect: false,
                obscureText: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(Config.PNG_PATH + 'notes.png', width: 10,),
                  ),
                  filled: true,
                  fillColor: controller.isAddAddressLoading.call() ? Colors.grey.shade200 : Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  ),
                  contentPadding: EdgeInsets.only(left: 15, right: 15)
                )
              ),
          );
        })
      ],
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: SizedBox(
        child: Obx(() {
          return RaisedButton(
            color: Color(Config.LETSBEE_COLOR),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20) 
            ),
            child: Text(tr('${controller.isAddAddressLoading.call() ? 'loading' : controller.buttonTitle.value}'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
            onPressed: () => controller.isMapLoading.call() || controller.isLoading.call() ? null : controller.goToDashboardPage()
          );
        }),
      )
    );
  }
}