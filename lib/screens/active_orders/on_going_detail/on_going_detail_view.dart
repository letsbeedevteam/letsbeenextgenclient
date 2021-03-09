import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/activeOrderResponse.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:intl/intl.dart';

class OnGoingDetailPage extends GetView<DashboardController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => Get.back()),
        // actions: [
        //   GetX<DashboardController>(
        //     builder: (_) {
        //       return _.activeOrderData.call() != null ? IconButton(icon: Icon(Icons.location_pin), onPressed: () => controller.goToRiderLocationPage()) : Container();
        //     },
        //   ),
        //    GetX<DashboardController>(
        //     builder: (_) {
        //       return _.activeOrderData.call() != null ? IconButton(icon: Icon(Icons.chat_sharp), onPressed: () => controller.goToChatPage(fromNotificartion: false)) : Container();
        //     },
        //   ),
        // ],
      ),
      body: Scrollbar(
        child: Column(
          children: [
            Container(height: 1, color: Colors.grey.shade300),
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: GetX<DashboardController>(
                  builder: (_) {
                    return _.activeOrderData.call() == null ? Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(child: Text(_.onGoingMessage.call(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                    ) : Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: _.activeOrderData.call().activeStore.locationName.isBlank ? 
                            Text("${_.activeOrderData.call().activeStore.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)) : 
                            Text("${_.activeOrderData.call().activeStore.name} (${_.activeOrderData.call().activeStore.locationName})", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                                Text('Items:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                                Column(
                                  children: _.activeOrderData.call().products.map((e) => _buildMenu(e, _)).toList(),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Sub Total:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Text('₱ ${double.tryParse(_.activeOrderData.call().fee.subTotal).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Delivery Fee:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Text('₱ ${double.tryParse(_.activeOrderData.call().fee.delivery).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Promo Code Discount:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Text('₱ ${double.tryParse(_.activeOrderData.call().fee.discountPrice).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.bottomCenter,
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('TOTAL:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                            Text('₱ ${(double.tryParse(_.activeOrderData.call().fee.customerTotalPrice)).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Divider(thickness: 2, color: Colors.grey.shade200),
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Delivery Details:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Address: ${_.activeOrderData.call().address.completeAddress}', 
                                              style: TextStyle(color: Colors.black, fontSize: 14)
                                            ),
                                            Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                                            Text('Contact Number: ${_.box.read(Config.USER_MOBILE_NUMBER)}', style: TextStyle(color: Colors.black, fontSize: 14))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Divider(thickness: 2, color: Colors.grey.shade200),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Mode of Payment:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Text('${_.activeOrderData.call().payment.method.capitalizeFirst}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Divider(thickness: 2, color: Colors.grey.shade200),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Date:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Text(DateFormat('MMMM dd, yyyy (hh:mm a)').format(_.activeOrderData.call().createdAt.toUtc().toLocal()), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Divider(thickness: 2, color: Colors.grey.shade200),
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Status:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                      _buildStatus()
                                    ],
                                  ),
                                ),
                                _.activeOrderData.call().reason == null ? Container() : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Divider(thickness: 2, color: Colors.grey.shade200),
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Reason:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                          Text(_.activeOrderData.call().reason, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                _.activeOrderData.call().rider != null ? Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Divider(thickness: 2, color: Colors.grey.shade200),
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text('Driver:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                              Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                                              Text(_.activeOrderData.call().rider.user.name, style: TextStyle(color: Colors.black))
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Contact #: ${_.activeOrderData.call().rider.user.number}', style: TextStyle(color: Colors.black, fontSize: 13)),
                                                // Text('Status: On the way to ${_.title}', style: TextStyle(color: Colors.black, fontSize: 13)),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ) : Container(),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Divider(thickness: 2, color: Colors.grey.shade200),
                                ),
                                (_.activeOrderData.call().status != 'pending' && _.activeOrderData.call().activeStore.type != 'mart') || (_.activeOrderData.call().status != 'store-accepted' && _.activeOrderData.call().activeStore.type == 'mart') ? Container() : Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(10),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    color: Colors.blue,
                                    child: Text('Cancel Order', style: TextStyle(color: Colors.white)),
                                    onPressed: _cancelDialog,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(ActiveOrderMenu menu, DashboardController _) {
    return Column(
        children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GestureDetector(child: Icon(Icons.error_outline, color: Colors.red), onTap: () => print('Show dialog')),
            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
            Expanded(
              child: Container(
                child: Text('${menu.quantity}x ${menu.name}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
            Text('₱ ${(double.tryParse(menu.customerPrice) * menu.quantity).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 5, left: 20),
          child: Column(
            children: [
              menu.additionals.isEmpty ? Container() :
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Adds-on:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                  Column(
                    children: menu.additionals.map((e) => _buildAddsOn(e, menu.quantity)).toList(),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Column(
                children: menu.choices.map((e) => _buildChoice(e, menu.quantity)).toList(),
              ),
            ],
          )
        ),
        menu.note.toString() != 'N/A' ? Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Special Request', style: TextStyle(fontStyle: FontStyle.italic)),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all()
                ),
                child: Text(menu.note.toString())
              ),
            ],
          ),
        ) : Container(),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Divider(thickness: 2, color: Colors.grey.shade200),
        ),
        _.activeOrderData.call().fee.discountCode.isNotEmpty ? Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Promo Code', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(_.activeOrderData.call().fee.discountCode)
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Divider(thickness: 2, color: Colors.grey.shade200),
              ),
            ],
          ),
        ) : Container()
      ]
    );
  }

  Widget _buildStatus() {
    switch (controller.activeOrderData.call().status) {
      case 'pending': return Text('Waiting for restaurant...', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15));
        break;
      case 'store-accepted': return Text('Waiting for rider...', style: TextStyle(color: controller.activeOrderData.call().activeStore.type == 'mart' ? Colors.orange : Colors.green, fontWeight: FontWeight.bold, fontSize: 15));
        break;
      case 'store-declined': return Text('Your order has been declined by the Restaurant', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15));
        break;
      case 'rider-accepted': return Text('Driver is on the way to pick up your order...', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15));
        break;
      case 'rider-picked-up': return Text('Driver is on the way to your location...', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15));
        break;
      case 'delivered': return Text('Delivered', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15));
        break;
      case 'cancelled': return Text('Cancelled', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15));
        break;
      default: return Text('Waiting for rider...', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15));
    }
  }

  // Widget _buildAdditional(Additional additional, int quantity) {
  //   return additional.picks.isNotEmpty ? Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('${additional.name}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
  //       Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
  //       Expanded(
  //         child: Column(
  //           children: additional.picks.map((e) =>cc).toList()
  //         ),
  //       ),
  //     ],
  //   ) : Container();
  // }

  Widget _buildChoice(Choice choice, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Text('${choice.name}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
              Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
              Text('${choice.pick}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
            ],
          )
        ),
        Text('₱ ' + double.parse('${(double.tryParse(choice.customerPrice) * quantity).toStringAsFixed(2)}').toStringAsFixed(2), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
      ],
    );
  }

  Widget _buildAddsOn(Additional additional, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(additional.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.start),
            ),
          ),
        ),
        Text('₱ ' + double.parse('${(double.tryParse(additional.customerPrice) * quantity)}').toStringAsFixed(2), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
      ],
    );
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