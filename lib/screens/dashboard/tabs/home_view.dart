import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/restaurant.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

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
            child: GetBuilder<DashboardController>(
              builder: (_) {
                return IgnorePointer(
                  ignoring: _.isLoading.value,
                  child: TextField(
                    controller: _.tfSearchController,
                    onChanged: _.searchRestaurant,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15),
                      hintText: 'Search restaurant...',
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
                );
              },
            )
          ),
        ),
        Container(height: 1, color: Colors.grey.shade300, margin: EdgeInsets.only(top: 8)),
        GetBuilder<DashboardController>(
          builder: (_) {
            return Flexible(
              child: RefreshIndicator(
                onRefresh: () {
                  _.fetchRestaurants();
                  return _.refreshCompleter.future;
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _.recentRestaurants.value.isNotEmpty ? Container(
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
                              children: _.restaurants.value.data.recentOrders.map((e) => _buildRecentRestaurantItem()).toList()
                            ),
                          )
                          ],
                        ),
                      ) : Container(),
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        _.searchRestaurants.value.isNotEmpty ? Column(
                          children: _.searchRestaurants.value.map((e) => _buildRestaurantItem(e)).toList(),
                        ) : Container(height: 250,child: Center(child: _.isLoading.value ? Image.asset(cupertinoActivityIndicatorSmall) : Text(_.message.value, style: TextStyle(fontSize: 20)))
                      )
                    ],
                  ),
                ),
              )
            );
          },
        )
      ],
    );
  }

  Widget _buildRecentRestaurantItem() {
    return GestureDetector(
      child: Container(
        width: 70,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Hero(
          tag: 'jollibee',
            child: CircleAvatar(
            radius: 50,
            backgroundImage: ExactAssetImage(Config.PNG_PATH + 'jollibee.png'),
            backgroundColor: Colors.transparent,
          ),
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
      ),
      onTap: () =>  Get.toNamed(Config.RESTAURANT_ROUTE),
    );
  }

  Widget _buildRestaurantItem(RestaurantElement data) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(data.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, top: 5),
            child: Text(data.location.name, style: TextStyle(fontSize: 15), textAlign: TextAlign.start),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          GestureDetector(
            child: Hero(
              tag: data.name, 
              child: Container(
                height: 200,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: Get.width,
                  child: data.sliders.isNotEmpty ? FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: data.sliders.first.url, fit: BoxFit.cover, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Center(child: Image.asset(Config.PNG_PATH + 'letsbee_logo.png')))) 
                  : Container(child: Center(child: Center(child: Image.asset(Config.PNG_PATH + 'letsbee_logo.png')))),
                ),
              )
            ),
            onTap: () => Get.toNamed(Config.RESTAURANT_ROUTE, arguments: data.toJson())
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
              children: data.menuCategorized.first.menus.map((e) => _buildAvailableMenu(e, restaurantId: data.id)).toList()
            ),
          )
        ],
      ),
    );
  }
  
  Widget _buildAvailableMenu(Menu menu, {int restaurantId}) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Hero(
                tag: menu.name,
                child: Container(
                  width: 180,
                  height: 200,
                  child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: menu.image, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Image.asset(Config.PNG_PATH + 'letsbee_logo.png'))),
                ),
              )
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Text(menu.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text('₱ ${menu.price}', style: TextStyle(fontSize: 13), textAlign: TextAlign.start),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () => Get.toNamed(Config.MENU_ROUTE, arguments: {
        'restaurantId': restaurantId, 
        'menuId': menu.id,
        'menu': menu.toJson()
      })
    );
  }

  // Widget _buildHotMenu() {
  //   return GestureDetector(
  //     child: Container(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Flexible(
  //             child: Stack(
  //               alignment: FractionalOffset.topRight,
  //               children: [
  //                 Hero(
  //                   tag: 'hot_item',
  //                   child: Container(
  //                     width: 180,
  //                     height: 200,
  //                     decoration: BoxDecoration(
  //                       image: DecorationImage(
  //                         image: AssetImage(Config.PNG_PATH + 'burger.png'),
  //                         fit: BoxFit.cover
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Banner(
  //                   message: 'HOT!',
  //                   textDirection: TextDirection.ltr,
  //                   color: Colors.red,
  //                   location: BannerLocation.topEnd,
  //                 ),
  //               ],
  //             )
  //           ),
  //           Container(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   margin: EdgeInsets.only(left: 10, right: 10, top: 10),
  //                   child: Text('Classic Burger', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
  //                 ),
  //                 Container(
  //                   alignment: Alignment.centerLeft,
  //                   margin: EdgeInsets.only(left: 10, right: 10),
  //                   child: Text('₱ 200.00', style: TextStyle(fontSize: 13), textAlign: TextAlign.start),
  //                 )
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //     onTap: () => Get.toNamed(Config.MENU_ROUTE),
  //   );
  // }
}