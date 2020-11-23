import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeeclient/controllers/dashboard/dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 60),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          titleSpacing: 5,
          title: GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DELIVERING TO', style: TextStyle(fontSize: 10, color: Colors.yellow.shade700)),
                  Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                  GetX<DashboardController>(
                    builder: (_) => Text(_.userCurrentAddress.value, style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            onTap: () => print('Location Settings'),
          ),
          centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.shopping_cart_outlined), onPressed: () => print('Cart'))
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Divider(thickness: 3, color: Colors.black, indent: 20, endIndent: 20),
            GetBuilder<DashboardController>(
              id: 'pageIndex',
              builder: (_) => Flexible(child: _.widgets[_.pageIndex.value]),
            )
          ],
        ),
      ),
      bottomNavigationBar: GetBuilder<DashboardController>(
        id: 'pageIndex',
        builder: (_) {
          var currentIndex = _.pageIndex.value;
          return BottomNavigationBar(
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
              customNavigationBarItem('Order', Icon(Icons.notes))
            ],
          );
        },
      ),
    );
  }

  BottomNavigationBarItem customNavigationBarItem(String label, Icon icon) {
    return BottomNavigationBarItem(
      icon: icon,
      label: label,
    );
  }
}