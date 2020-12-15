import 'package:flutter/material.dart';
import 'package:letsbeeclient/_utils/config.dart';

class HistoryPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        children: [
          _buildHistoryItem(),
        ],
      ),
    );
  }

  Widget _buildHistoryItem() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5.0,
              offset: Offset(3,3)
            )
          ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
              height: 70.0,
              width: 70.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.black, width: 1.5)
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: ExactAssetImage(Config.PNG_PATH + 'army_navy.png'),
                backgroundColor: Colors.transparent,
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Text('Army Navy - SM Clark', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17), textAlign: TextAlign.start,),
                    ),
                    Text('November 26, 2020', style: TextStyle(fontSize: 13)),
                    Text('1x Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Container(
                      margin: EdgeInsets.only(right: 10, bottom: 10),
                      alignment: FractionalOffset.bottomRight,
                      child: Text('₱ 200.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    )
                ],
              )
            ),
          ],
        ),
      ),
      onTap: () => print('Clicked'),
    );
  }
}