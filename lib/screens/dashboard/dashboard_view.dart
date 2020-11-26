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
              AnimatedContainer(
                height: _.isHideAppBar.value ? 0 : 100,
                duration: Duration(seconds: 2),
                curve: Curves.fastLinearToSlowEaseIn,
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  titleSpacing: 0.0,
                  centerTitle: false,
                  leading: IconButton(icon: Icon(FontAwesomeIcons.chevronDown, size: 15), onPressed: () => print('Location')),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('DELIVER TO: ', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                          Text('HOME', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                      Text(_.userCurrentAddress.value, style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold))
                    ],
                  ),
                  actions: [
                    IconButton(icon: Image.asset(Config.PNG_PATH + 'frame_bee_cart.png', gaplessPlayback: true), iconSize: 50, onPressed: () => print('Cart'))
                  ],
                ),
              ),
              Flexible(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _.pageController,
                  onPageChanged: (index) => _.pageIndex.value = index,
                  children: _.widgets,
                )
              )
            ],
          ),
          bottomNavigationBar: GetBuilder(
            id: 'pageIndex',
            builder: (controller) {
              return  BottomNavigationBar(
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
              );
            },
          ),
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
}