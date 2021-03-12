import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/customWidgets.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/restaurant_dashboard_response.dart';
import 'package:letsbeeclient/models/search_history.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class RestaurantChildPage extends GetView<DashboardController> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        Container(
          height: 40,
          width: Get.width,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: RaisedButton(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(() => Text(controller.isOnSearch.call() ? controller.restaurantSearchController.call().text.trim() : tr('searchFood'), style: TextStyle(color: Color(Config.SEARCH_TEXT_COLOR), fontSize: 14))),
                ),
                GestureDetector(
                  onTap: () => controller.isOnSearch(false),
                  child: Icon(Icons.clear, color: Color(Config.LETSBEE_COLOR)),
                )
              ],
            ),
            onPressed: () => _searchBottomsheet(),
          ),
        ),
        Flexible(
          child: RefreshIndicator(
            onRefresh: () {
              controller.fetchSearchRestaurant(controller.searchRestaurantValue.trim());
              return controller.refreshCompleter.future;
            },
            child: Obx(() {
              return controller.searchRestaurants.call().isEmpty ? Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      controller.isSearchRestaurantLoading.call() ? CupertinoActivityIndicator() : Container(),
                      Text(controller.searchRestaurantErrorMessage.call()),
                      controller.hasRestaurantError.call() ? RaisedButton(
                        color: Color(Config.LETSBEE_COLOR),
                        child: Text(tr('refresh')),
                        onPressed: () => controller.fetchSearchRestaurant(controller.searchRestaurantValue.trim()),
                      ) : Container() 
                    ],
                  ),
                ),
              ) : Container(
                height: Get.height,
                child: _scrollView()
              );
            })
          ),
        )
      ],
    ); 
  }

  Widget _scrollView() {
    final searchRestaurant = controller.searchRestaurants.call();
    final restaurant = searchRestaurant.call().length == 1 ? '${tr('restaurant').capitalizeFirst}' : '${tr('restaurant')}s'.capitalizeFirst;
    final title = '${searchRestaurant.call().length} $restaurant ${tr('with')} "${controller.restaurantSearchController.call().text.trim().capitalizeFirst}"';
    return IgnorePointer(
      ignoring: controller.isSelectedLocation.call(),
      child: SingleChildScrollView(
        controller: controller.foodScrollController,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
              child: Text(title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15), textAlign: TextAlign.start),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            searchRestaurant.isNotEmpty ? Column(children: searchRestaurant.map((e) => _buildRestaurantItem(e)).toList()) 
            : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  controller.isSearchRestaurantLoading.call() ? CupertinoActivityIndicator() : Container(),
                  Text(controller.searchRestaurantErrorMessage.call()),
                  controller.hasRestaurantError.call() ? RaisedButton(
                    color: Color(Config.LETSBEE_COLOR),
                    child: Text(tr('refresh')),
                    onPressed: () => controller.fetchSearchRestaurant(controller.searchRestaurantValue.trim()),
                  ) : Container() 
                ],
              ),
            ),
          ],
        )
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
          return TextField(
            controller: controller.restaurantSearchController.call(),
            onChanged: (value) => controller.searchRestaurantValue(value),
            cursorColor: Colors.black,
            autofocus: true,
            style: TextStyle(color: Color(Config.SEARCH_TEXT_COLOR)),
            enableSuggestions: false,
            textInputAction: TextInputAction.search,
            onSubmitted: controller.fetchSearchRestaurant,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10),
              hintText: tr('searchFood'),
              suffixIcon: IconButton(
                onPressed: () {
                  controller.restaurantSearchController.call().clear();
                  controller.searchRestaurantValue('');
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
          );
        })
      ),
    );
  }

  Widget _buildSearchList(SearchHistory data) {
    return GestureDetector(
      onTap: () {
        dismissKeyboard(Get.context);
        controller.fetchSearchRestaurant(data.name);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Color(Config.WHITE)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
            Image.asset(Config.PNG_PATH + 'recent_search.png', height: 15, width: 15),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
            Text(data.name, style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)) 
          ],
        ),
      ),
    );
  }

  Widget _buildSearchRestaurant() {
    final searchHistory = controller.searchHistoryList.call().values.where((data) => data.type == Config.RESTAURANT).toList();
    final matchSuggestion = searchHistory.where((data) => data.name.contains(controller.searchRestaurantValue.call().trim()));
    searchHistory.sort((b, a) => a.date.compareTo(b.date));
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Color(Config.WHITE),
      ),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          _searchField(),
          Container(height: 1, margin: EdgeInsets.symmetric(vertical: 8), color: Colors.grey.shade200),
          Flexible(
            child: SingleChildScrollView(
              child:Column(
                children: [
                  searchHistory.isEmpty ? Container(
                    child: Text(controller.searchRestaurantErrorMessage.call(), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                  ) : controller.searchRestaurantValue.trim().isEmpty ? Column(
                    children: searchHistory.take(5).map((data) => _buildSearchList(data)).toList(),
                  ) : Column(
                    children: matchSuggestion.map((data) => _buildSearchList(data)).toList(),
                  ),
                  matchSuggestion.isEmpty ? Container() : Container(height: 1, margin: EdgeInsets.symmetric(vertical: 5), color: Colors.grey.shade200),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () => controller.fetchSearchRestaurant(controller.searchRestaurantValue.call().trim()),
                          child: controller.searchRestaurantValue.call().isEmpty ? Container() : Container(
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Text('${tr('searchFor')} "${controller.searchRestaurantValue.call()}"', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                      matchSuggestion.isEmpty ? Container() :  Expanded(
                        child: GestureDetector(
                          onTap: () => controller.clearSearchHistory(type: Config.RESTAURANT),
                          child: Container(
                            width: Get.width,
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            alignment: Alignment.centerRight,
                            child: Text('Clear All', style: TextStyle(fontSize: 15, color: Colors.red, fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }

  _searchBottomsheet() {
    controller.searchRestaurantErrorMessage('');
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
            flex: 4,
            child: Obx(() => _buildSearchRestaurant()),
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