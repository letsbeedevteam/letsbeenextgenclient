import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/activeOrderResponse.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';

class ActiveOnGoingPage extends GetView<DashboardController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Obx(() {
          return controller.activeOrderData.call() == null ? Container() : controller.activeOrderData.call().activeStore.locationName.isBlank ? 
          Text("${controller.activeOrderData.call().activeStore.name}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)) : 
          Text("${controller.activeOrderData.call().activeStore.name} (${controller.activeOrderData.call().activeStore.locationName})", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold));
        }),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.close), onPressed: () =>  Get.back())
        ],
        bottom: PreferredSize(
          child: Container(height: 2, color: Colors.grey.shade200),
          preferredSize: Size.fromHeight(4.0)
        ),
      ),
      body: Obx(() {
        return controller.activeOrderData.call() == null ? Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Center(child: Text(controller.cancelMessage.call(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
        ) : Column(
          children: [
            Expanded(
              flex: 8,
              child: _scrollView()
            ),
            Expanded(
              child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Container(
                width: Get.width,
                child: IgnorePointer(
                  ignoring: controller.activeOrderData.call().rider == null || controller.activeOrderData.call().status == 'delivered',
                  child: RaisedButton(
                    splashColor: Colors.transparent,
                    color: controller.activeOrderData.call().status == 'rider-accepted' || controller.activeOrderData.call().status == 'rider-picked-up' ? Color(Config.LETSBEE_COLOR): Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Message rider', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    onPressed: () => controller.goToChatPage(fromNotificartion: false)),
                )
                ),
              ),
            ) 
          ],
        );
      })
    );
  }

  Widget _scrollView() {
    return SingleChildScrollView(
      child: Obx(() {
        return Container(
          alignment: Alignment.topCenter,
          child: Container(
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    _buildStatus(controller),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Container(height: 2, color: Colors.grey.shade200),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    _buildLocation(),
                    _buildRiderDetails(),
                    _buildOrderSummary(),
                    Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLocation() {
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(controller.activeOrderData.call().status == 'delivered' ? 'Delivered at:' : 'Deliver at:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
            Padding(padding: EdgeInsets.symmetric(vertical: 2)),
            Row(
              children: [
                Image.asset(Config.PNG_PATH + 'address.png', height: 18, width: 18),
                Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                Expanded(child: Text(controller.activeOrderData.call().address.completeAddress, style: TextStyle(fontSize: 14, color: Color(Config.USER_CURRENT_ADDRESS_TEXT_COLOR), fontWeight: FontWeight.normal), overflow: TextOverflow.ellipsis)),
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Container(height: 2, color: Colors.grey.shade200),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ],
        ),
      );
    });
  }

  Widget _buildRiderDetails() {
    return Obx(() {
      return controller.activeOrderData.call().rider != null ? Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: 'Your Rider: ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13)),
                              TextSpan(text: controller.activeOrderData.call().rider.user.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13)),
                            ]
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text:'${controller.activeOrderData.call().rider.motorcycleDetails.brand} - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13)),
                              TextSpan(text:'${controller.activeOrderData.call().rider.motorcycleDetails.model} - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13)),
                              TextSpan(text:'${controller.activeOrderData.call().rider.motorcycleDetails.plateNumber} - ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13)),
                              TextSpan(text:'${controller.activeOrderData.call().rider.motorcycleDetails.color}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13)),
                            ]
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                        Text(controller.activeOrderData.call().rider.user.number, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13)),
                      ],
                    ),
                  )
                ),
                Expanded(
                  child: IgnorePointer(
                    ignoring: controller.activeOrderData.call().status != 'rider-picked-up',
                    child: SizedBox(
                      width: 100,
                      height: 70,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        color: controller.activeOrderData.call().status == 'rider-picked-up' ? Color(Config.LETSBEE_COLOR) : Colors.grey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                            Image.asset(Config.PNG_PATH + 'track.png', height: 35),
                            Expanded(child: Text('Track Rider', style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w500), textAlign: TextAlign.center))
                          ],
                        ),
                        onPressed: () => controller.goToRiderLocationPage(),
                      ),
                    ),
                  ),
                )
              ]
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Container(height: 2, color: Colors.grey.shade200),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          ],
        ),
      ) : Container();
    });
  }

  Widget _buildOrderSummary() {
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Summary', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Column(
              children: controller.activeOrderData.call().products.map((e) => _buildMenu(e)).toList(),
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sub Total:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                      Text('₱${controller.activeOrderData.call().fee.subTotal}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery Fee:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                      Text('₱${controller.activeOrderData.call().fee.delivery}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Divider(thickness: 2, color: Colors.grey.shade200),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                        Text('₱${controller.activeOrderData.call().fee.customerTotalPrice}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
                      ],
                    ),
                  ),
                  (controller.activeOrderData.call().status != 'pending' && controller.activeOrderData.call().activeStore.type != 'mart') || (controller.activeOrderData.call().status != 'store-accepted' && controller.activeOrderData.call().activeStore.type == 'mart') ? Container() : Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 5),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      color: Color(Config.LETSBEE_COLOR),
                      child: Text('Cancel Order', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                      onPressed: _cancelDialog,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMenu(ActiveOrderMenu product) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: Text('${product.quantity}x ${product.name}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                ),
              ),
              Text('₱${(double.tryParse(product.customerPrice) * product.quantity).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Column(
              children: [
                product.additionals.isEmpty ? Container() :
                Column(
                    children: product.additionals.map((e) => _buildAddsOn(e, product.quantity)).toList(),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Column(
                  children: product.choices.map((e) => _buildChoice(e, product.quantity)).toList(),
                ),
              ],
            )
          ),
          product.note != null ? Container(
            margin: EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Special Instructions', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black)),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: Text(product.note.toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.grey))
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Divider(thickness: 2, color: Colors.grey.shade200),
                )
              ],
            ),
          ) : Container(
            margin: EdgeInsets.only(top: 5),
            child: Divider(thickness: 2, color: Colors.grey.shade200),
          ),
        ],
      ),
    );
  }

  Widget _buildAddsOn(Additional additional, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(additional.name, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 13), textAlign: TextAlign.start),
        ),
        Text('₱' + double.parse('${(double.tryParse(additional.customerPrice) * quantity).toStringAsFixed(2)}').toStringAsFixed(2), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13))
      ],
    );
  }

  Widget _buildChoice(Choice choice, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Text('${choice.name}:', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 13)),
              Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
              Text('${choice.pick}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 13))
            ],
          )
        ),
        Text('₱' + double.parse('${(double.tryParse(choice.customerPrice) * quantity).toStringAsFixed(2)}').toStringAsFixed(2), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13))
      ],
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('Waiting for restaurant to accept your order...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
        ],
      );
        break;
      case 'store-accepted': return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child:  _.activeOrderData.call().activeStore.type == 'mart' ? GifImage(
              controller: DashboardController.to.changeGifRange(range: 14, duration: 1500),
              image: AssetImage(Config.GIF_PATH + 'waiting.gif'),
              height: 150,
            ) : GifImage(
             controller: DashboardController.to.changeGifRange(range: 7, duration: 500),
              image: AssetImage(Config.GIF_PATH + 'preparing.gif'),
              height: 150,
            )
          ),
          Text(_.activeOrderData.call().activeStore.type == 'mart' ? 'Waiting for rider to accept your order...' : 'Preparing your food...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          _.activeOrderData.call().activeStore.type == 'mart' ? Container() : Text('Waiting for rider to accept your order...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.normal))
        ],
      );
        break;
      case 'store-declined': return Column(
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
          Text('Your rider is on the way to pick up your order...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
          Text('Your rider is on the way to your location...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
      default: return Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: GifImage(
              controller: DashboardController.to.changeGifRange(range: 14, duration: 1500),
              image: AssetImage(Config.GIF_PATH + 'waiting.gif'),
              height: 150,
            )
          ),
          Text('Waiting for rider to accept your order...', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      );
    }
  }

  _cancelDialog() {
    Get.dialog(
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              // image: DecorationImage(
              //   image: ExactAssetImage(Config.PNG_PATH + 'letsbee_bg.png'),
              //   fit: BoxFit.cover
              // )
              color: Colors.white
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                controller.activeOrderData.call().activeStore.locationName.isBlank ? 
                Text("Do you really want to cancel your order at ${controller.activeOrderData.call().activeStore.name}?", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.center) : 
                Text("Do you really want to cancel your order at ${controller.activeOrderData.call().activeStore.name} (${controller.activeOrderData.call().activeStore.locationName})?", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                Padding(padding: EdgeInsets.all(10)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        color: Color(Config.LETSBEE_COLOR),
                        child: Text('NO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                        onPressed: () => Get.back(),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        color: Color(Config.LETSBEE_COLOR),
                        child: Text('YES', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                        onPressed: () => controller.cancelOrderById(),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      name: 'cancel-dialog'
    );
  }
}