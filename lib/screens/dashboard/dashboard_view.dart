import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/active_order_response.dart';
import 'package:letsbeeclient/screens/dashboard/childs/mart_child_view.dart';
import 'package:letsbeeclient/screens/dashboard/childs/restaurant_child_view.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/account_settings_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/home_view.dart';
import 'package:letsbeeclient/screens/dashboard/tabs/mart_view.dart';
import 'package:loading_gifs/loading_gifs.dart';

class DashboardPage extends GetView<DashboardController> {
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => dismissKeyboard(Get.context),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: [
            Obx(() {
              return AnimatedContainer(
                height: controller.isOnSearch.call() ? 0 : Get.height / 8.5,
                duration: Duration(seconds: 2),
                curve: Curves.fastLinearToSlowEaseIn,
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Color(Config.WHITE),
                  titleSpacing: 0.0,
                  centerTitle: false,
                  title: controller.pageIndex() == 2 ? _buildMyAccount() : _buildDeliverTo()
                ),
              );
            }),
            Flexible(
              child: Column(
                children: [
                  Obx(() {
                    return controller.isOnSearch.call() ? Padding(padding: EdgeInsets.symmetric(vertical: 10)) : Container(
                      height: 1,
                      margin: EdgeInsets.only(top: 2),
                      color: Colors.grey.shade200
                    );
                  }),
                  Obx(() {
                    return Flexible(
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: controller.pageController,
                        onPageChanged: (index) {
                          controller.pageIndex(index);
                        },
                        children: [
                          controller.isOnSearch.call() ? RestaurantChildPage() : HomePage(), 
                          controller.isOnSearch.call() ? MartChildPage() : MartPage(),
                          AccountSettingsPage(), 
                        ],
                      ),
                    );
                  })
                ],
              ),
            )
          ],
        ),
        floatingActionButton: Obx(() {
          return controller.pageIndex.call() == 2 ? Container() : controller.activeOrders.call() == null ? Container() : Badge(
            badgeContent: Text(controller.activeOrders.call().data.length.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            padding: EdgeInsets.all(10),
            borderSide: BorderSide(color: Colors.black, width: 1.5),
            showBadge: controller.activeOrders.call() != null,
            child: FloatingActionButton(
              splashColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () {
                controller.fetchActiveOrders();
                if (controller.activeOrders.call().data.length == 1) {
                  controller.activeOrderData(controller.activeOrders.call().data.first);
                  Get.toNamed(Config.ACTIVE_ORDER_ROUTE);
                } else {
                  _activeOrderDialog();
                }
              
              },
              child: Image.asset(Config.PNG_PATH + 'active_order.png', height: 50, width: 50),
            ),
          );
        }),
        bottomNavigationBar: Theme(
          data: Get.theme.copyWith(
            splashColor: Colors.transparent,
          ),
          child: Obx(() {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.pageIndex.call(),
              selectedFontSize: 10.0,
              unselectedFontSize: 10.0,
              iconSize: 25,
              selectedLabelStyle: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
              selectedItemColor: Colors.black,
              onTap: (value) => controller.tapped(value),
              items: [
                customNavigationBarItem(tr('food'), image: Image.asset(controller.pageIndex.call() == 0 ? '${Config.PNG_PATH}food-act.png' : '${Config.PNG_PATH}food-inact.png')),
                customNavigationBarItem(tr('groceries'), image: Image.asset(controller.pageIndex.call() == 1 ? '${Config.PNG_PATH}groc-act.png' : '${Config.PNG_PATH}groc-inact.png')),
                customNavigationBarItem(tr('account'), image: Image.asset(controller.pageIndex.call() == 2 ? '${Config.PNG_PATH}acc-act.png' : '${Config.PNG_PATH}acc-inact.png')),
              ],
            );
          })
        )
      ),
    );
  }

  BottomNavigationBarItem customNavigationBarItem(String label, {Image image, Icon icon}) {
    return BottomNavigationBarItem(
      icon: icon == null ? Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          SizedBox(height: 20, width: 20, child: image),
          Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))
        ],
      ) : icon,
      activeIcon: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Color(Config.LETSBEE_COLOR),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 1)),
            SizedBox(height: 25, width: 25, child: image),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          ],
        )
      ),
      label: '',
    );
  }

  Widget _buildMyAccount() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20),
      child: Text(tr('myAccount'), style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal)),
    );
  }

  Widget _buildDeliverTo() {
    return controller.isOnSearch.call() ? Container() : Padding(
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
              GestureDetector(
                onTap: () => Get.toNamed(Config.ADDRESS_ROUTE),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 25,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Color(Config.LETSBEE_COLOR),
                    borderRadius: BorderRadius.circular(25)
                  ),
                  child: Obx(() {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(controller.userCurrentNameOfLocation.call(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                        RotatedBox(
                          quarterTurns: 3,
                          child: Icon(Icons.chevron_left),
                        )
                      ],
                    );
                  }),
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          Row(
            children: [
              Image.asset(Config.PNG_PATH + 'address.png', height: 18, width: 18),
              Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
              Expanded(child: Obx(() => Text(controller.userCurrentAddress.call(), style: TextStyle(fontSize: 14, color: Color(Config.USER_CURRENT_ADDRESS_TEXT_COLOR), fontWeight: FontWeight.normal)))),
            ],
          ),
        ],
      ),
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