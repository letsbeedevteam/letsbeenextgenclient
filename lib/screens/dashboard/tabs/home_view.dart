import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';

class HomePage extends StatelessWidget {

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
                contentPadding: EdgeInsets.only(left: 15),
                hintText: 'Search...',
                fillColor: Colors.grey.shade200,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide.none
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
        ),
        Container(height: 1, color: Colors.grey.shade300, margin: EdgeInsets.only(top: 8)),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Recent Restaurants', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                      ),
                      Container(
                        height: 80,
                        child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildRecentRestaurantItem(),
                          _buildRecentRestaurantItem(),
                          _buildRecentRestaurantItem(),
                        ],
                      ),
                      )
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Column(
                  children: [
                    _buildRestaurantItem(),
                    _buildRestaurantItem(),
                    _buildRestaurantItem(),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRecentRestaurantItem() {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage(Config.PNG_PATH + 'default.png'),
        ),
      ),
      onTap: () => print('Go to menu'),
    );
  }

  Widget _buildRestaurantItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('Army Navy Burger + Burritos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, top: 5),
            child: Text('SM Clark', style: TextStyle(fontSize: 15), textAlign: TextAlign.start),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          GestureDetector(
            child: Container(
              height: 200,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: Get.width,
                child: Image.asset(Config.PNG_PATH + 'default.png', fit: BoxFit.cover),
              ),
            ),
            onTap: () => print('Go to menu'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Colors.grey.shade200, thickness: 5, indent: 30, endIndent: 30,),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: Get.height * 0.25,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildMenuWithPriceItem(),
                _buildMenuWithPriceItem(),
                _buildMenuWithPriceItem(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuWithPriceItem() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: 180,
                  child: Image.asset(Config.PNG_PATH + 'letsbee_logo.png', fit: BoxFit.cover),
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Text('Classic Burger', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text('₱ 200.00', style: TextStyle(fontSize: 13), textAlign: TextAlign.start),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () => print('Go to menu'),
    );
  }
}