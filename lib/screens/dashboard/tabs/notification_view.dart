import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';

class NotificationPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          minimum: const EdgeInsets.only(top: 16.0, bottom: 10.0),
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: Get.height * 0.05,
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
              _buildNotificationItem(),
              _buildNotificationItem(),
              _buildNotificationItem(),
              _buildNotificationItem(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildNotificationItem() {
    return Container(
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
            padding: const EdgeInsets.all(5.0),
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
    );
  }
}