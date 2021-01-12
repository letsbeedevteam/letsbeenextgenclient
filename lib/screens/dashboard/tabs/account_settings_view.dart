import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'dart:math' as math;

class AccountSettingsPage extends GetView<DashboardController> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SafeArea(
          minimum: EdgeInsets.only(top: 35),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(),
                  ),
                  height: 100,
                  width: 90,
                  child: Icon(Icons.person, size: 35),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 5),
                      Text('Using ${controller.box.read(Config.SOCIAL_LOGIN_TYPE)} account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black), textAlign: TextAlign.start),
                      Container(height: 5),
                      Text('+63${controller.box.read(Config.USER_MOBILE_NUMBER)}', style: TextStyle(fontSize: 15), textAlign: TextAlign.start),
                      Container(height: 5),
                      Text(controller.box.read(Config.USER_CURRENT_ADDRESS), style: TextStyle(fontSize: 15), textAlign: TextAlign.start)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Container(height: 1, color: Colors.grey.shade300),
        Flexible(
          child: Container(
            alignment: Alignment.topCenter,
            color: Colors.grey.shade200,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 40, left: 30, right: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1.0,
                        blurRadius: 3,
                        offset: Offset(5, 5)
                      )
                    ],
                    color: Colors.white
                  ),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                      SizedBox(
                        height: 30,
                        child: FlatButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () => print('Payment method'), 
                          child: Row(
                            children: [
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Icon(FontAwesomeIcons.creditCard),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 30,
                        child: FlatButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () => print('Location'), 
                          child: Row(
                            children: [
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Icon(Icons.location_pin),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Text('Location', style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 30,
                        child: FlatButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () => print('Language'), 
                          child: Row(
                            children: [
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Icon(FontAwesomeIcons.globe),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Text('Language', style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 30,
                        child: FlatButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () => print('Notification'), 
                          child: Row(
                          children: [
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Icon(Icons.notifications),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                              Text('Notification', style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 30,
                        child: FlatButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: () => controller.signOut(), 
                            child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Transform.rotate(angle: 180 * math.pi / 180, child: Icon(Icons.logout)),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                              Text('Log out', style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}