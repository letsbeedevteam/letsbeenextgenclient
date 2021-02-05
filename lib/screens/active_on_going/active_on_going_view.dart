import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () =>  Get.back()),
      ),
      body: Container(
        child: GetX<DashboardController>(
          builder: (_) {

            return _.activeOrderData.call() == null ? Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Center(child: Text(_.cancelMessage.call(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              ) : Container(
              alignment: Alignment.topCenter,
              child: Container(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                    _.activeOrderData.call().activeRestaurant.locationName.isBlank ? Text("${_.activeOrderData.call().activeRestaurant.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)) : Text("${_.activeOrderData.call().activeRestaurant.name} (${_.activeOrderData.call().activeRestaurant.locationName})", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                                color: Color(Config.LETSBEE_COLOR),
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
                              IgnorePointer(
                                ignoring: _.activeOrderData.call().rider == null || _.activeOrderData.call().status == 'delivered',
                                child: RaisedButton(
                                  onPressed: () => _.goToChatPage(fromNotificartion: false),
                                  splashColor: Colors.transparent,
                                  color: _.activeOrderData.call().status == 'rider-accepted' || _.activeOrderData.call().status == 'rider-picked-up' ? Color(Config.LETSBEE_COLOR): Colors.grey,
                                  child: Icon(Icons.chat_bubble_outline_sharp, size: 40),
                                  padding: EdgeInsets.all(15),
                                  shape: CircleBorder(
                                    side: BorderSide()
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                              Text('Rider Chat', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14, color: Colors.black))
                            ],
                          ),
                          // Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                          Column(
                            children: [
                              IgnorePointer(
                                ignoring: _.activeOrderData.call().status != 'rider-picked-up',
                                child: RaisedButton(
                                  onPressed: () => _.goToRiderLocationPage(),
                                  splashColor: Colors.transparent,
                                  color: _.activeOrderData.call().status == 'rider-picked-up' ? Color(Config.LETSBEE_COLOR) : Colors.grey,
                                  child: Icon(FontAwesomeIcons.mapMarkerAlt, size: 40),
                                  padding: EdgeInsets.all(15),
                                  shape: CircleBorder(
                                    side: BorderSide()
                                  ),
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

  Widget _buildStatus(DashboardController _) {
    switch (_.activeOrderData.call().status) {
      case 'pending': return Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: GifImage(
              controller: DashboardController.to.changeGifRange(range: 14, duration: 1500),
              image: AssetImage(Config.GIF_PATH + 'waiting.gif'),
              height: 150,
            )
          ),
          Text('Waiting for restaurant...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      );
        break;
      case 'restaurant-accepted': return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: GifImage(
             controller: DashboardController.to.changeGifRange(range: 7, duration: 500),
              image: AssetImage(Config.GIF_PATH + 'preparing.gif'),
              height: 150,
            )
          ),
          Text('Restaurant is Cooking...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text('Waiting for rider...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.normal))
        ],
      );
        break;
      case 'restaurant-declined': return Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Icon(Icons.cancel_outlined, size: 150, color: Colors.red),
          ),
          Text('Your order has been declined by the Restaurant', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text('Reason: ${_.activeOrderData.call().reason}', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ],
      );
        break;
      case 'rider-accepted': return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: GifImage(
              controller: DashboardController.to.changeGifRange(range: 5, duration: 500),
              image: AssetImage(Config.GIF_PATH + 'takeaway.gif'),
              height: 150,
            )
          ),
          Text('Driver is on the way to pick up your order...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          _.activeOrderData.call() == null ? Container() 
          : Text('Your driver is: ${_.activeOrderData.call().rider.user.name}', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.normal))
        ],
      );
        break;
      case 'rider-picked-up': return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: GifImage(
              controller: DashboardController.to.changeGifRange(range: 3, duration: 500),
              image: AssetImage(Config.GIF_PATH + 'motor.gif'),
              height: 150,
            )
          ),
          Text('Driver is on the way to your location...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          _.activeOrderData.call() == null ? Container() 
          : Text('Your driver is: ${_.activeOrderData.call().rider.user.name}', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.normal))
        ],
      );
        break;
      case 'delivered': return Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: GifImage(
              controller: DashboardController.to.changeGifRange(range: 3, duration: 500),
              image: AssetImage(Config.GIF_PATH + 'house.gif'),
              height: 150,
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Your order has been delivered to your location...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
        ],
      );
        break;
      case 'cancelled': return Text('Cancelled', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18, fontWeight: FontWeight.bold));
        break;
      default: return Text('Waiting for restaurant...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18, fontWeight: FontWeight.bold));
    }
  }
}