import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/active_order_response.dart';
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
          child: Container(height: 1, color: Colors.grey.shade200),
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
              child: (controller.activeOrderData.call().status != 'pending' && controller.activeOrderData.call().activeStore.type != 'mart') || (controller.activeOrderData.call().status != 'store-accepted' && controller.activeOrderData.call().activeStore.type == 'mart') ? Container(
                width: Get.width,
                child: IgnorePointer(
                  ignoring: controller.activeOrderData.call().rider == null || controller.activeOrderData.call().status == 'delivered',
                  child: _messageRider()
                )
                ) : Container( width: Get.width, child: _cancelOrder()),
              ),
            ) 
          ],
        );
      })
    );
  }

  Widget _cancelOrder() {
    return RaisedButton(
      splashColor: Colors.transparent,
      color: Color(Config.RED),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(tr('cancelOrder'), style: TextStyle(color: Color(Config.WHITE), fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      onPressed: _cancelDialog
    );
  }

  Widget _messageRider() {
    return RaisedButton(
      splashColor: Colors.transparent,
      color: controller.activeOrderData.call().status == 'rider-accepted' || controller.activeOrderData.call().status == 'rider-picked-up' ? Color(Config.LETSBEE_COLOR): Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(tr('messageRider'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      onPressed: () => controller.goToChatPage(fromNotificartion: false)
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
                    Container(height: 1, color: Colors.grey.shade200),
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
            Text(controller.activeOrderData.call().status == 'delivered' ? '${tr('deliveredAt')}:' : '${tr('deliverAt')}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
            Padding(padding: EdgeInsets.symmetric(vertical: 2)),
            Row(
              children: [
                Image.asset(Config.PNG_PATH + 'address.png', height: 18, width: 18),
                Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                Expanded(child: Text(controller.activeOrderData.call().address.completeAddress, style: TextStyle(fontSize: 14, color: Color(Config.USER_CURRENT_ADDRESS_TEXT_COLOR), fontWeight: FontWeight.normal), overflow: TextOverflow.ellipsis)),
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Container(height: 1, color: Colors.grey.shade200),
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
                              TextSpan(text: '${tr('yourRider')}: ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13)),
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
                            Expanded(child: Text(tr('trackRider'), style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w500), textAlign: TextAlign.center))
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
            Container(height: 1, color: Colors.grey.shade200),
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
            Text(tr('orderSummary'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
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
                      Text('${tr('subTotal')}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                      Text('₱${controller.activeOrderData.call().fee.subTotal}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${tr('deliveryFee')}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                      Text('₱${controller.activeOrderData.call().fee.delivery}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Divider(thickness: 1, color: Colors.grey.shade200),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${tr('total')}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                        Text('₱${controller.activeOrderData.call().fee.customerTotalPrice}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMenu(ActiveOrderProduct product) {
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
                  children: product.variants.map((e) => _buildChoice(e, product.quantity)).toList(),
                ),
              ],
            )
          ),
          product.note.isNotEmpty ? Container(
            margin: EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr('specialInstructions'), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black)),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: Text(product.note.toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.grey))
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Divider(thickness: 1, color: Colors.grey.shade200),
                )
              ],
            ),
          ) : Container(
            margin: EdgeInsets.only(top: 5),
            child: Divider(thickness: 1, color: Colors.grey.shade200),
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

  Widget _buildChoice(Variants choice, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text('${choice.pick}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 13))
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
            height: 180,
            margin: EdgeInsets.only(bottom: 30),
            child: Image.asset(Config.GIF_PATH + 'waiting.gif'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(tr('waitingRestaurant'), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
        ],
      );
        break;
      case 'store-accepted': return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 180,
            margin: EdgeInsets.only(bottom: 30),
            child:  _.activeOrderData.call().activeStore.type == 'mart' ? Image.asset(Config.GIF_PATH + 'waiting.gif') : Image.asset(Config.GIF_PATH + 'preparing.gif')
          ),
          Text(_.activeOrderData.call().activeStore.type == 'mart' ? tr('waitingRider') : tr('preparingFood'), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          // Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          // _.activeOrderData.call().activeStore.type == 'mart' ? Container() : Text(tr('waitingRider'), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.normal))
        ],
      );
        break;
      case 'store-declined': return Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Icon(Icons.cancel_outlined, size: 150, color: Colors.red),
          ),
          Text(tr('restaurantDeclined'), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text('${tr('reason')}: ${_.activeOrderData.call().reason}', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ],
      );
        break;
      case 'rider-accepted': return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 180,
            margin: EdgeInsets.only(bottom: 30),
            child: _.activeOrderData.call().activeStore.type == 'mart' ? Image.asset(Config.GIF_PATH + 'mart.gif') : Image.asset(Config.GIF_PATH + 'preparing.gif')
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(tr(_.activeOrderData.call().activeStore.type == 'mart' ? 'preparingGrocery' : 'preparingFood'), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
        ],
      );
        break;
      case 'rider-picked-up': return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 180,
            margin: EdgeInsets.only(bottom: 30),
            child: Image.asset(Config.GIF_PATH + 'motor.gif')
          ),
          Text(tr('riderPickUp'), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ],
      );
        break;
      case 'delivered': return Column(
        children: [
          Container(
            height: 180,
            margin: EdgeInsets.only(bottom: 30),
            child: _.activeOrderData.call().activeStore.type == 'mart' ? Image.asset(Config.GIF_PATH + 'mart_delivered.gif') : Image.asset(Config.GIF_PATH + 'delivered.gif')
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(tr('riderDelivered'), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
        ],
      );
        break;
      default: return Column(
        children: [
          Container(
            height: 180,
            margin: EdgeInsets.only(bottom: 30),
            child: Image.asset(Config.GIF_PATH + 'waiting.gif')
          ),
          Text(tr('waitingRider'), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.bold)),
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
              color: Colors.white
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tr('reasonTitle'), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.center),
                Padding(padding: EdgeInsets.all(10)),
                Obx(() => _listOfRadio()),
                Padding(padding: EdgeInsets.all(5)),
                Flexible(child: _cancelAndProceedButtons())
              ],
            ),
          ),
        ),
      ),
      name: 'cancel-dialog'
    );
  }

  Widget _listOfRadio() {
    return Column(
      children: [
        RadioListTile(
          value: 'Reason 1',
          title: Text('Reason 1', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.start),
          groupValue: controller.reason.call(),
          onChanged: (value) => controller..reasonController.clear()..reason(value),
        ),
        RadioListTile(
          value: 'Reason 2',
          title: Text('Reason 2', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.start),
          groupValue: controller.reason.call(),
          onChanged: (value) => controller..reasonController.clear()..reason(value),
        ),
        RadioListTile(
          value: 'Reason 3',
          title: Text('Reason 3', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.start),
          groupValue: controller.reason.call(),
          onChanged: (value) => controller..reasonController.clear()..reason(value),
        ),
        RadioListTile(
          value: 'Others',
          title: Text('${tr('others')} (Please Specify)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.start),
          groupValue: controller.reason.call(),
          onChanged: (value) => controller.reason(value),
        ),
        controller.reason.call() == 'Others' ? Container(
          child: _otherField(),
        ) : Container()
      ],
    );
  }

  Widget _otherField() {
    return SizedBox(
      height: 40,
      child: TextFormField(
        controller: controller.reasonController,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        keyboardType: TextInputType.text, 
        textInputAction: TextInputAction.done,
        enableSuggestions: false,
        autocorrect: false,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          fillColor: Color(Config.WHITE),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
          ),
          contentPadding: EdgeInsets.only(left: 15, right: 15)
        )
      )
    );
  }

  Widget _cancelAndProceedButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),
            color: Color(Config.LETSBEE_COLOR),
            child: Text(tr('close'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
            onPressed: () {
              controller.reason.nil();
              if (Get.isSnackbarOpen) {
                Get.back();
                Future.delayed(Duration(milliseconds: 500));
                Get.back();
              } else {
                Get.back();
              }
            },
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),
            color: Color(Config.RED),
            child: Obx(() => Text(controller.isCancelOrderLoading.call() ? tr('loading') : tr('proceed'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
            onPressed: () => controller.isCancelOrderLoading.call() ? null : controller.cancelOrderById(),
          )
        ],
      ),
    );
  }
}