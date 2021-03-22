import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/mart_dashboard_response.dart';
import 'package:letsbeeclient/models/search_history.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:intl/intl.dart' as intl;

class MartPage extends GetView<DashboardController> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        RefreshIndicator(
          onRefresh: () {
            controller.refreshToken(page: 0);
            return controller.refreshCompleter.future;
          },
          child: Obx(() {
            return controller.marts.call().isEmpty ? Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    controller.isLoading.call() ? CupertinoActivityIndicator() : Container(),
                    Text(controller.martErrorMessage.call()),
                    controller.hasMartError.call() ? RaisedButton(
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
            );
          })
        ),
        Obx(() {
          return controller.isSelectedLocation.call() ? Container(
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
          ) : Container();
        })
      ],
    );
  }

  Widget _scrollView() {
    final marts = controller.marts.call();
    return IgnorePointer(
      ignoring: controller.isSelectedLocation.call(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: controller.martScrollController,
        child: Column(
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
                  child: Text(tr('searchGrocery'), style: TextStyle(color: Color(Config.SEARCH_TEXT_COLOR), fontSize: 14))
                ),
              ),
            ),
            controller.recentMarts.call().isEmpty ? Container() : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    child: Text(tr('recentShops'), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15), textAlign: TextAlign.start)
                  ),
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: controller.recentMarts.call().map((e) => _buildRecentMartItem(e)).toList(),
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
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Text(tr('allShops'), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15), textAlign: TextAlign.start)
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                marts.isNotEmpty ? 
                Column(children: marts.map((e) => _openCloseStore(mart: e)).toList()) : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      controller.isLoading.call() ? CupertinoActivityIndicator() : Container(),
                      Text(controller.martErrorMessage.call()),
                      controller.hasMartError.call() ? RaisedButton(
                        color: Color(Config.LETSBEE_COLOR),
                        child: Text(tr('refresh')),
                        onPressed: () => controller.refreshToken(page: 0),
                      ) : Container() 
                    ],
                  ),
                ),
                controller.isMartLoadingScroll.call() ? _loadingPage() : Container()
              ],  
            )
          ],
        ),
      ),
    );
  }

  Widget _loadingPage() {
    return Container(
      width: Get.width,
      margin: EdgeInsets.only(bottom: 20),
      child: CupertinoActivityIndicator(),
    );
  }

  Widget _openCloseStore({MartStores mart}) {
    final now = DateTime.now();
    final day = intl.DateFormat('EEEE').format(now);
   
    switch (day) {
      case 'Monday': {
        final closingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.monday.closingTime));
        final openingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.monday.openingTime));
        if (mart.stature == 'temporary-closed' || mart.stature == 'closed') {
          return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', stature:  mart.stature, status: 'closed');
        } else {
          if( now.hour >= openingTime.tod().hour && now.hour < closingTime.tod().hour) {
            return _buildMartItem(mart: mart);
          } else {
            return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', status: 'closed');
          }
        }
      }
      break;
      case 'Tuesday': {
        final closingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.tuesday.closingTime));
        final openingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.tuesday.openingTime));
        if (mart.stature == 'temporary-closed' || mart.stature == 'closed') {
          return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', stature:  mart.stature, status: 'closed');
        } else {
          if( now.hour >= openingTime.tod().hour && now.hour < closingTime.tod().hour) {
            return _buildMartItem(mart: mart);
          } else {
            return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', status: 'closed');
          }
        }
      }
      break;
      case 'Wednesday': {
        final closingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.wednesday.closingTime));
        final openingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.wednesday.openingTime));
        if (mart.stature == 'temporary-closed' || mart.stature == 'closed') {
          return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', stature:  mart.stature, status: 'closed');
        } else {
          if( now.hour >= openingTime.tod().hour && now.hour < closingTime.tod().hour) {
            return _buildMartItem(mart: mart);
          } else {
            return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', status: 'closed');
          }
        }
      }
      break;
      case 'Thursday': {
        final closingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.thursday.closingTime));
        final openingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.thursday.openingTime));
        if (mart.stature == 'temporary-closed' || mart.stature == 'closed') {
          return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', stature:  mart.stature, status: 'closed');
        } else {
          if( now.hour >= openingTime.tod().hour && now.hour < closingTime.tod().hour) {
            return _buildMartItem(mart: mart);
          } else {
            return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', status: 'closed');
          }
        }
      }
      break;
      case 'Friday': {

        final closingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.friday.closingTime));
        final openingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.friday.openingTime));
        if (mart.stature == 'temporary-closed' || mart.stature == 'closed') {
          return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', stature:  mart.stature, status: 'closed');
        } else {
          if( now.hour >= openingTime.tod().hour && now.hour < closingTime.tod().hour) {
            return _buildMartItem(mart: mart);
          } else {
            return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', status: 'closed');
          }
        }
      }
      break;
      case 'Saturday': {
        final closingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.saturday.closingTime));
        final openingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.saturday.openingTime));
        if (mart.stature == 'temporary-closed' || mart.stature == 'closed') {
          return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', stature:  mart.stature, status: 'closed');
        } else {
          if( now.hour >= openingTime.tod().hour && now.hour < closingTime.tod().hour) {
            return _buildMartItem(mart: mart);
          } else {
            return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', status: 'closed');
          }
        }
      }
      break;
      case 'Sunday': {
        final closingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.sunday.closingTime));
        final openingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.sunday.openingTime));
        if (mart.stature == 'temporary-closed' || mart.stature == 'closed') {
          return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', stature:  mart.stature, status: 'closed');
        } else {
          if( now.hour >= openingTime.tod().hour && now.hour < closingTime.tod().hour) {
            return _buildMartItem(mart: mart);
          } else {
            return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', status: 'closed');
          }
        }
      }
      break;
      default: {
        final closingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.monday.closingTime));
        final openingTime = intl.DateFormat.jm().format(intl.DateFormat("hh:mm:ss").parse(mart.workingDays.monday.openingTime));
        if (mart.stature == 'temporary-closed' || mart.stature == 'closed') {
          return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', stature:  mart.stature, status: 'closed');
        } else {
          if( now.hour >= openingTime.tod().hour && now.hour < closingTime.tod().hour) {
            return _buildMartItem(mart: mart);
          } else {
            return _buildMartItem(mart: mart, storeTime: '$openingTime - $closingTime', status: 'closed');
          }
        }
      }
    }
  }

  Widget _buildRecentMartItem(MartStores mart) {
    final name = mart.location.name == null || mart.location.name == '' ? '${mart.name}' : '${mart.name} - ${mart.location.name}';
    return GestureDetector(
      onTap: () =>  Get.toNamed(Config.MART_ROUTE, arguments: {'id': mart.id, 'mart': mart.toJson(), 'status': 'open'}),
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
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
                child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, height: 130, width: Get.width, image: mart?.photoUrl, fit: BoxFit.cover, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) {
                  return error.toString().contains(mart?.photoUrl) ? Center(child: Container(height: 130, child: Icon(Icons.image_not_supported_outlined, size: 35))) : FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, width: Get.width, image: mart?.photoUrl, fit: BoxFit.cover, placeholderScale: 5);
                }) ,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.start, overflow: TextOverflow.ellipsis),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 3)),
            Row(
              children: [
                Spacer(),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white
        ),
      ),
    );
  }

  Widget _buildMartItem({MartStores mart,  String storeTime, String stature, String status = 'open'}) {
    final name = mart.location.name == null || mart.location.name == '' ? '${mart.name}' : '${mart.name} - ${mart.location.name}';
    return GestureDetector(
      onTap: () => Get.toNamed(Config.MART_ROUTE, arguments: {'id': mart.id, 'mart': mart.toJson(), 'status': status}),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: status == 'closed' ? Color(0xFFFBFBFC).withOpacity(0.8) : Colors.white,
        ),
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: SizedBox(
                  width: Get.width,
                  height: 180,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      FadeInImage.assetNetwork(
                        placeholder: cupertinoActivityIndicatorSmall, 
                        width: Get.width, 
                        image: mart?.photoUrl, 
                        fit: BoxFit.cover, 
                        placeholderScale: 5, 
                        imageErrorBuilder: (context, error, stackTrace) {
                        return error.toString().contains(mart?.photoUrl) ? Center(
                          child: Container(
                            height: 130, 
                            child: Icon(Icons.image_not_supported_outlined, size: 35))) : FadeInImage.assetNetwork(
                            placeholder: cupertinoActivityIndicatorSmall, 
                            width: Get.width, 
                            image: mart?.photoUrl, 
                            fit: BoxFit.cover,
                            placeholderScale: 5
                        );
                      }),
                      status == 'closed' ? Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFBFBFC).withOpacity(0.8)
                        ),
                      ) : Container()
                    ],
                  ) 
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: status != 'closed' ? Colors.black : Colors.grey), overflow: TextOverflow.ellipsis),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 3)),
            Row(
              children: [
                Spacer(),
                status == 'closed' ? Container(
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                    color: Color(Config.LETSBEE_COLOR),
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(8), topLeft: Radius.circular(8)),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Text('Store Hours $storeTime', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)),
                ) : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
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
                    ),
                  ),
                ),
              ],
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
                onPressed: () => controller.martSearchController.call().clear(),
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
      onTap: () => controller.fetchSearchMart(data.name),
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
    controller.martSearchController.call().clear();
    controller.searchMartValue('');
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