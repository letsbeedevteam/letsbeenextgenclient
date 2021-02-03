import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            child: GetX<DashboardController>(
              builder: (_) {
                return IgnorePointer(
                  ignoring: _.isLoading.call(),
                  child: TextField(
                    controller: _.tfSearchController,
                    onChanged: _.searchRestaurant,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      hintText: 'Search restaurant...',
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
                  ),
                );
              },
            )
          ),
        ),
        GetX<DashboardController>(
          builder: (_) {
            return Flexible(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  RefreshIndicator(
                    onRefresh: () {
                      _.refreshToken();
                      return _.refreshCompleter.future;
                    },
                    child: IgnorePointer(
                      ignoring: _.isSelectedLocation.call(),
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          controller: _.scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          child: _.restaurants.call() != null ?
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Container(
                              //   padding: EdgeInsets.all(10),
                              //   child: Text('What do you want eat?', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal)),
                              // ),
                              // Container(
                              //   height: 80,
                              //   child: ListView(
                              //     scrollDirection: Axis.horizontal,
                              //     children: [
                              //       _buildCategory(title: 'Filipino Dish'),
                              //       _buildCategory(title: 'Korean Dish'),
                              //       _buildCategory(title: 'Protein'),
                              //       _buildCategory(title: 'Chinese Dish'),
                              //       _buildCategory(title: 'Vietnamese Dish'),
                              //     ]
                              //   ),
                              // ),
                              _.restaurants.call().data.recentRestaurants.isNotEmpty ? Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Text('Recent Restaurants', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.start),
                                    ),
                                    Container(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: _.restaurants.call().data.recentRestaurants.map((data) => _buildRecentRestaurantItem(data)).toList(),
                                        )
                                      ),
                                    ),
                                    // Container(height: 1, color: Colors.grey.shade300, margin: EdgeInsets.only(top: 8)),
                                  ],
                                ),
                              ) : Container(),
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
                                child: Text('All Restaurants Near By', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.start),
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                              _.searchRestaurants.call().isNotEmpty ? 
                              Column(
                                children: [
                                  Column(children: _.searchRestaurants.call().map((e) => _buildRestaurantItem(e)).toList()),
                                  // _.searchRestaurants.call().length == 1 ? Container() : 
                                  // IconButton(icon: Icon(Icons.arrow_circle_up_outlined), onPressed: () => _.scrollController.animateTo(1, duration: Duration(milliseconds: 500), curve: Curves.decelerate), iconSize: 30)
                                ],
                              ) : Container(
                                  height: 250,
                                  child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(child: Text(_.message.call(), style: TextStyle(fontSize: 18))),
                                    RaisedButton(
                                      color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                                      child: Text('Refresh'),
                                      onPressed: () => _.refreshToken(),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ) : Container(height: 250, margin: EdgeInsets.only(top: 40),child: _.isLoading.call() ? CupertinoActivityIndicator() : Text(_.message.call().isEmpty ? Config.SOMETHING_WENT_WRONG : _.message.call(), style: TextStyle(fontSize: 18))),
                        ),
                      ),
                    )
                  ),
                  _.isSelectedLocation.call() ? Container(
                    margin: EdgeInsets.only(top: 70),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(Config.LETSBEE_COLOR).withOpacity(1.0)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Text('Loading your location...', style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ) : Container()
                ],
              )
            );
          },
        )
      ],
    );
  }

  // Widget _buildCategory({String title}) {
  //   return GestureDetector(
  //     child: Container(
  //       margin: EdgeInsets.symmetric(horizontal: 5),
  //       child: Column(
  //         children: [
  //           Container(
  //             margin: EdgeInsets.only(left: 10, right: 10),
  //             padding: EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 15),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(5),
  //               border: Border.all(color: Colors.grey),
  //               color: Colors.white,
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey,
  //                   blurRadius: 4.0,
  //                   offset: Offset(2,2)
  //                 )
  //               ]
  //             ),
  //             child: Icon(FontAwesomeIcons.pizzaSlice, color: Colors.yellow.shade700),
  //           ),
  //           Padding(padding: EdgeInsets.symmetric(vertical: 2)),
  //           Expanded(child: Text(title))
  //         ],
  //       ),
  //     ),
  //     onTap: () => print('Category'),
  //   );
  // }

  Widget _buildRecentRestaurantItem(RestaurantElement restaurant) {
    final name = restaurant.location.name == null || restaurant.location.name == '' ? '${restaurant.name}' : '${restaurant.name} - ${restaurant.location.name}';
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 130,
              alignment: Alignment.center,
              // padding: EdgeInsets.all(10),
              child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, height: 130, image: restaurant.photoUrl.toString(), fit: BoxFit.cover, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35))) ,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.start, overflow: TextOverflow.ellipsis),
            )
            // Padding(padding: EdgeInsets.symmetric(vertical: 10))
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.shade400,
          //     blurRadius: 1.0,
          //     offset: Offset(2.0, 2.0)
          //   )
          // ],
          color: Colors.white
        ),
      ),
    onTap: () =>  Get.toNamed(Config.RESTAURANT_ROUTE, arguments: restaurant.toJson()),
    );
  }

  Widget _buildRestaurantItem(RestaurantElement restaurant) {
    final name = restaurant.location.name == null || restaurant.location.name == '' ? '${restaurant.name}' : '${restaurant.name} - ${restaurant.location.name}';
    return GestureDetector(
      onTap: () =>  Get.toNamed(Config.RESTAURANT_ROUTE, arguments: restaurant.toJson()),
      child: Container(
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.shade400,
          //     blurRadius: 1.0,
          //     offset: Offset(0.0, 3.0)
          //   )
          // ],
          color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 10),
            //   child: Text(restaurant.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(left: 10),
            //   child: Text(restaurant.location.name == null || restaurant.location.name == '' ? 'Test' : restaurant.location.name, style: TextStyle(fontSize: 15), textAlign: TextAlign.start),
            // ),
            // Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Hero(
                tag: restaurant.name, 
                child: Container(
                 height: 150,
                  alignment: Alignment.center,
                  // margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: Get.width,
                    child: restaurant.photoUrl != null ? FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: restaurant.photoUrl, fit: BoxFit.cover, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35))) 
                    : Container(child: Center(child: Center(child: Icon(Icons.image_not_supported_outlined, size: 60)))),
                  ),
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('(1.5 km away)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5))
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 10),
            //   child: Divider(color: Colors.grey.shade200, thickness: 5, indent: 30, endIndent: 30,),
            // ),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 10),
            //   height: Get.height * 0.25,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: restaurant.menuCategorized.first.menus.map((e) => _buildAvailableMenu(e, restaurantId: restaurant.id, restaurant: restaurant)).toList()
            //   ),
            // )
          ],
        ),
      ),
    );
  }
  
  // Widget _buildAvailableMenu(Menu menu, {int restaurantId, RestaurantElement restaurant}) {
  //   return GestureDetector(
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 20),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Flexible(
  //             child: Hero(
  //               tag: menu.name,
  //               child: Container(
  //                 width: 180,
  //                 height: 200,
  //                 child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: menu.image, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35))),
  //               ),
  //             )
  //           ),
  //           Container(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   margin: EdgeInsets.only(left: 10, right: 10, top: 10),
  //                   child: Text(menu.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
  //                 ),
  //                 Container(
  //                   alignment: Alignment.centerLeft,
  //                   margin: EdgeInsets.only(left: 10, right: 10),
  //                   child: Text('₱ ${menu.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 13), textAlign: TextAlign.start),
  //                 )
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //     onTap: () => Get.toNamed(Config.MENU_ROUTE, arguments: {
  //       'restaurant': restaurant.toJson(),
  //       'restaurantId': restaurantId, 
  //       'menu': menu.toJson(),
  //       'type': 'quick_order'
  //     })
  //   );
  // }

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