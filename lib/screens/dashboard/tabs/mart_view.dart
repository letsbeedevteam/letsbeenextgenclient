import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';

class MartPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 35,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10),
                hintText: 'Search mart...',
                fillColor: Colors.grey.shade200,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide.none
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            )
          ),
        ),
        Flexible(
          child: _scrollView(),
        )
      ],
    );
  }

  Widget _scrollView() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    child: Text('Recent Supermarket', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildRecentMart(),
                          _buildRecentMart(),
                          _buildRecentMart(),
                          _buildRecentMart()
                        ],
                      ),
                    ),
                  )
                ],  
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
                  child: Text('All Supermarket', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMart(),
                        _buildMart(),
                        _buildMart(),
                        _buildMart()
                      ],
                    ),
                )
              ],  
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecentMart() {
    return GestureDetector(
      onTap: () => print('Clicked'),
      child: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        margin: EdgeInsets.only(right: 20),
        width: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(Config.PNG_PATH + 'banner.png', fit: BoxFit.cover, width: Get.width),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 5, right: 5),
              child: Text('Puregold - Friendship', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
            ),
            Container(
              padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
              child: Text('(1.2 km away)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10), overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMart() {
    return GestureDetector(
      onTap: () => print('Clicked'),
      child: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 150,
                alignment: Alignment.center,
                child: ClipRRect(
                  child: Image.asset(Config.PNG_PATH + 'banner.png', fit: BoxFit.cover, width: Get.width),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                ),
              ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 5, right: 5),
              child: Text('Supermarket - SM CLARK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
            ),
            Container(
              padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
              child: Text('(5.2 km away)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10), overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      ),
    );
  }
}