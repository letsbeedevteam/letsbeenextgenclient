import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';

class ActiveOnGoingPage extends GetView<DashboardController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => Get.back()),
      ),
      body: Container(
        child: GetX<DashboardController>(
          builder: (_) {
            return _.activeOrderData.call() == null ? Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(child: Text(_.onGoingMessage.call(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              ) : Container(
              alignment: Alignment.topCenter,
              child: Container(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                    Text(_.title.call(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                    _buildStatus(_),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              RaisedButton(
                                onPressed: () => Get.toNamed(Config.ACTIVE_ORDER_DETAIL_ROUTE),
                                splashColor: Colors.transparent,
                                color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                                child: Icon(Icons.local_dining, size: 40),
                                padding: EdgeInsets.all(15),
                                shape: CircleBorder(
                                  side: BorderSide()
                                ),
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                              Text('Order Details', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14, color: Colors.black))
                            ],
                          ),
                          // Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                          Column(
                            children: [
                              RaisedButton(
                                onPressed: () => _.goToChatPage(fromNotificartion: false),
                                splashColor: Colors.transparent,
                                color: _.activeOrderData.call().rider != null ? Color(Config.LETSBEE_COLOR).withOpacity(1.0) : Colors.grey,
                                child: Icon(Icons.chat_sharp, size: 40),
                                padding: EdgeInsets.all(15),
                                shape: CircleBorder(
                                  side: BorderSide()
                                ),
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                              Text('Rider Chat', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14, color: Colors.black))
                            ],
                          ),
                          // Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                          Column(
                            children: [
                              RaisedButton(
                                onPressed: () => _.goToRiderLocationPage(),
                                splashColor: Colors.transparent,
                                color: _.activeOrderData.call().status == 'rider-picked-up' ? Color(Config.LETSBEE_COLOR).withOpacity(1.0) : Colors.grey,
                                child: Icon(Icons.motorcycle, size: 40),
                                padding: EdgeInsets.all(15),
                                shape: CircleBorder(
                                  side: BorderSide()
                                ),
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                              Text('Rider Location', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14, color: Colors.black))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatus(DashboardController controller) {
    switch (controller.activeOrderData.call().status) {
      case 'pending': return Column(
        children: [
          Icon(Icons.timer, size: 180),
          Text('Waiting for restaurant...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      );
        break;
      case 'restaurant-accepted': return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.timer, size: 180),
          Text('Restaurant is Cooking...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold)),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text('Waiting for rider...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.normal))
        ],
      );
        break;
      case 'restaurant-declined': return Text('Restaurant Declined', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold));
        break;
      case 'rider-accepted': return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.timer, size: 180),
          Text('Your rider is driving to pick your order...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold)),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          controller.activeOrderData.call() == null ? Container() 
          : Text('Your driver is: ${controller.activeOrderData.call().rider.user.name}', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.normal))
        ],
      );
        break;
      case 'rider-picked-up': return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.timer, size: 180),
          Text('Driver is on the way to your location...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold)),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          controller.activeOrderData.call() == null ? Container() 
          : Text('Your driver is: ${controller.activeOrderData.call().rider.user.name}', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.normal))
        ],
      );
        break;
      case 'delivered': return Text('Delivered', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18, fontWeight: FontWeight.bold));
        break;
      case 'cancelled': return Text('Cancelled', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18, fontWeight: FontWeight.bold));
        break;
      default: return Text('Waiting for restaurant...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18, fontWeight: FontWeight.bold));
    }
  }
}