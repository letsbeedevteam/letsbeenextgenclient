import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/screens/setup_location/controllers/setup_location_controller.dart';
import 'package:letsbeeclient/_utils/config.dart';

class SetupLocationPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                            onPressed: _.goToVerifyNumberPage,
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
                      onPressed: () => Get.toNamed(Config.MAP_ROUTE),
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
}