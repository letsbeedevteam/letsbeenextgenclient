import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/history/history_view.dart';
import 'package:letsbeeclient/screens/ongoing/on_going_view.dart';

class OrderPage extends GetView<DashboardController> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          minimum: EdgeInsets.only(top: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                    ),
                    GetBuilder<DashboardController>(
                      id: 'tabIndex',
                      builder: (_) {
                        return SlideTransition(
                          position: _.offsetAnimation,
                          child: Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Row(
                              children: [
                                IconButton(icon: Icon(Icons.location_pin), onPressed: () {
                                  if (_.tabController.index == 0) print('Location');
                                }),
                                IconButton(icon: Icon(Icons.chat_sharp), onPressed: () {
                                  if (_.tabController.index == 0) print('Chat');
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              GetBuilder<DashboardController>(
                builder: (controller) {
                  return Container(
                    child: TabBar(
                      indicatorColor: Color(Config.LETSBEE_COLOR).withOpacity(0.5),
                      indicatorWeight: 5,
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.black,
                      controller: controller.tabController,
                      tabs: [
                        Tab(
                          child: Container(
                            width: Get.width * 0.3,
                            child: Center(child: Text('On going', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))
                          )
                        ),
                        Tab(
                          child: Container(
                            width: Get.width * 0.3,
                            child: Center(child: Text('History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))
                          )
                        )
                      ],
                    ),
                  );
                },
              ),
              Container(height: 1, color: Colors.grey.shade300, margin: EdgeInsets.only(top: 10)),
            ],
          ),
        ),
        Flexible(
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller.tabController,
            children: [
              OnGoingPage(),
              HistoryPage()
            ],
          )
        )
      ],
    );
  }
}