import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/screens/setup_location/controllers/setup_location_controller.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'dart:math' as math;

class SetupLocationPage extends GetView<SetupLocationController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: IconButton(icon: Icon(Icons.logout), onPressed: () => controller.logout())
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [     
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Center(
                child: SizedBox(
                  height: 180,
                  width: 180,
                  child: Image.asset(Config.PNG_PATH + 'frame_location.png'),
                ),
              ),
            ),
            Center(child: Text('How would you like to set your location?', style: TextStyle(fontSize: 18))),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Container(
              child: Column(
                children: [
                  Text('Your Current Location is: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 30, right: 30),
                    decoration: BoxDecoration(
                      color: Color(Config.WHITE).withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: GetX<SetupLocationController>(
                      builder: (_) => Text(_.userCurrentAddress.call(), style: TextStyle(fontSize: 17), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,),
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Container(
              height: Get.height * 0.35,
              width: Get.width,
              margin: EdgeInsets.only(left: 30, right: 30),
              decoration: BoxDecoration(
                color: Color(Config.WHITE).withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.circular(30))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 210,
                    height: 40,
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
                    child: GetX<SetupLocationController>(
                      builder: (_) {
                        return IgnorePointer(
                          ignoring: !_.hasLocation.call(),
                          child: RaisedButton(
                            color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(13),
                              child: Text('CURRENT LOCATION'),
                            ),
                            onPressed: () => confirmLocationModal(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  Container(
                    width: 210,
                    height: 40,
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
                    child: RaisedButton(
                      color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(13),
                        child: Text('SEARCH LOCATION'),
                      ),
                      onPressed: () => Get.toNamed(Config.MAP_ROUTE, arguments: {'type': Config.SETUP_ADDRESS}),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  confirmLocationModal() {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text('Is this your current location?', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Text('House No./Street', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400)),
            SizedBox(
              height: 30,
              child: TextFormField(
                controller: controller.streetTFController,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15),
                keyboardType: TextInputType.emailAddress, 
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
                )
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text('Barangay / Purok', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400)),
            SizedBox(
              height: 30,
              child: TextFormField(
                controller: controller.barangayTFController,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15),
                keyboardType: TextInputType.emailAddress, 
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
                )
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text('Municipality / City', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400)),
            SizedBox(
              height: 30,
              child: TextFormField(
                 controller: controller.cityTFController,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15),
                keyboardType: TextInputType.emailAddress, 
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
                )
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                    onPressed: () {
                      Get.back();
                      Get.toNamed(Config.MAP_ROUTE, arguments: {'type': Config.SETUP_ADDRESS});
                    },
                    child: Text('NO'),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                    onPressed: () =>  controller.goToDashboardPage(),
                    child: Text('YES'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      barrierDismissible: false
    );
  }
}