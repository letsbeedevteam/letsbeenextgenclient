import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeeclient/controllers/dashboard/dashboard_controller.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'dart:math' as math;

class DashboardPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 60),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: GetBuilder<DashboardController>(
            builder: (_) {
              return Transform(
                child: IconButton(icon: Icon(Icons.logout, color: Colors.black), onPressed: () => _.signOut()),
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
              );
            },
          ),
          titleSpacing: 5,
          title: GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DELIVERING TO', style: TextStyle(fontSize: 10, color: Colors.yellow.shade700, fontWeight: FontWeight.bold)),
                Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                GetX<DashboardController>(
                  builder: (_) => Text(_.userCurrentAddress.value, style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            onTap: () => print('Location Settings'),
          ),
          centerTitle: true,
        ),
      ),
      body: GetBuilder<DashboardController>(
        id: 'pageIndex',
        builder: (_) => _.widgets[_.pageIndex.value],
      ),
      bottomNavigationBar: GetBuilder<DashboardController>(
        id: 'pageIndex',
        builder: (_) {
          var currentIndex = _.pageIndex.value;
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _.pageIndex.value,
            selectedFontSize: 12.0,
            unselectedFontSize: 12.0,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            fixedColor: Colors.yellow.shade700,
            onTap: (value) =>  _.tapped(value),
            items: [
              customNavigationBarItem(0, currentIndex, 'Home', Config.SVG_PATH + 'home.svg'),
              customNavigationBarItem(1, currentIndex, 'Search', Config.SVG_PATH + 'search.svg'),
              customNavigationBarItem(2, currentIndex, 'Orders', Config.SVG_PATH + 'note.svg'),
              customNavigationBarItem(3, currentIndex, 'Account', Config.SVG_PATH + 'account.svg'),
            ],
          );
        },
      ),
      floatingActionButton: GetBuilder<DashboardController>(
        builder: (_) {
          return FloatingActionButton(
            child:  Icon(Icons.add),
            onPressed: () => _.sendData(),
          );
        },
      ),
    );
  }

  BottomNavigationBarItem customNavigationBarItem(int index, int currentIndex, String label, String svgPath) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        svgPath, 
        color: currentIndex == index ? Colors.yellow.shade600 : Colors.grey, 
        height: currentIndex == index ? 20 : 18, 
        width: currentIndex == index ? 20 : 18
      ),
      label: label,
    );
  }
}