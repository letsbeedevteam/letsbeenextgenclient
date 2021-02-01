import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/getCart.dart';
import 'package:letsbeeclient/screens/cart/cart_controller.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';

class CartPage extends GetView<CartController> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.onWillPopBack,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0.0,
          centerTitle: false,
          leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => Get.back(closeOverlays: true)),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DELIVER TO: ', style: TextStyle(fontSize: 13)),
              Padding(padding: EdgeInsets.symmetric(vertical: 3)),
              GetX<DashboardController>(
                builder: (_) {
                  return Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Text(_.userCurrentAddress.call(), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                  );
                },
              )
            ],
          )
        ),
        body: GetX<CartController>(
          initState: controller.fetchActiveCarts(getRestaurantId: controller.restaurantId.call()),
          builder: (_) {
            return RefreshIndicator(
              onRefresh: () {
                controller.fetchActiveCarts(getRestaurantId: controller.restaurantId.call());
                return _.refreshCompleter.future;
              },
              child: SingleChildScrollView(
                physics: _.cart.call() == null ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: _.cart.call() != null ? 
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Items', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                            IgnorePointer(
                              ignoring: _.isLoading.call(),
                              child: SizedBox(
                                height: 30,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                                  child: _.isEdit.call() ? Text('Cancel', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)) : Text('Edit', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  onPressed: controller.setEdit,
                                )
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(children: _.cart.call().data.map((e) => _buildMenuItem(e, _)).toList())
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              height: _.isEdit.call() ? 0 : 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Text('Want to use Promo code?', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),),
                                  Expanded(
                                    child: Center(
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                                        child: Text('Use', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                        onPressed: () => _.isEdit.call() ? null : print('Promo code')
                                      )
                                    )
                                  ),
                                  Expanded(child: Divider(thickness: 2, color: _.isEdit.call() ? Colors.white : Colors.grey.shade200))
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Sub Total', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Text('₱ ${(_.totalPrice.call()).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Delivery Fee', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Text('₱ ${double.tryParse(_.cart.call().deliveryFee).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('TOTAL', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                      Text('₱ ${(double.tryParse(_.cart.call().deliveryFee) + _.totalPrice.call()).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Divider(thickness: 2, color: _.isEdit.call() ? Colors.white : Colors.grey.shade200),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Delivery Details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Name: ${_.box.read(Config.USER_NAME)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                                        Text('Contact #: +63${_.box.read(Config.USER_MOBILE_NUMBER)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            IgnorePointer(
                              ignoring: _.isLoading.call() || _.isEdit.call() || _.isPaymentLoading.call(),
                              child: Container(
                                width: Get.width,
                                child: RaisedButton(
                                  color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('PROCEED TO PAYMENT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  ),
                                  onPressed: () => paymentBottomsheet(_.cart.call().data.first.restaurantId)
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ) : Container(height: 250,child: Center(child: _.isLoading.call() ? CupertinoActivityIndicator() : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(child: Text('No list of carts', style: TextStyle(fontSize: 18))),
                          RaisedButton(
                            color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                            child: Text('Refresh'),
                            onPressed: () => _.fetchActiveCarts(getRestaurantId: _.restaurantId.call()),
                          )
                        ],
                      )
                    )
                  )
                )
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildMenuItem(CartData cart, CartController _) {
    return GestureDetector(
      onTap: () => Get.toNamed(Config.MENU_ROUTE, arguments: {
        'type': 'edit',
        'restaurant_id': cart.restaurantId,
        'restaurant_menu_id': cart.restaurantMenuId,
        'cart': cart.toJson()
      }),
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: controller.isEdit.call() ? Colors.grey.shade200 : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: controller.isEdit.call() ? Colors.grey.shade300 : Colors.white,
                                blurRadius: controller.isEdit.call() ? 1.0 : 0.0,
                                offset: controller.isEdit.call() ? Offset(2.0, 4.0) : Offset(0.0, 0.0)
                              )
                            ]
                          ),
                          curve: Curves.easeInOut,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // GestureDetector(child: Icon(Icons.error_outline, color: Colors.red), onTap: () => print('Show dialog')),
                                    Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                                    Expanded(
                                      child: Container(
                                        child: Text('${cart.quantity}x ${cart.menuDetails.name}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                      ),
                                    ),
                                    Text('₱ ${(double.tryParse(cart.menuDetails.price) * cart.quantity).toStringAsFixed(2)}' , style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14))
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5, left: 20),
                                  child: Column(
                                    children: [
                                      Column(
                                        children: cart.additionals.map((e) =>  _buildAdditional(e, cart.quantity)).toList(),
                                      ),
                                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                                      Column(
                                        children: cart.choices.map((e) => _buildChoice(e, cart.quantity)).toList(),
                                      ),
                                    ],
                                  )
                                ),
                                cart.note != 'N/A' ? Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Special Request', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(top: 10),
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all()
                                        ),
                                        child: Text(cart.note.toString())
                                      ),
                                    ],
                                  ),
                                ) : Container()
                              ],
                            ),
                          )
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 100),
                        child: controller.isEdit.call() ? 
                        GestureDetector(key: UniqueKey(), child: Icon(Icons.cancel_outlined, color: Colors.black), onTap: () => deleteDialog(menu: '${cart.quantity}x ${cart.menuDetails.name}', cartId: cart.id)) : Container(key: UniqueKey())
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Divider(thickness: 2, color: _.isEdit.call() ? Colors.white : Colors.grey.shade200),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAdditional(Additional additional, int quantity) {
    return additional.picks.isNotEmpty ? Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${additional.name}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
        Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
        Expanded(
          child: Column(
            children: additional.picks.map((e) => _buildAddsOn(e, quantity)).toList()
          ),
        ),
      ],
    ) : Container();
  }

  Widget _buildAddsOn(Pick pick, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: Text(pick.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ),
        Text('₱ ' + '${(double.tryParse(pick.price) * quantity).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14))
      ],
    );
  }

  Widget _buildChoice(Choice choice, int quantity) {
    final price = double.tryParse('${(double.tryParse(choice.price) * quantity).toStringAsFixed(2)}').toStringAsFixed(2);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Text('${choice.name}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
              Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
              Expanded(child: Text('${choice.pick}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)))
            ],
          )
        ),
        Text(price == '0.00' ? '': '₱ ' + double.tryParse('${(double.tryParse(choice.price) * quantity).toStringAsFixed(2)}').toStringAsFixed(2), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14))
      ],
    );
  }

  deleteDialog({String menu, int cartId}) {
    Get.defaultDialog(
      content: GetX<CartController>(
        builder: (_) {
          return  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Are you sure want to delete this item?', textAlign: TextAlign.center),
              Padding(padding: EdgeInsets.symmetric(vertical: 2)),
              Text('($menu)'),
              _.isLoading.call() ? Text('Loading..') : Container()
            ],
          );
        },
      ),
      title: 'Delete Item',
      barrierDismissible: false,
      onConfirm: () => controller.deleteCart(cartId: cartId),
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.black,
      cancelTextColor: Colors.black,
      cancel: RaisedButton(
        color: Color(Config.LETSBEE_COLOR).withOpacity(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text('Cancel'), 
        onPressed: () {
          if (!controller.isLoading.call()) Get.back();
        }
      ),
      confirm: RaisedButton(
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text('Delete'), 
        onPressed: () {
          if (!controller.isLoading.call()) controller.deleteCart(cartId: cartId);
        }
      ),
    );
  }

  paymentBottomsheet(int restaurantId) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          // image: DecorationImage(
          //   image: ExactAssetImage(Config.PNG_PATH + 'letsbee_bg.png'),
          //   fit: BoxFit.cover
          // )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Center(child:  Text('SELECT PAYMENT METHOD', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: RaisedButton(
                color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(Config.PNG_PATH + 'cod.png'),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('CASH ON DELIVERY', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13)),
                    ),
                  ],
                ),
                onPressed: () => confirmLocationModal(restaurantID: restaurantId, paymentMethod: 'cod'),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: 300,
                      child: Text('Reminder: For cancellation of online payment, it will take 5 to 7 days for refund.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 13, fontStyle: FontStyle.italic)),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: RaisedButton(
                      color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset(Config.PNG_PATH + 'debit_card.png'),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('CREDIT / DEBIT CARD', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13)),
                          ),
                        ],
                      ),
                      onPressed: () => alertSnackBarTop(title: 'Oops!', message: 'Work in Progress. Please click the CASH ON DELIVERY instead.'),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: RaisedButton(
                      color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: Icon(FontAwesomeIcons.globeAsia, color: Colors.blue),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('GCASH', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13)),
                          ),
                        ],
                      ),
                      // onPressed: () => confirmLocationModal(restaurantID: restaurantId, paymentMethod: 'gcash'),
                      onPressed: () => alertSnackBarTop(title: 'Oops!', message: 'Work in Progress. Please click the CASH ON DELIVERY instead.'),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: RaisedButton(
                      color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset(Config.PNG_PATH + 'paypal.png'),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('PAYPAL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13)),
                          ),
                        ],
                      ),
                      // onPressed: () => confirmLocationModal(restaurantID: restaurantId, paymentMethod: 'paypal'),
                      onPressed: () => alertSnackBarTop(title: 'Oops!', message: 'Work in Progress. Please click the CASH ON DELIVERY instead.'),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  confirmLocationModal({int restaurantID, String paymentMethod}) {
    Get.back();
    Get.dialog(
      AlertDialog(
        content: GetX<CartController>(
          initState: (state) => controller.getCurrentLocationText(),
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text('Confirm your location', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold))),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Text('Lot No., Block No., Bldg Name, Floor No. / Street', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 30,
                  child: TextFormField(
                    controller: controller.streetTFController,
                    focusNode: controller.streetNode,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15),
                    textInputAction: TextInputAction.next,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: false,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15)
                    ),
                    onEditingComplete: () {
                      controller.barangayTFController.selection = TextSelection.fromPosition(TextPosition(offset: controller.barangayTFController.text.length));
                      controller.barangayNode.requestFocus();
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Text('Barangay / Purok', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 30,
                  child: TextFormField(
                    controller: controller.barangayTFController,
                    focusNode: controller.barangayNode,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15),
                    textInputAction: TextInputAction.next,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: false,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15)
                    ),
                    onEditingComplete: () {
                      controller.cityTFController.selection = TextSelection.fromPosition(TextPosition(offset: controller.cityTFController.text.length));
                      controller.cityNode.requestFocus();
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Text('Municipality / City', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 30,
                  child: TextFormField(
                    controller: controller.cityTFController,
                    focusNode: controller.cityNode,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15),
                    textInputAction: TextInputAction.next,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: false,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15)
                    )
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                        onPressed: () => Get.back(),
                        child: Text('CANCEL'),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                        onPressed: () {
                          controller..saveConfirmLocation()..paymentMethod(restaurantID, paymentMethod);
                        },
                        child: _.isPaymentLoading.call() ? Container(height: 10, width: 10, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black))) : Text('PROCEED', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
      barrierDismissible: true
    );
  }
}