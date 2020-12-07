import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      id: 'pageIndex',
      builder: (_) {
        var currentIndex = _.pageIndex.value;
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                    AnimatedContainer(
                    height: _.isHideAppBar.value ? 0 : 100,
                    duration: Duration(seconds: 2),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      titleSpacing: 0.0,
                      centerTitle: false,
                      leading: IconButton(icon: Icon(Icons.gps_fixed, size: 20), onPressed: () => _.showLocationSheet(true), highlightColor: Colors.transparent, splashColor: Colors.transparent),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('DELIVER TO: ', style: TextStyle(fontSize: 13)),
                              Text('HOME', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(_.userCurrentAddress.value, style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                        // actions: [
                        //   IconButton(icon: Image.asset(Config.PNG_PATH + 'frame_bee_cart.png', gaplessPlayback: true), iconSize: 50, onPressed: () => Get.toNamed(Config.CART_ROUTE), highlightColor: Colors.transparent, splashColor: Colors.transparent)
                        // ],
                    ),
                  ),
                  Container(
                    child:  _.isOpenLocationSheet.value ? _topSheet(_) : Container(),
                    width: Get.width, 
                    color: Colors.white
                  )
                ],
              ),
              Flexible(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _.pageController,
                  onPageChanged: (index) {
                    _.pageIndex.value = index;
                    _.showLocationSheet(false);
                  },
                  children: _.widgets,
                )
              )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            selectedFontSize: 10.0,
            unselectedFontSize: 10.0,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            iconSize: 25,
            fixedColor: Colors.black,
            onTap: (value) =>  _.tapped(value),
            items: [
              customNavigationBarItem('Home', icon: Icon(Icons.home)),
              customNavigationBarItem('Notification', icon: Icon(Icons.notifications)),
              customNavigationBarItem('Account', icon: Icon(Icons.account_circle_outlined)),
              customNavigationBarItem('Reviews', icon: Icon(FontAwesomeIcons.youtube)),
              customNavigationBarItem('Order', icon: Icon(FontAwesomeIcons.clipboardList))
            ],
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
                    IconButton(icon: Icon(Icons.add_circle_outline), onPressed: () => print('Add a new address')),
                  ],
                ),
              ),
            ],
          ),
          Container(height: 1, margin: EdgeInsets.symmetric(vertical: 5), color: Colors.grey.shade200),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView(
                  shrinkWrap: true,
                  children: [
                    _buildLocationList(name: 'HOME', address: '#234 San Pedro Magalang Pampanga', dashboardController: _),
                    _buildLocationList(name: 'WORK', address: '#23423 San san san Tarlac Pampanga', dashboardController: _),
                    _buildLocationList(name: 'BAHAY KO', address: '#2345 San Nicolas Test Pampanga', dashboardController: _)
                  ],
                ),
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _buildLocationList({String name, String address, DashboardController dashboardController}) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(color: Color(Config.LETSBEE_COLOR).withOpacity(1.0), fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child:  Text(address)),
                GestureDetector(child: Icon(Icons.close), onTap: () => print('Remove location'))
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ],
        ),
      ),
      onTap: () {
        dashboardController.updateCurrentLocation(address);
      },
    );
  }
}