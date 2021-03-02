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
              return Text(controller.isBounced.call() || controller.isLoading.call() ? 'Loading Address...' : 'Address Setting', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black));
            }),
            centerTitle: true,
            bottom: PreferredSize(
              child: Container(height: 2, color: Colors.grey.shade200),
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
                child: Text('Loading coordinates...', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
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
        Text('Address Label', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        SizedBox(
          height: 40,
          child: TextFormField(
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18),
              keyboardType: TextInputType.emailAddress, 
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
                fillColor: Colors.white,
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
                contentPadding: EdgeInsets.only(left: 15)
              )
            ),
        )
      ],
    );
  }

  Widget _buildAddressDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Address Details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        SizedBox(
          height: 40,
          child: TextFormField(
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18),
              keyboardType: TextInputType.emailAddress, 
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
                fillColor: Colors.white,
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
                contentPadding: EdgeInsets.only(left: 15)
              )
            ),
        )
      ],
    );
  }

  Widget _buildNoteToRider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Note To Rider', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        SizedBox(
          height: 40,
          child: TextFormField(
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18),
              keyboardType: TextInputType.emailAddress, 
              textInputAction: TextInputAction.next,
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
                fillColor: Colors.white,
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
                contentPadding: EdgeInsets.only(left: 15)
              )
            ),
        )
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
            child: Text(controller.buttonTitle.value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
            onPressed: () => controller.isMapLoading.call() || controller.isLoading.call() ? null : confirmLocationModal()
          );
        }),
      )
    );
  }

  confirmLocationModal() {
    Get.dialog(
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: GetX<MapController>(
            builder: (_) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Color(Config.WHITE)
                ),
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text('Is this your current location?', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold))),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      Text('Lot No., Block No., Bldg Name, Floor No. / Street', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: 30,
                        child: TextFormField(
                          controller: controller.streetTFController,
                          focusNode: controller.streetNode,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15),
                          textInputAction: TextInputAction.next,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: false,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 15)
                          ),
                          onEditingComplete: () {
                            controller.barangayTFController.selection = TextSelection.fromPosition(TextPosition(offset: controller.barangayTFController.text.length));
                            controller.barangayNode.requestFocus();
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                      Text('Barangay / Purok', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: 30,
                        child: TextFormField(
                          controller: controller.barangayTFController,
                          focusNode: controller.barangayNode,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15),
                          textInputAction: TextInputAction.next,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: false,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 15)
                          ),
                          onEditingComplete: () {
                            controller.cityTFController.selection = TextSelection.fromPosition(TextPosition(offset: controller.cityTFController.text.length));
                            controller.cityNode.requestFocus();
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                      Text('Municipality / City', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: 30,
                        child: TextFormField(
                          controller: controller.cityTFController,
                          focusNode: controller.cityNode,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15),
                          textInputAction: TextInputAction.next,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: false,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 15)
                          ),
                        ),
                      ),
                      _.argument['type'] != Config.ADD_NEW_ADDRESS ? 
                      IgnorePointer(
                        ignoring: _.isAddAddressLoading.call(),
                        child: Container(),
                      ) : Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                            Text('Landmark', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400)),
                            IgnorePointer(
                              ignoring: _.isAddAddressLoading.call(),
                              child: SizedBox(
                                height: 30,
                                child: TextFormField(
                                  controller: _.nameTF,
                                  focusNode: _.nameNode,
                                  cursorColor: Colors.black,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade200,
                                    hintText: 'ex: Home, Work',
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 15)
                                  )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IgnorePointer(
                              ignoring: _.isAddAddressLoading.call(),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                                onPressed: () {
                                  if(Get.isSnackbarOpen) {
                                    Get.back();
                                    Future.delayed(Duration(seconds: 500));
                                    Get.back();
                                  } else {
                                    Get.back();
                                  }
                                },
                                child: Text('NO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                              onPressed: () =>  controller.goToDashboardPage(),
                              child: _.isAddAddressLoading.call() ? Container(height: 10, width: 10, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black))) : Text('YES', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      barrierDismissible: false
    );
  }
}