import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';

class NotificationPage extends GetView<DashboardController> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          minimum: EdgeInsets.only(top: 35),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 40,
                  child: RaisedButton(
                    color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Clear All'),
                    onPressed: () => print('Clear all'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: ListView(
          scrollDirection: Axis.vertical,
            children: [
              _buildNotificationItem(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildNotificationItem() {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black,
              width: 0.5
            ),
            top: BorderSide(
              color: Colors.black,
              width: 0.5
            ),
          )
        ),
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: Get.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your order in Army Navy Burger + Burritos has been accepted by the Let\'s bee Driver.', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                  Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                  Text('November 19, 10:00 AM')
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(height: 30, width: 30, child: Image.asset(Config.PNG_PATH + 'new.png')),  
            )
          ],
        ),
      ),
      onTap: () {
        print('lol');
      },
    );
  }
}