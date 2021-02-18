import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/restaurant_dashboard_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: GetX<DashboardController>(
              builder: (_) {
                return IgnorePointer(
                  ignoring: _.isLoading.call(),
                  child: TextField(
                    controller: _.restaurantSearchController,
                    onChanged: (restaurant) => _.searchRestaurant(value: restaurant),
                    cursorColor: Colors.black,
                    style: TextStyle(color: Color(Config.SEARCH_TEXT_COLOR)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      hintText: 'Search for food or restaurant here',
                      suffixIcon: IconButton(
                        onPressed: () {
                          _.restaurantSearchController.clear();
                          _.searchRestaurant();
                        },
                        icon: Icon(Icons.clear),
                      ),
                      hintStyle: TextStyle(fontSize: 14),
                      fillColor: Colors.white,
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
                      _.refreshToken('Loading Restaurants...');
                      return _.refreshCompleter.future;
                    },
                    child: _.restaurantDashboard.call() == null ? Container(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                            _.isLoading.call() ? CupertinoActivityIndicator() : Container(),
                            Text(_.restaurantErrorMessage.call()),
                            _.hasRestaurantError.call() ? RaisedButton(
                              color: Color(Config.LETSBEE_COLOR),
                              child: Text('Refresh'),
                              onPressed: () => _.refreshToken('Loading Restaurants...'),
                            ) : Container() 
                          ],
                        ),
                      ),
                    ) : Container(
                      height: Get.height,
                      child: _scrollView(_)
                    )
                  ),
                  _.isSelectedLocation.call() ? Container(
                    margin: EdgeInsets.only(top: 70),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(Config.LETSBEE_COLOR)
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

  Widget _scrollView(DashboardController _) {
    return IgnorePointer(
      ignoring: _.isSelectedLocation.call(),
      child: SingleChildScrollView(
        controller: _.foodScrollController,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   margin: EdgeInsets.only(top: 10),
            //   height: 80,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       _buildCategory(title: 'Filipino'),
            //       _buildCategory(title: 'Korean'),
            //       _buildCategory(title: 'Protein'),
            //       _buildCategory(title: 'Chinese'),
            //       _buildCategory(title: 'Vietnamese'),
            //     ]
            //   ),
            // ),
            _.recentRestaurants.call().isNotEmpty ? Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                    child: Text('Recent Restaurants', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15), textAlign: TextAlign.start),
                  ),
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: _.recentRestaurants.call().map((data) => _buildRecentRestaurantItem(data)).toList(),
                      )
                    ),
                  ),
                ],
              ),
            ) : Container(),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
              child: Text('All Restaurants', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15), textAlign: TextAlign.start),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            _.searchRestaurants.call().isNotEmpty ? 
            Column(children: _.searchRestaurants.call().map((e) => _buildRestaurantItem(e)).toList()) : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  _.isLoading.call() ? CupertinoActivityIndicator() : Container(),
                  Text(_.restaurantErrorMessage.call()),
                  _.hasMartError.call() ? RaisedButton(
                    color: Color(Config.LETSBEE_COLOR),
                    child: Text('Refresh'),
                    onPressed: () => _.refreshToken('Loading Restaurants...'),
                  ) : Container() 
                ],
              ),
            )
          ],
        )
      ),
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
  //             child: Image.asset(Config.PNG_PATH + 'fil.png', height: 50, width: 50),
  //           ),
  //           Padding(padding: EdgeInsets.symmetric(vertical: 2)),
  //           Expanded(child: Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)))
  //         ],
  //       ),
  //     ),
  //     onTap: () => print('Category'),
  //   );
  // }

  Widget _buildRecentRestaurantItem(RestaurantStores restaurant) {
    final name = restaurant.location.name == null || restaurant.location.name == '' ? '${restaurant.name}' : '${restaurant.name} - ${restaurant.location.name}';
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 5),
          padding: EdgeInsets.all(10),
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  alignment: Alignment.center,
                  child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, height: 130, width: Get.width, image: restaurant.photoUrl.toString(), fit: BoxFit.cover, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Container(height: 130, child: Icon(Icons.image_not_supported_outlined, size: 35)))) ,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.start, overflow: TextOverflow.ellipsis),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 10),
              //   child: Text('(1.5 km away)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
              // ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5))
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white
          ),
        ),
      onTap: () =>  Get.toNamed(Config.RESTAURANT_ROUTE, arguments: {'id': restaurant.id}),
    );
  }

  Widget _buildRestaurantItem(RestaurantStores restaurant) {
    final name = restaurant.location.name == null || restaurant.location.name == '' ? '${restaurant.name}' : '${restaurant.name} - ${restaurant.location.name}';
    return GestureDetector(
      onTap: () => Get.toNamed(Config.RESTAURANT_ROUTE, arguments: {'id': restaurant.id}),
      child: Container(
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                height: 170,
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: SizedBox(
                    width: Get.width,
                    child: restaurant.photoUrl != null ? FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, width: Get.width, image: restaurant.photoUrl, fit: BoxFit.cover, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35))) 
                    : Container(child: Center(child: Center(child: Icon(Icons.image_not_supported_outlined, size: 60)))),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5))
          ],
        ),
      ),
    );
  }
}