import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/customWidgets.dart';
import 'package:letsbeeclient/models/mart_dashboard_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class MartPage extends GetView<DashboardController> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        SizedBox(
          height: 40,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Obx(() {
              return IgnorePointer(
                ignoring: controller.isLoading.call(),
                child: TextField(
                  controller: controller.martSearchController,
                  onChanged: (value) => controller.searchMart(mart: value),
                  cursorColor: Colors.black,
                  style: TextStyle(color: Color(Config.SEARCH_TEXT_COLOR)),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    hintText: tr('searchGrocery'),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.martSearchController.clear();
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
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              );
            })
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
                  child: controller.searchMarts.call().isEmpty ? Container(
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
    final marts = controller.searchMarts.call().where((data) => data.name.toLowerCase().contains(controller.searchMartValue.trim().toLowerCase()) || data.category.toLowerCase().contains(controller.searchMartValue.trim().toLowerCase()));
    return IgnorePointer(
      ignoring: controller.isSelectedLocation.call(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: controller.martScrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.searchMartValue.call().trim().isEmpty ? controller.recentMarts.call().isEmpty ? Container() : Container(
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
                        children: controller.recentMarts.call().map((recentStore) => _buildRecentMart(recentStore)).toList(),
                      ),
                    ),
                  )
                ],  
              ),
            ) : Container(),
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
                Column(children: marts.map((e) => _buildMart(e)).toList()) : Center(
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

  Widget _buildRecentMart(MartStores mart) {
    final name = mart.location.name == null || mart.location.name == '' ? '${mart.name}' : '${mart.name} - ${mart.location.name}';
    return GestureDetector(
      onTap: () =>  Get.toNamed(Config.MART_ROUTE, arguments: {'id': mart.id, 'mart': mart.toJson()}),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white
        ),
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
}