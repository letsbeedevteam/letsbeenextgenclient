import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/activeOrderResponse.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class DashboardPage extends GetView<DashboardController> {
  
  @override
  Widget build(BuildContext context) {
    return GetX<DashboardController>(
      builder: (_) {
        final currentIndex = _.pageIndex.call();
        return GestureDetector(
          onTap: () => dismissKeyboard(Get.context),
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                      AnimatedContainer(
                      height: _.isHideAppBar.call() ? 0 : Get.height / 8.5,
                      duration: Duration(seconds: 2),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: AppBar(
                        elevation: 0,
                        backgroundColor: Color(Config.WHITE),
                        titleSpacing: 0.0,
                        centerTitle: false,
                        // leading: IconButton(icon: Icon(Icons.gps_fixed, size: 25), onPressed: () => _.showLocationSheet(true), highlightColor: Colors.transparent, splashColor: Colors.transparent),
                        title: currentIndex == 2 ? Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          child: Text('My Account', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal)),
                        ) : Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                              Row(
                                children: [
                                  Text('Deliver to: ', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    height: 20,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: Color(Config.LETSBEE_COLOR),
                                      borderRadius: BorderRadius.circular(25)
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(_.userCurrentNameOfLocation.call() == null ? 'Home' : _.userCurrentNameOfLocation.call(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                                        // Icon(Icons.keyboard_arrow_down, size: 20,)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                              Row(
                                children: [
                                  Image.asset(Config.PNG_PATH + 'address.png', height: 18, width: 18),
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                                  Expanded(child: Text(_.userCurrentAddress.call(), style: TextStyle(fontSize: 14, color: Color(Config.USER_CURRENT_ADDRESS_TEXT_COLOR), fontWeight: FontWeight.normal))),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // actions: [
                        //   IconButton(icon: Image.asset(Config.PNG_PATH + 'jar-empty.png', gaplessPlayback: true, height: 25, width: 25), onPressed: () => print('Cart'), highlightColor: Colors.transparent, splashColor: Colors.transparent)
                        // ],
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Column(
                    children: [
                      Divider(),
                      Expanded(
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _.pageController,
                          onPageChanged: (index) {
                            _.pageIndex(index);
                          },
                          children: _.widgets,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            floatingActionButton: _.activeOrders.call() == null ? Container() : Badge(
              badgeContent: Text(_.activeOrders.call().data.length.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              padding: EdgeInsets.all(10),
              borderSide: BorderSide(color: Colors.black, width: 1.5),
              showBadge: _.activeOrders.call() != null,
              child: FloatingActionButton(
                splashColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                elevation: 0,
                onPressed: () {
                  _.fetchActiveOrders();
                  _activeOrderDialog();
                },
                child: Image.asset(Config.PNG_PATH + 'active_order.png', height: 50, width: 50),
              ),
            ),
            bottomNavigationBar: Theme(
              data: Get.theme.copyWith(
                splashColor: Colors.transparent
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: currentIndex,
                selectedFontSize: 10.0,
                unselectedFontSize: 10.0,
                iconSize: 25,
                onTap: (value) =>  _.tapped(value),
                items: [
                  customNavigationBarItem('Food', image: Image.asset(_.pageIndex.call() == 0 ? '${Config.PNG_PATH}food-act.png' : '${Config.PNG_PATH}food-inact.png')),
                  // customNavigationBarItem('Meal Kit', icon: Icon(FontAwesomeIcons.utensilSpoon)),
                  customNavigationBarItem('Groceries', image: Image.asset(_.pageIndex.call() == 1 ? '${Config.PNG_PATH}groc-act.png' : '${Config.PNG_PATH}groc-inact.png')),
                  // customNavigationBarItem('Notification', icon: Icon(Icons.notifications)),
                  // customNavigationBarItem('Reviews', icon: Icon(FontAwesomeIcons.youtube)),
                  // customNavigationBarItem('History', icon: Icon(FontAwesomeIcons.clipboardList)),
                  customNavigationBarItem('Account', image: Image.asset(_.pageIndex.call() == 2 ? '${Config.PNG_PATH}acc-act.png' : '${Config.PNG_PATH}acc-inact.png')),
                ],
              ),
            )
          ),
        );
      },
    );
  }

  BottomNavigationBarItem customNavigationBarItem(String label, {Image image, Icon icon}) {
    return BottomNavigationBarItem(
      icon: icon == null ? Column(
        children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          SizedBox(height: 23, width: 23, child: image),
          Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))
        ],
      ) : icon,
      activeIcon: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: Color(Config.LETSBEE_COLOR),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 2)),
            SizedBox(height: 30, width: 30, child: image),
            Padding(padding: EdgeInsets.symmetric(vertical: 2)),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold))
          ],
        )
      ),
      label: '',
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
          color: Color(Config.LETSBEE_COLOR)
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
               child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: data.activeStore.logoUrl.toString(), fit: BoxFit.cover, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35)))
            ),
           ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
            Expanded(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  data.activeStore.locationName.isBlank ? 
                  Text("${data.activeStore.name}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)) : 
                  Text("${data.activeStore.name} (${data.activeStore.locationName})", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
      case 'store-accepted': return Text('Waiting for rider...', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
        break;
      case 'store-declined': return Text('Restaurant Declined', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
        break;
      case 'rider-accepted': return Text('Your rider is driving to pick your order...', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
        break;
      case 'rider-picked-up': return Text('Driver is on the way to your location...', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
        break;
      case 'delivered': return Text('Delivered', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
        break;
      case 'cancelled': return Text('Cancelled', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
        break;
      default: return Text('Waiting for rider...', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
    }
  }

  _activeOrderDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        backgroundColor: Color(Config.WHITE),
        insetPadding: EdgeInsets.all(20),
        child: GetX<DashboardController>(
          builder: (_) {
            return Container(
              height: _.activeOrders.call() == null ? 100 : 380,
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