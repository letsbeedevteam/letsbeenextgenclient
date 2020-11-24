import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/controllers/dashboard/dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      id: 'pageIndex',
      builder: (_) {
        var currentIndex = _.pageIndex.value;
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(Get.width, 80),
            child: AnimatedContainer(
              height: _.isHideAppBar.value ? 0 : 80,
              duration: Duration(seconds: 2),
              curve: _.isHideAppBar.value ? Curves.fastLinearToSlowEaseIn : Curves.fastLinearToSlowEaseIn,
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                titleSpacing: 0.0,
                leading: IconButton(icon: Icon(FontAwesomeIcons.chevronDown, size: 15), onPressed: () => print('Location')),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DELIVERING TO', style: TextStyle(fontSize: 12, color: Colors.yellow.shade700)),
                    Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                    Text(_.userCurrentAddress.value, style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold))
                  ],
                ),
                actions: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: IconButton(icon: Image.asset(Config.PNG_PATH + 'frame_bee_cart.png', gaplessPlayback: true), onPressed: () => print('Cart')),
                  )
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              if (!_.isHideAppBar.value) Divider(thickness: 3, color: Colors.black, indent: 20, endIndent: 20),
              Flexible(
                child: _.widgets[_.pageIndex.value]
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
              customNavigationBarItem('Home', Icon(Icons.home)),
              customNavigationBarItem('Notification', Icon(Icons.notifications)),
              customNavigationBarItem('Account', Icon(Icons.account_circle_outlined)),
              customNavigationBarItem('Reviews', Icon(FontAwesomeIcons.youtube)),
              customNavigationBarItem('Order', Icon(Icons.add_shopping_cart))
            ],
          ),
        );
      },
    );
  }

  BottomNavigationBarItem customNavigationBarItem(String label, Icon icon) {
    return BottomNavigationBarItem(
      icon: icon,
      label: label,
    );
  }
}