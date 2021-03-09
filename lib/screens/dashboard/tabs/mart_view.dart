import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/mart_dashboard_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class MartPage extends StatelessWidget {

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
            child: GetX<DashboardController>(
              builder: (_) {
                return IgnorePointer(
                  ignoring: _.isLoading.call(),
                  child: TextField(
                    controller: _.martSearchController,
                    onChanged: (mart) => _.searchMart(value: mart),
                    cursorColor: Colors.black,
                    style: TextStyle(color: Color(Config.SEARCH_TEXT_COLOR)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      hintText: tr('searchGrocery'),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _.martSearchController.clear();
                          _.searchMart();
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
        Flexible(
          child: GetX<DashboardController>(
            builder: (_) {
              return RefreshIndicator(
                onRefresh: () {
                  _.refreshToken();
                  return _.refreshCompleter.future;
                },
                child: _.martDashboard.call() == null ? Container(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        _.isLoading.call() ? CupertinoActivityIndicator() : Container(),
                        Text(_.martErrorMessage.call()),
                        _.hasMartError.call() ? RaisedButton(
                          color: Color(Config.LETSBEE_COLOR),
                          child: Text(tr('refresh')),
                          onPressed: () => _.refreshToken(),
                        ) : Container() 
                      ],
                    ),
                  ),
                ) : Container(
                  height: Get.height,
                  child: _scrollView()
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _scrollView() {
    return GetX<DashboardController>(
      builder: (_) {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _.martScrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _.recentMarts.call().isEmpty ? Container() : Container(
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
                          children: _.recentMarts.call().map((recentStore) => _buildRecentMart(recentStore)).toList(),
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
                  _.searchMarts.call().isNotEmpty ? 
                  Column(children: _.searchMarts.call().map((e) => _buildMart(e)).toList()) : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        _.isLoading.call() ? CupertinoActivityIndicator() : Container(),
                        Text(_.martErrorMessage.call()),
                        _.hasMartError.call() ? RaisedButton(
                          color: Color(Config.LETSBEE_COLOR),
                          child: Text(tr('refresh')),
                          onPressed: () => _.refreshToken(),
                        ) : Container() 
                      ],
                    ),
                  )
                ],  
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentMart(MartStores mart) {
    final name = mart.location.name == null || mart.location.name == '' ? '${mart.name}' : '${mart.name} - ${mart.location.name}';
    return GestureDetector(
      onTap: () =>  Get.toNamed(Config.MART_ROUTE, arguments: {'id': mart.id, 'mart': mart.toJson()}),
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
                child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, height: 130, width: Get.width, image: mart.photoUrl.toString(), fit: BoxFit.cover, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Container(height: 130, child: Icon(Icons.image_not_supported_outlined, size: 35)))) ,
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
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: Container(
                  height: 170,
                  alignment: Alignment.center,
                  child: ClipRRect(
                    child: mart.photoUrl != null ? FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, width: Get.width, image: mart.photoUrl, fit: BoxFit.cover, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35))) 
                      : Container(child: Center(child: Center(child: Icon(Icons.image_not_supported_outlined, size: 60)))),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                  ),
                ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 5, right: 5),
              child: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
            ),
            // Container(
            //   padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
            //   child: Text('(5.2 km away)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10), overflow: TextOverflow.ellipsis),
            // )
          ],
        ),
      ),
    );
  }
}