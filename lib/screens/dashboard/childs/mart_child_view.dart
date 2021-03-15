import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/customWidgets.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/mart_dashboard_response.dart';
import 'package:letsbeeclient/models/search_history.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class MartChildPage extends GetView<DashboardController> {

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
                  child: Obx(() => Text(controller.isOnSearch.call() ? controller.martSearchController.call().text.trim() : tr('searchGrocery'), style: TextStyle(color: Color(Config.SEARCH_TEXT_COLOR), fontSize: 14))),
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
        Container(
          height: 1,
          margin: EdgeInsets.only(top: 10),
          color: Colors.grey.shade200
        ),
        Flexible(
          child: RefreshIndicator(
            onRefresh: () {
              controller.fetchSearchMart(controller.searchMartValue.trim());
              return controller.refreshCompleter.future;
            },
            child: Obx(() {
              return controller.searchMarts.call().isEmpty ? Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      controller.isSearchMartLoading.call() ? CupertinoActivityIndicator() : Container(),
                      Text(controller.searchMartErrorMessage.call()),
                      controller.hasMartError.call() ? RaisedButton(
                        color: Color(Config.LETSBEE_COLOR),
                        child: Text(tr('refresh')),
                        onPressed: () => controller.fetchSearchMart(controller.searchMartValue.trim()),
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
    final searchMart = controller.searchMarts.call();
    final mart = searchMart.call().length == 1 ? '${tr('shop').capitalizeFirst}' : '${tr('shop')}s'.capitalizeFirst;
    final title = '${searchMart.call().length} $mart ${tr('with')} "${controller.martSearchController.call().text.trim().capitalizeFirst}"';
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
            searchMart.isNotEmpty ? Column(children: searchMart.map((e) => _buildMart(e)).toList()) 
            : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  controller.isSearchMartLoading.call() ? CupertinoActivityIndicator() : Container(),
                  Text(controller.searchMartErrorMessage.call()),
                  controller.hasMartError.call() ? RaisedButton(
                    color: Color(Config.LETSBEE_COLOR),
                    child: Text(tr('refresh')),
                    onPressed: () => controller.fetchSearchMart(controller.searchMartValue.trim()),
                  ) : Container() 
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget _buildMart(MartStores mart) {
    final name = mart.location.name == null || mart.location.name == '' ? '${mart.name}' : '${mart.name} - ${mart.location.name}';
    return GestureDetector(
      onTap: () => Get.toNamed(Config.MART_ROUTE, arguments: {'id': mart.id, 'mart': mart.toJson()}),
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
                    child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, width: Get.width, image: mart?.photoUrl, fit: BoxFit.cover, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) {
                      return error.toString().contains(mart?.photoUrl) ? Center(child: Container(height: 130, child: Icon(Icons.image_not_supported_outlined, size: 35))) : FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, width: Get.width, image: mart?.photoUrl, fit: BoxFit.cover, placeholderScale: 5);
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
                            Text('${mart.distance?.toStringAsFixed(2)}KM', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
            controller: controller.martSearchController.call(),
            onChanged: (value) => controller.searchMartValue(value),
            cursorColor: Colors.black,
            autofocus: true,
            style: TextStyle(color: Color(Config.SEARCH_TEXT_COLOR)),
            textInputAction: TextInputAction.search,
            onSubmitted: controller.fetchSearchMart,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10),
              hintText: tr('searchGrocery'),
              suffixIcon: IconButton(
                onPressed: () {
                  controller.martSearchController.call().clear();
                  controller.searchMartValue('');
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
                borderSide: BorderSide.none,
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
          controller.fetchSearchMart(data.name);
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
  
  Widget _buildSearchMart() {
    final searchHistory = controller.searchHistoryList.call().values.where((data) => data.type == Config.MART).toList();
    final matchSuggestion = searchHistory.where((data) => data.name.contains(controller.searchMartValue.call().trim()));
    searchHistory.sort((b, a) => a.date.compareTo(b.date));
    return Container(
      decoration: BoxDecoration(
        color: Color(Config.WHITE),
      ),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Row(
            children: [
              IconButton(icon: Icon(Icons.chevron_left), onPressed: () => Get.back(closeOverlays: true)),
              Expanded(child: _searchField())
            ],
          ),
          Container(height: 1, margin: EdgeInsets.symmetric(vertical: 8), color: Colors.grey.shade200),
          Flexible(
            child: SingleChildScrollView(
              child:Column(
                children: [
                  controller.searchMartValue.trim().isEmpty ? Column(
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
                          onTap: () => controller.fetchSearchMart(controller.searchMartValue.call().trim()),
                          child: controller.searchMartValue.call().isEmpty ? Container() : Container(
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Text('${tr('searchFor')} "${controller.searchMartValue.call()}"', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                      matchSuggestion.isEmpty ? Container() :  Expanded(
                        child: GestureDetector(
                          onTap: () => controller.clearSearchHistory(type: Config.MART),
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
    controller.searchMartErrorMessage('');
    Get.bottomSheet(
      Obx(() => _buildSearchMart()),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
    );
  }
}