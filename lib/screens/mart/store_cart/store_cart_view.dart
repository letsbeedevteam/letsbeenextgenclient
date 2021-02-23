import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/store_response.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/mart/store_cart/store_cart_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class StoreCartPage extends GetView<StoreCartController> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.onWillPopBack,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () {
            controller.isEdit(false);
            Get.back(closeOverlays: true);
          }),
          centerTitle: true,
          title: Text('My Cart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          bottom: PreferredSize(
            child: Divider(thickness: 2, color: Colors.grey.shade200),
            preferredSize: Size.fromHeight(4.0)
          ),
        ),
        body: GetX<StoreCartController>(
          builder: (_) {
            return _.updatedProducts.call().isEmpty ? Container(
              width: Get.width,
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  _buildDeliverTo(),
                  Image.asset(Config.PNG_PATH + 'empty_cart.png', height: Get.height * 0.4),
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: const Text('Your cart is empty. Add items to get started.', style: TextStyle(fontSize: 18, color: Colors.black), textAlign: TextAlign.center),
                  ),
                ],
              )
            ) : _scrollView(_);
          },
        ),
      ),
    );
  }

  Widget _buildDeliverTo() {
    return GetX<DashboardController>(
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Deliver to: ', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 20,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Color(Config.LETSBEE_COLOR),
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_.userCurrentNameOfLocation.call() == null ? 'Home' : _.userCurrentNameOfLocation.call(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 2)),
              Row(
                children: [
                  Image.asset(Config.PNG_PATH + 'address.png', height: 18, width: 18),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                  Expanded(child: Text(_.userCurrentAddress.call(), style: TextStyle(fontSize: 14, color: Color(Config.USER_CURRENT_ADDRESS_TEXT_COLOR), fontWeight: FontWeight.normal), overflow: TextOverflow.ellipsis)),
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 2)),
              Divider(thickness: 2, color: Colors.grey.shade200)
            ],
          ),
        );
      },  
    );
  }

  Widget _scrollView(StoreCartController _) {
    final activeCart = _.updatedProducts.call().where((data) => !data.isRemove && data.storeId == _.storeId.call());
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SingleChildScrollView(
          physics: activeCart.isEmpty ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
          child: Container(
            height: Get.height,
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                _buildDeliverTo(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order Summary:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                      IgnorePointer(
                        ignoring: _.isLoading.call(),
                        child: SizedBox(
                          height: 30,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            color: Color(Config.LETSBEE_COLOR),
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
                  child: Column(children: activeCart.map((e) => _buildMenuItem(e, _)).toList())
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AnimatedContainer(
                      //   duration: Duration(milliseconds: 500),
                      //   height: _.isEdit.call() ? 0 : 100,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Expanded(child: Text('Want to use Promo code?', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),),
                      //       Expanded(
                      //         child: Center(
                      //           child: RaisedButton(
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(25),
                      //             ),
                      //             color: Color(Config.LETSBEE_COLOR),
                      //             child: Text('Use', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                      //             onPressed: () => _.isEdit.call() ? null : print('Promo code')
                      //           )
                      //         )
                      //       ),
                      //       Expanded(child: Divider(thickness: 2, color: _.isEdit.call() ? Colors.transparent : Colors.grey.shade200))
                      //     ],
                      //   ),
                      // ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Sub Total:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                              Text('₱${(_.subTotal.call()).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
                            ],
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Delivery Fee:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                              Text('₱0.00', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Divider(thickness: 2, color:  Colors.grey.shade200),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                                Text('₱${(_.totalPrice.call()).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
                              ],
                            ),
                          )
                        ],
                      ),
                      // Container(
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text('Delivery Details:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                      //       Container(
                      //         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text('Name: ${_.box.read(Config.USER_NAME)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                      //             Text('Contact #: ${_.box.read(Config.USER_MOBILE_NUMBER)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
                      //           ],
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: IgnorePointer(
            ignoring: _.isLoading.call() || _.isPaymentLoading.call(),
            child: Container(
              width: Get.width,
              child: RaisedButton(
                color: Color(Config.LETSBEE_COLOR),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(_.isEdit.call() ? 'Done' : 'Place Order', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                onPressed: () => _.isEdit.call() ? _.setEdit() : paymentBottomsheet(activeCart.first.storeId)
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMenuItem(Product product, StoreCartController _) {
    return IgnorePointer(
      ignoring: !_.isEdit.call(),
      child: GestureDetector(
        onTap: () =>  updateCart(product: product),
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
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
                              color: controller.isEdit.call() ? Colors.grey.shade200 : Color(Config.WHITE),
                              boxShadow: [
                                BoxShadow(
                                  color: controller.isEdit.call() ? Colors.grey.shade300 : Color(Config.WHITE),
                                  blurRadius: controller.isEdit.call() ? 1.0 : 0.0,
                                  offset: controller.isEdit.call() ? Offset(2.0, 4.0) : Offset(0.0, 0.0)
                                )
                              ]
                            ),
                            curve: Curves.easeInOut,
                            child: Container(
                              padding: _.isEdit.call() ? EdgeInsets.all(5) : EdgeInsets.zero,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // GestureDetector(child: Icon(Icons.error_outline, color: Colors.red), onTap: () => print('Show dialog')),
                                      Expanded(
                                        child: Container(
                                          child: Text('${product.quantity}x ${product.name}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                                        ),
                                      ),
                                      Text('₱${(double.tryParse(product.customerPrice) * product.quantity).toStringAsFixed(2)}' , style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14))
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ),
                        ),
                        _.isEdit.call() ? Padding(padding: EdgeInsets.only(left: 5)) : Container(),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 100),
                          child: controller.isEdit.call() ? 
                          GestureDetector(key: UniqueKey(), child: Icon(Icons.cancel_outlined, color: Colors.black), onTap: () {
                            deleteDialog(menu: '${product.quantity}x ${product.name}', productId: product.id);
                          }) : Container(key: UniqueKey())
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Divider(thickness: 2, color: Colors.grey.shade200),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildAddsOn(ActiveCartAdditional additional, int quantity) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Expanded(
  //         child: Container(
  //           child: Padding(
  //             padding: EdgeInsets.only(left: 20),
  //             child: Text(additional.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.start),
  //           ),
  //         ),
  //       ),
  //       Text('₱ ' + '${(double.tryParse(additional.price) * quantity).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14))
  //     ],
  //   );
  // }

  // Widget _buildChoice(ActiveCartChoice choice, int quantity) {
  //   final price = double.tryParse('${(double.tryParse(choice.price) * quantity).toStringAsFixed(2)}').toStringAsFixed(2);
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Expanded(
  //         child: Row(
  //           children: [
  //             Text('${choice.name}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
  //             Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
  //             Expanded(child: Text('${choice.pick}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)))
  //           ],
  //         )
  //       ),
  //       Text(price == '0.00' ? '': '₱ ' + double.tryParse('${(double.tryParse(choice.price) * quantity).toStringAsFixed(2)}').toStringAsFixed(2), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14))
  //     ],
  //   );
  // }

  paymentBottomsheet(int storeId) {
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(child:  Text('SELECT PAYMENT METHOD', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: RaisedButton(
                color: Color(Config.LETSBEE_COLOR),
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
                onPressed: () => confirmLocationModal(storeId: storeId, paymentMethod: 'cod'),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            // Container(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 10),
            //         child: SizedBox(
            //           width: 300,
            //           child: Text('Reminder: For cancellation of online payment, it will take 5 to 7 days for refund.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 13, fontStyle: FontStyle.italic)),
            //         ),
            //       ),
            //       Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  // Container(
                  //   width: Get.width,
                  //   padding: EdgeInsets.symmetric(horizontal: 30),
                  //   child: RaisedButton(
                  //     color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       // crossAxisAlignment: CrossAxisAlignment.center,
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Expanded(
                  //           flex: 1,
                  //           child: SizedBox(
                  //             height: 30,
                  //             width: 30,
                  //             child: Image.asset(Config.PNG_PATH + 'debit_card.png'),
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 2,
                  //           child: Text('CREDIT / DEBIT CARD', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13)),
                  //         ),
                  //       ],
                  //     ),
                  //     onPressed: () => alertSnackBarTop(title: 'Oops!', message: 'Work in Progress. Please click the CASH ON DELIVERY instead.'),
                  //   ),
                  // ),
                  // Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  // Container(
                  //   width: Get.width,
                  //   padding: EdgeInsets.symmetric(horizontal: 30),
                  //   child: RaisedButton(
                  //     color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       mainAxisSize: MainAxisSize.min,
                  //       // crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Expanded(
                  //           flex: 1,
                  //           child: SizedBox(
                  //             height: 30,
                  //             width: 30,
                  //             child: Icon(FontAwesomeIcons.globeAsia, color: Colors.blue),
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 2,
                  //           child: Text('GCASH', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13)),
                  //         ),
                  //       ],
                  //     ),
                  //     // onPressed: () => confirmLocationModal(restaurantID: restaurantId, paymentMethod: 'gcash'),
                  //     onPressed: () => alertSnackBarTop(title: 'Oops!', message: 'Work in Progress. Please click the CASH ON DELIVERY instead.'),
                  //   ),
                  // ),
                  // Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  // Container(
                  //   width: Get.width,
                  //   padding: EdgeInsets.symmetric(horizontal: 30),
                  //   child: RaisedButton(
                  //     color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       mainAxisSize: MainAxisSize.min,
                  //       // crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Expanded(
                  //           flex: 1,
                  //           child: SizedBox(
                  //             height: 30,
                  //             width: 30,
                  //             child: Image.asset(Config.PNG_PATH + 'paypal.png'),
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 2,
                  //           child: Text('PAYPAL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13)),
                  //         ),
                  //       ],
                  //     ),
                  //     // onPressed: () => confirmLocationModal(restaurantID: restaurantId, paymentMethod: 'paypal'),
                  //     onPressed: () => alertSnackBarTop(title: 'Oops!', message: 'Work in Progress. Please click the CASH ON DELIVERY instead.'),
                  //   ),
                  // ),
                  // Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            //     ],
            //   ),
            // )
          ],
        )
      ),
    );
  }

  confirmLocationModal({int storeId, String paymentMethod}) {
    Get.back();
    Get.dialog(
      AlertDialog(
        content: GetX<StoreCartController>(
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
                        color: Color(Config.LETSBEE_COLOR),
                        onPressed: () {
                          if (Get.isSnackbarOpen) {
                            Get.back();
                            Future.delayed(Duration(milliseconds: 500));
                            Get.back();
                          } else {
                            Get.back();
                          }
                        },
                        child: Text('CANCEL', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        color: Color(Config.LETSBEE_COLOR),
                        onPressed: () {
                          controller
                          ..saveConfirmLocation()
                          ..paymentMethod(storeId, paymentMethod);
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

  deleteDialog({String menu, int productId}) {
    Get.defaultDialog(
      content: GetX<StoreCartController>(
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
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.black,
      cancelTextColor: Colors.black,
      cancel: RaisedButton(
        color: Color(Config.LETSBEE_COLOR),
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
        onPressed: () => controller.deleteCart(productId: productId)
      ),
    );
  }

  updateCart({Product product}) {
    controller.quantity(product.quantity);
    Get.defaultDialog(
      title: '',
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: FadeInImage.assetNetwork(
                placeholder: cupertinoActivityIndicatorSmall, 
                image: product.image, 
                fit: BoxFit.fitHeight,
                height: 150, 
                placeholderScale: 5, 
                imageErrorBuilder: (context, error, stackTrace) => Container(
                  width: 140,
                  height: 120,
                  child: Center(child: Icon(Icons.image_not_supported_outlined, size: 35)),
                )
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text(product.name, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal)),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            GetX<StoreCartController>(
              builder: (_) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    IconButton(icon: Icon(Icons.remove_circle_outline_rounded, size: 30), onPressed: () =>_.decrement()),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade200
                      ),
                      child: Text('${_.quantity.call()}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(icon: Icon(Icons.add_circle_outline_rounded, size: 30), onPressed: () => _.increment()),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  ],
                );
              },
            ),            
          ],
        ),
      ),
      confirm: GetX<StoreCartController>(
        builder: (_) {
          return RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
            child: _.isUpdateCartLoading.call() ? Container(height: 10, width: 10, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black))) : Text('Update cart', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
            onPressed: () => _.updateCartRequest(product: product),
          );
        },
      ),
      cancel: GetX<StoreCartController>(
        builder: (_) {
          return IgnorePointer(
            ignoring: _.isUpdateCartLoading.call(),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
              child: Text('Back', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
              onPressed: () {
                if (Get.isSnackbarOpen) {
                  Get.back();
                  Future.delayed(Duration(milliseconds: 500));
                  Get.back();
                } else {
                  Get.back();
                }
              },
            ),
          );
        },
      ),
      barrierDismissible: false
    );
  }
}