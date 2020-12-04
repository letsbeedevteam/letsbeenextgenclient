import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/getCart.dart';
import 'package:letsbeeclient/screens/cart/cart_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class CartPage extends GetView<CartController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0.0,
        centerTitle: false,
        leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => Get.back()),
        title: GetBuilder<CartController>(
          builder: (_) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DELIVER TO: ', style: TextStyle(fontSize: 13)),
                Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Text(controller.userCurrentAddress.value, style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                )
              ],
            );
          },
        )
      ),
      body: GetBuilder<CartController>(
        builder: (_) {
          return RefreshIndicator(
            onRefresh: () {
              _.fetchActiveCarts();
              return _.refreshCompleter.future;
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: _.cart.value.data.isNotEmpty ? 
                Column(
                  children: [
                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 15),
                    //   child: Center(child: Text('Army Navy Burger + Burrito', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))),
                    // ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Items', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(
                            height: 30,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                              child: _.isEdit.value ? Text('Cancel Edit', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)) : Text('Edit', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                              onPressed: controller.setEdit,
                            )
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(children: _.cart.value.data.map((e) => _buildMenuItem(e, _)).toList())
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            height: _.isEdit.value ? 0 : 100,
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
                                      onPressed: () => _.isEdit.value ? null : print('Promo code')
                                    )
                                  )
                                ),
                                Expanded(child: Divider(thickness: 2, color: _.isEdit.value ? Colors.white : Colors.grey.shade200))
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Sub Total', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Text('₱ ${_.totalPrice.value}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Delivery Fee', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Text('₱ 0.00', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                ],
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                height: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('TOTAL', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Text('₱ ${_.totalPrice.value}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Divider(thickness: 2, color: _.isEdit.value ? Colors.white : Colors.grey.shade200),
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
                                      Text('Name: Let\'s Bee', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                                      Text('Contact #: +23542345345345', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          IgnorePointer(
                            ignoring: _.isLoading.value || _.isEdit.value,
                            child: Container(
                              width: Get.width,
                              child: RaisedButton(
                                color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text('PROCEED TO PAYMENT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
                                ),
                                onPressed: () => paymentBottomsheet(_.cart.value.data.first.restaurantId)
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ) : Container(height: 250,child: Center(child: _.isLoading.value ? Image.asset(cupertinoActivityIndicatorSmall) : Text(_.message.value, style: TextStyle(fontSize: 20))))
              )
            ),
          );
        }
      ),
    );
  }

  Widget _buildMenuItem(CartData cart, CartController _) {
    return Container(
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
                      child: GestureDetector(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: controller.isEdit.value ? Colors.grey.shade300 : Colors.white,
                          ),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.all(controller.isEdit.value ? 10 : 0),
                          child: Container(
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
                                        child: Text('${cart.quantity}x ${cart.menuDetails.name}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                                      ),
                                    ),
                                    Text('₱ ' + double.parse('${cart.menuDetails.price * cart.quantity}').toStringAsFixed(2), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))
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
                                        children: cart.choices.map((e) => _buildChoice(e)).toList(),
                                      ),
                                    ],
                                  )
                                ),
                                cart.note != 'N/A' ? Container(
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
                                        child: Text(cart.note.toString())
                                      ),
                                    ],
                                  ),
                                ) : Container()
                              ],
                            ),
                          )
                        ),
                        onTap: () => _.isEdit.value ? Get.toNamed(Config.MENU_ROUTE, arguments: {
                          'type': 'edit',
                          'restaurant_id': cart.restaurantId,
                          'restaurant_menu_id': cart.restaurantMenuId,
                          'cart': cart.toJson()
                        }) : null,
                      ),
                    ),
                    controller.isEdit.value ? Padding(padding: EdgeInsets.symmetric(horizontal: 10)) : Container(),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 100),
                      child: controller.isEdit.value ? 
                      GestureDetector(key: UniqueKey(), child: Icon(Icons.delete, color: Colors.red), onTap: () => deleteDialog(menu: '${cart.quantity}x ${cart.menuDetails.name}', cartId: cart.id)) : Container(key: UniqueKey())
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Divider(thickness: 2, color: _.isEdit.value ? Colors.white : Colors.grey.shade200),
                ),
              ],
            ),
          )
        ],
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
            child: Text(pick.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
        Text('₱ ' + double.parse('${pick.price * quantity}').toStringAsFixed(2), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
      ],
    );
  }

  Widget _buildChoice(Choice choice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: Text('${choice.name}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ),
        Text(choice.pick, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
      ],
    );
  }

  deleteDialog({String menu, int cartId}) {
    Get.defaultDialog(
      content: GetBuilder<CartController>(
        builder: (_) {
          return  Column(
            children: [
              Text('Are you sure want to delete this item?'),
              Text('($menu)'),
              _.isLoading.value ? Text('Loading..') : Container()
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
          if (!controller.isLoading.value) Get.back();
        }
      ),
      confirm: RaisedButton(
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text('Delete'), 
        onPressed: () {
          if (!controller.isLoading.value) controller.deleteCart(cartId: cartId);
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
          image: DecorationImage(
            image: ExactAssetImage(Config.PNG_PATH + 'letsbee_bg.png'),
            fit: BoxFit.cover
          )
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
                child: Padding(
                  padding: EdgeInsets.all(13),
                  child: Text('Cash On Delivery', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                onPressed: () => controller.paymentMethod(restaurantId, 'cod'),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 380,
                    child: Text('Note: For cancellation of online payment, it will take 5 to 7 days for refund.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
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
                      child: Padding(
                        padding: EdgeInsets.all(13),
                        child: Text('Credit or Debit Card', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      onPressed: () => print('Card'),
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
                      child: Padding(
                        padding: EdgeInsets.all(13),
                        child: Text('Gcash', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      onPressed: () => controller.paymentMethod(restaurantId, 'gcash'),
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
                      child: Padding(
                        padding: EdgeInsets.all(13),
                        child: Text('Paypal', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      onPressed: () => controller.paymentMethod(restaurantId, 'paypal'),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                ],
              ),
            )
          ],
        )
      ),
      isDismissible: false
    );
  }
}