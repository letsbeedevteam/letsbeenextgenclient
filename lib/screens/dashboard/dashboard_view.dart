import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/activeOrderResponse.dart';
import 'package:letsbeeclient/models/getAddressResponse.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class DashboardPage extends GetView<DashboardController> {
  
  @override
  Widget build(BuildContext context) {
    return GetX<DashboardController>(
      builder: (_) {
        final currentIndex = _.pageIndex.call();
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                    AnimatedContainer(
                    height: _.isHideAppBar.call() ? 0 : Get.height / 10,
                    duration: Duration(seconds: 2),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      titleSpacing: 0.0,
                      centerTitle: false,
                      leading: IconButton(icon: Icon(Icons.gps_fixed, size: 25), onPressed: () => _.showLocationSheet(true), highlightColor: Colors.transparent, splashColor: Colors.transparent),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('DELIVER TO: ', style: TextStyle(fontSize: 13, color: Color(Config.LETSBEE_COLOR).withOpacity(1.0), fontWeight: FontWeight.normal)),
                              Text(_.userCurrentNameOfLocation.call() == null ? 'Home' : _.userCurrentNameOfLocation.call(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(Config.LETSBEE_COLOR).withOpacity(1.0))),
                            ],
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                          Text(_.userCurrentAddress.call(), style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      // actions: [
                      //   IconButton(icon: Image.asset(Config.PNG_PATH + 'account.png', gaplessPlayback: true, height: 25, width: 25), onPressed: () => Get.toNamed(Config.CART_ROUTE), highlightColor: Colors.transparent, splashColor: Colors.transparent)
                      // ],
                    ),
                  ),
                  Container(
                    child:  _.isOpenLocationSheet.call() ? _topSheet(_) : Container(),
                    width: Get.width, 
                    color: Colors.white
                  ),
                ],
              ),
              Flexible(
                child: Column(
                  children: [
                    Container(
                      margin: _.isHideAppBar.call() ? EdgeInsets.zero : EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 5),
                      color: Colors.black,
                      height: _.isHideAppBar.call() ? 0 : 5,
                    ),
                    Expanded(
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _.pageController,
                        onPageChanged: (index) {
                          _.pageIndex(index);
                          _.showLocationSheet(false);
                        },
                        children: _.widgets,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          floatingActionButton: Badge(
            badgeContent: _.activeOrders.call() == null ? null : Text(_.activeOrders.call().data.length.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            padding: EdgeInsets.all(10),
            showBadge: _.activeOrders.call() != null,
            child: FloatingActionButton(
              splashColor: Colors.transparent,
              backgroundColor: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(30)
              ),
              onPressed: () {
                _.fetchActiveOrders();
                _activeOrderDialog();
              },
              child: Icon(Icons.restaurant_sharp),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey))
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              selectedFontSize: 10.0,
              unselectedFontSize: 10.0,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              iconSize: 25,
              fixedColor: Colors.black,
              onTap: (value) =>  _.tapped(value),
              items: [
                customNavigationBarItem('Food', image: Image.asset(Config.PNG_PATH + 'food.png', height: 27, width: 27, color: _.pageIndex.call() == 0 ? Colors.black : Colors.grey)),
                // customNavigationBarItem('Meal Kit', icon: Icon(FontAwesomeIcons.utensilSpoon)),
                customNavigationBarItem('Mart', image: Image.asset(Config.PNG_PATH + 'mart.png', height: 27, width: 27, color: _.pageIndex.call() == 1 ? Colors.black : Colors.grey)),
                // customNavigationBarItem('Notification', icon: Icon(Icons.notifications)),
                // customNavigationBarItem('Reviews', icon: Icon(FontAwesomeIcons.youtube)),
                // customNavigationBarItem('History', icon: Icon(FontAwesomeIcons.clipboardList)),
                customNavigationBarItem('Account', image: Image.asset(Config.PNG_PATH + 'account.png', height: 27, width: 27, color: _.pageIndex.call() == 2 ? Colors.black : Colors.grey)),
              ],
            ),
          )
        );
      },
    );
  }

  BottomNavigationBarItem customNavigationBarItem(String label, {Image image, Icon icon}) {
    return BottomNavigationBarItem(
      icon: icon == null ? image : icon,
      label: label,
    );
  }

  Widget _topSheet(DashboardController _) {
    return SafeArea(
      minimum: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.close), onPressed: () => _.showLocationSheet(false)),
                    Text('Choose your location', style: TextStyle(fontSize: 15))
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.add_circle_outline), onPressed: _.addAddress),
                  ],
                ),
              ),
            ],
          ),
          Container(height: 1, margin: EdgeInsets.symmetric(vertical: 5), color: Colors.grey.shade200),
          _.addresses.call() == null ? Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(_.addressMessage.call()),
                RaisedButton(
                  color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                  child: Text('Refresh'),
                  onPressed: () => _.refreshToken(),
                )
              ],
            ),
          ) :
          Container(
            height: 150,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: GetX<DashboardController>(
              builder: (_) {
                return Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: _.addresses.call().data.map((e) => _buildLocationList(e)).toList(),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      )
    );
  }

  Widget _buildLocationList(AddressData data) {
    final address = '${data.street} ${data.barangay} ${data.city}';
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              child: Text(data.name, style: TextStyle(color: Color(Config.LETSBEE_COLOR).withOpacity(1.0), fontWeight: FontWeight.bold)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child:  Text(address)),
                // GestureDetector(child: Icon(Icons.close), onTap: () => print('Remove location'))
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ],
        ),
      ),
      onTap: () {
        DashboardController.to.updateCurrentLocation(data);
      },
    );
  }

  Widget _buildActiveOrderList(ActiveOrderData data) {
    return GestureDetector(
      onTap: () {
        Get.back();
        controller.activeOrderData(data);
        Get.toNamed(Config.ACTIVE_ORDER_ROUTE);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          // border: Border.all(width: 0.5),
          borderRadius: BorderRadius.circular(5),
          color: Color(Config.LETSBEE_COLOR).withOpacity(1.0)
        ),
        child: Row(
          children: [
           Container(
             height: 55.0,
             width: 55.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white
            ),
            child: ClipOval(
               child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: data.activeRestaurant.logoUrl, fit: BoxFit.cover, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35)))
            ),
           ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
            Expanded(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  data.activeRestaurant.locationName.isBlank ? 
                  Text("${data.activeRestaurant.name}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)) : 
                  Text("${data.activeRestaurant.name} (${data.activeRestaurant.locationName})", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                  _buildStatus(status: data.status),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatus({String status}) {
    switch (status) {
      case 'pending': return Text('Waiting for restaurant...', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
        break;
      case 'restaurant-accepted': return Text('Waiting for rider...', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
        break;
      case 'restaurant-declined': return Text('Restaurant Declined', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
        break;
      case 'rider-accepted': return Text('Your rider is driving to pick your order...', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
        break;
      case 'rider-picked-up': return Text('Driver is on the way to your location...', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
        break;
      case 'delivered': return Text('Delivered', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
        break;
      case 'cancelled': return Text('Cancelled', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
        break;
      default: return Text('Pending', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
    }
  }

  _activeOrderDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(20),
        child: GetX<DashboardController>(
          builder: (_) {
            return Container(
              height: _.activeOrders.call() == null ? 100 : 350,
              child: _.activeOrders.call() == null ? Container(
                child: Center(child: Text(_.onGoingMessage.call(), style: TextStyle(fontSize: 18, color: Colors.black)))
              ) : Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _.activeOrders.call().data.map((e) => _buildActiveOrderList(e)).toList()
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}