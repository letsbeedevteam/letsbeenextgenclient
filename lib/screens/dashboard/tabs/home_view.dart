import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/customWidgets.dart';
import 'package:letsbeeclient/models/restaurant_dashboard_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class HomePage extends GetView<DashboardController> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        GestureDetector(
          onTap: () => _searchBottomsheet(),
          child: SizedBox(
            height: 40,
            width: Get.width,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white
              ),
              child: Text(tr('searchFood'), style: TextStyle(color: Color(Config.SEARCH_TEXT_COLOR), fontSize: 14))
            ),
          ),
        ),
        Obx(() {
          return Flexible(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                RefreshIndicator(
                  onRefresh: () {
                    controller.refreshToken(page: 0);
                    return controller.refreshCompleter.future;
                  },
                  child: controller.searchRestaurants.call().isEmpty ? Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                          controller.isLoading.call() ? CupertinoActivityIndicator() : Container(),
                          Text(controller.restaurantErrorMessage.call()),
                          controller.hasRestaurantError.call() ? RaisedButton(
                            color: Color(Config.LETSBEE_COLOR),
                            child: Text(tr('refresh')),
                            onPressed: () => controller.refreshToken(page: 0),
                          ) : Container() 
                        ],
                      ),
                    ),
                  ) : Container(
                    height: Get.height,
                    child: _scrollView()
                  )
                ),
                controller.isSelectedLocation.call() ? Container(
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
                      Text(tr('loadingLocation'), style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ) : Container()
              ],
            )
          );
        })
      ],
    );
  }

  Widget _scrollView() {
    final restaurants = controller.searchRestaurants.call().where((data) => data.name.toLowerCase().contains(controller.searchRestaurantValue.trim().toLowerCase()) || data.category.toLowerCase().contains(controller.searchRestaurantValue.trim().toLowerCase()));
    return IgnorePointer(
      ignoring: controller.isSelectedLocation.call(),
      child: SingleChildScrollView(
        controller: controller.foodScrollController,
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
            controller.searchMartValue.call().trim().isEmpty ? controller.recentRestaurants.call().isEmpty ? Container() : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                    child: Text(tr('recentRestaurants'), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15), textAlign: TextAlign.start),
                  ),
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: controller.recentRestaurants.call().map((data) => _buildRecentRestaurantItem(data)).toList(),
                      )
                    ),
                  ),
                ],
              ),
            ) : Container(),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
              child: Text(tr('allRestaurants'), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15), textAlign: TextAlign.start),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            restaurants.isNotEmpty ? Column(children: restaurants.map((e) => _buildRestaurantItem(e)).toList()) 
            : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  controller.isLoading.call() ? CupertinoActivityIndicator() : Container(),
                  Text(controller.restaurantErrorMessage.call()),
                  controller.hasMartError.call() ? RaisedButton(
                    color: Color(Config.LETSBEE_COLOR),
                    child: Text(tr('refresh')),
                    onPressed: () => controller.refreshToken(page: 0),
                  ) : Container() 
                ],
              ),
            ),
            controller.isRestaurantLoadingScroll.call() ? _loadingPage() : Container()
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

  Widget _loadingPage() {
    return Container(
      width: Get.width,
      margin: EdgeInsets.only(bottom: 20),
      child: CupertinoActivityIndicator(),
    );
  }

  Widget _buildRecentRestaurantItem(RestaurantStores restaurant) {
    final name = restaurant.location.name == null || restaurant.location.name == '' ? '${restaurant.name}' : '${restaurant.name} - ${restaurant.location.name}';
    return GestureDetector(
      onTap: () =>  Get.toNamed(Config.RESTAURANT_ROUTE, arguments: {'id': restaurant.id, 'restaurant': restaurant.toJson()}),
        child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 5),
        padding: EdgeInsets.all(10),
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: Container(
                margin: EdgeInsets.only(bottom: 5),
                alignment: Alignment.center,
                child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, height: 130, width: Get.width, image: restaurant?.photoUrl, fit: BoxFit.cover, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) {
                  return error.toString().contains(restaurant?.photoUrl) ? Center(child: Container(height: 130, child: Icon(Icons.image_not_supported_outlined, size: 35))) : FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, width: Get.width, image: restaurant?.photoUrl, fit: BoxFit.cover, placeholderScale: 5);
                }) ,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.start, overflow: TextOverflow.ellipsis),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 3)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OneRating(),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(Config.WHITE)
                        ),
                        child: Row(
                          children: [
                            Image.asset(Config.PNG_PATH + 'address.png', height: 15, width: 15, color: Colors.black),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                            Text('${restaurant.distance?.toStringAsFixed(2)}KM', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(Config.WHITE)
                        ),
                        child: Row(
                          children: [
                            Image.asset(Config.PNG_PATH + 'delivery-time.png', height: 15, width: 15, color: Colors.black),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                            Text("37'", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white
        ),
      ),
    );
  }

  Widget _buildRestaurantItem(RestaurantStores restaurant) {
    final name = restaurant.location.name == null || restaurant.location.name == '' ? '${restaurant.name}' : '${restaurant.name} - ${restaurant.location.name}';
    return GestureDetector(
      onTap: () => Get.toNamed(Config.RESTAURANT_ROUTE, arguments: {'id': restaurant.id, 'restaurant': restaurant.toJson()}),
      child: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: SizedBox(
                    width: Get.width,
                    height: 180,
                    child: FadeInImage.assetNetwork(
                      placeholder: cupertinoActivityIndicatorSmall, 
                      width: Get.width, 
                      image: restaurant?.photoUrl, 
                      fit: BoxFit.cover, 
                      placeholderScale: 5, 
                      imageErrorBuilder: (context, error, stackTrace) {
                      return error.toString().contains(restaurant?.photoUrl) ? Center(
                        child: Container(
                          height: 130, 
                          child: Icon(Icons.image_not_supported_outlined, size: 35))) : FadeInImage.assetNetwork(
                          placeholder: cupertinoActivityIndicatorSmall, 
                          width: Get.width, 
                          image: restaurant?.photoUrl, 
                          fit: BoxFit.cover,
                          placeholderScale: 5
                      );
                    }) 
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 5, right: 5),
              child: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 3)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OneRating(),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(Config.WHITE)
                        ),
                        child: Row(
                          children: [
                            Image.asset(Config.PNG_PATH + 'address.png', height: 15, width: 15, color: Colors.black),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                            Text('${restaurant.distance?.toStringAsFixed(2)}KM', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(Config.WHITE)
                        ),
                        child: Row(
                          children: [
                            Image.asset(Config.PNG_PATH + 'delivery-time.png', height: 15, width: 15, color: Colors.black),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                            Text("37'", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

   Widget _searchField() {
    return SizedBox(
      height: 40,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Obx(() {
          return IgnorePointer(
            ignoring: controller.isLoading.call(),
            child: TextField(
              controller: controller.restaurantSearchController,
              // onChanged: (value) => controller.searchRestaurant(restaurant: value),
              cursorColor: Colors.black,
              autofocus: true,
              style: TextStyle(color: Color(Config.SEARCH_TEXT_COLOR)),
              textInputAction: TextInputAction.search,
              onSubmitted: controller.searchRestaurant,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10),
                hintText: tr('searchFood'),
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.restaurantSearchController.clear();
                    // controller.searchRestaurantValue('');
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
        })
      ),
    );
  }

  Widget _buildSearchList() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
          Image.asset(Config.PNG_PATH + 'search_store.png', height: 15, width: 15),
          Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
          Text('Bongane', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  Widget _buildSearchRestaurant() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Color(Config.WHITE),
      ),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          _searchField(),
          Container(height: 1, margin: EdgeInsets.symmetric(vertical: 5), color: Colors.grey.shade200),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      _buildSearchList(),
                      _buildSearchList(),
                      _buildSearchList(),
                    ],
                  ),
                  Container(height: 1, margin: EdgeInsets.symmetric(vertical: 5), color: Colors.grey.shade200),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _searchBottomsheet() {
    controller.restaurantSearchController.clear();
    Get.bottomSheet(
      Column(
        children: [
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                color: Colors.transparent,
                width: Get.width
              ),
            ),
          ),
          Flexible(
            flex: 5,
            child: _buildSearchRestaurant(),
          )
        ],
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
    );
  }
}