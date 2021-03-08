import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
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
                        title: currentIndex == 2 ? Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          child: Text(tr('myAccount'), style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal)),
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
                                  Text('${tr('deliverTo')}: ', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    height: 25,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: Color(Config.LETSBEE_COLOR),
                                      borderRadius: BorderRadius.circular(25)
                                    ),
                                    child: Text(_.userCurrentNameOfLocation.call(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
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
                        //   _.pageIndex.call() == 2 ? Container() :
                        //   IconButton(icon: Image.asset(Config.PNG_PATH + 'jar-empty.png', gaplessPlayback: true, height: 25, width: 25), onPressed: () => print('Cart'), highlightColor: Colors.transparent, splashColor: Colors.transparent)
                        // ],
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Column(
                    children: [
                      Container(
                        height: 1,
                        margin: EdgeInsets.only(top: 2),
                        color: Colors.grey.shade200
                      ),
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
            floatingActionButton: _.pageIndex.call() == 2 ? Container() : _.activeOrders.call() == null ? Container() : Badge(
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
                  if (_.activeOrders.call().data.length == 1) {
                    controller.activeOrderData(_.activeOrders.call().data.first);
                    Get.toNamed(Config.ACTIVE_ORDER_ROUTE);
                  } else {
                    _activeOrderDialog();
                  }
                
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
                  customNavigationBarItem(tr('food'), image: Image.asset(_.pageIndex.call() == 0 ? '${Config.PNG_PATH}food-act.png' : '${Config.PNG_PATH}food-inact.png')),
                  // customNavigationBarItem('Meal Kit', icon: Icon(FontAwesomeIcons.utensilSpoon)),
                  customNavigationBarItem(tr('groceries'), image: Image.asset(_.pageIndex.call() == 1 ? '${Config.PNG_PATH}groc-act.png' : '${Config.PNG_PATH}groc-inact.png')),
                  // customNavigationBarItem('Notification', icon: Icon(Icons.notifications)),
                  // customNavigationBarItem('Reviews', icon: Icon(FontAwesomeIcons.youtube)),
                  // customNavigationBarItem('History', icon: Icon(FontAwesomeIcons.clipboardList)),
                  customNavigationBarItem(tr('account'), image: Image.asset(_.pageIndex.call() == 2 ? '${Config.PNG_PATH}acc-act.png' : '${Config.PNG_PATH}acc-inact.png')),
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
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.all(10),
        color: Color(Config.WHITE),
        child: Column(
          children: [
            Row(
              children: [           
                Expanded(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      data.activeStore.locationName.isBlank ? 
                      Text("${data.activeStore.name}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)) : 
                      Text("${data.activeStore.name} (${data.activeStore.locationName})", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                      _buildStatus(status: data.status, type: data.activeStore.type),
                      Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                      Text(data.products.length == 1 ? '${data.products.first.quantity}x ${data.products.first.name}' : '${data.products.length}x ${tr('items')}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                      Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                      Text('₱${data.fee.customerTotalPrice}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                Container(
                 height: 70.0,
                 width: 70.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: data.activeStore.logoUrl.toString(), fit: BoxFit.cover, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35))),
                ),
               ),
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 3)),
            Divider(thickness: 1, color: Colors.grey.shade200)
          ],
        ),
      ),
    );
  }

  Widget _buildStatus({String status, String type}) {
    switch (status) {
      case 'pending': return Text(tr('waitingRestaurant'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12));
        break;
      case 'store-accepted': return Text(type == 'mart' ? tr('waitingRider') : tr('preparingFood'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12));
        break;
      case 'store-declined': return Text(tr('restaurantDeclined'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12));
        break;
      case 'rider-accepted': return Text(type == 'mart' ? tr('preparingGrocery') : tr('preparingFood'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12));
        break;
      case 'rider-picked-up': return Text(tr('riderPickUp'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12));
        break;
      case 'delivered': return Text(tr('riderDelivered'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12));
        break;
      case 'cancelled': return Text(tr('cancelled'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12));
        break;
      default: return Text(tr('waitingRider'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12));
    }
  }

  _activeOrderDialog() {
    Get.bottomSheet(
      Obx(() {
        return Container(
          margin: EdgeInsets.only(top: 20),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(tr('yourOrders'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
              centerTitle: true,
              bottom: PreferredSize(
                child: Container(height: 1, color: Colors.grey.shade200),
                preferredSize: Size.fromHeight(4.0)
              ),
              actions: [
                IconButton(icon: RotatedBox(
                  quarterTurns: 3,
                  child: Icon(Icons.chevron_left),
                ), onPressed: () => Get.back())
              ],
            ),
            body: Container(
              child: controller.activeOrders.call() == null ? Container(
                child: Center(child: Text(controller.onGoingMessage.call(), style: TextStyle(fontSize: 18, color: Colors.black)))
              ) : Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: controller.activeOrders.call().data.map((e) => _buildActiveOrderList(e)).toList()
                  ),
                ),
              ),
            ),
          ),
        );
      }),
      backgroundColor: Color(Config.WHITE),
      isScrollControlled: true
    );
  }
}