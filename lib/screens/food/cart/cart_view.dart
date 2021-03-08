import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
// import 'package:letsbeeclient/models/active_cart_response.dart';
import 'package:letsbeeclient/models/store_response.dart';
// import 'package:letsbeeclient/_utils/extensions.dart';
// import 'package:letsbeeclient/models/getCart.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';
import 'package:letsbeeclient/screens/food/cart/cart_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class CartPage extends GetView<CartController> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.onWillPopBack,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0.0,
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () {
            controller.isEdit(false);
            Get.back(closeOverlays: true);
          }),
          title: Text(tr('myCart'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          bottom: PreferredSize(
            child: Container(height: 1, color: Colors.grey.shade200),
            preferredSize: Size.fromHeight(4.0)
          ),
        ),
        body: GetX<CartController>(
          initState: (state) => controller.getProducts(),
          builder: (_) {
            return _.updatedProducts.call().isEmpty ? Container(
              width: Get.width,
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  _buildDeliverTo(),
                  Image.asset(Config.PNG_PATH + 'empty_cart.png', height: Get.height * 0.4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(tr('emptyCart'), style: TextStyle(fontSize: 18, color: Colors.black), textAlign: TextAlign.center),
                  ),
                ],
              )
            ) : _scrollView(_);
          }
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
                  Text('${tr('deliverTo')}: ', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => Get.toNamed(Config.ADDRESS_ROUTE),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 25,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Color(Config.LETSBEE_COLOR),
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_.userCurrentNameOfLocation.call(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black), overflow: TextOverflow.ellipsis),
                          RotatedBox(
                            quarterTurns: 3,
                            child: Icon(Icons.chevron_left),
                          )
                        ],
                      ),
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
              Divider(thickness: 1, color: Colors.grey.shade200)
            ],
          ),
        );
      },  
    );
  }

  Widget _header() {
    return Column(
      children: [
        _buildDeliverTo(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${tr('orderSummary')}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
              Obx(() {
                return IgnorePointer(
                  ignoring: controller.isLoading.call(),
                  child: SizedBox(
                    height: 30,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Color(Config.LETSBEE_COLOR),
                      child: controller.isEdit.call() ? Text(tr('cancel'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)) : Text(tr('edit'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                      onPressed: controller.setEdit,
                    )
                  ),
                );
              })
            ],
          ),
        ),
      ],
    );
  }

  Widget _footer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.isEdit.call() ? Divider(thickness: 1, color: Colors.grey.shade200) : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${tr('subTotal')}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                Text('₱${(controller.subTotal.call() + controller.choicesTotalPrice.call() + controller.additionalTotalPrice.call()).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${tr('deliveryFee')}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                Text('₱0.00', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Divider(thickness: 1, color:  Colors.grey.shade200),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${tr('total')}:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                  Text('₱${(controller.totalPrice.call() + controller.choicesTotalPrice.call() + controller.additionalTotalPrice.call()).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
                ],
              ),
            ),
            SizedBox(height: 20)
          ],
        );
      }),
    );
  }

  Widget _scrollView(CartController _) {
    return Column(
      children: [
        _.updatedProducts.call().isEmpty ? Container(height: Get.height, child: Text('No list of carts', style: TextStyle(fontSize: 18))) :
        Expanded(
          flex: 8,
          child: SingleChildScrollView(
            physics: _.updatedProducts.call().isEmpty ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  _header(),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: _.updatedProducts.call().map((e) => _buildMenuItem(e, _)).toList()
                    )
                  ),
                  _footer()
                ],
              ),
            )
          ),
        ),
        Expanded(
          child: _.updatedProducts.call().isNotEmpty ? Container(
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
                    child: Text(_.isEdit.call() ? tr('done') : _.isPaymentLoading.call() ? tr('orderProcessing') : tr('placeOrder'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  onPressed: () => _.isEdit.call() ? _.setEdit() : paymentBottomsheet(_.updatedProducts.call().first.storeId)
                ),
              ),
            ),
          ) : Container(),
        )
      ],
    );
  }

  Widget _buildMenuItem(Product product, CartController _) {
    return IgnorePointer(
      ignoring: !_.isEdit.call(),
      child: GestureDetector(
        onTap: () => _bottomSheet(product),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
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
                            Expanded(
                              child: Container(
                                child: Text('${product.quantity}x ${product.name}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                              ),
                            ),
                            Text('₱${(double.tryParse(product.customerPrice) * product.quantity).toStringAsFixed(2)}' , style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14))
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                              Column(
                                children: product.choices.map((e) => _buildChoice(e, product.quantity)).toList(),
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                              product.additionals.where((data) => !data.selectedValue).isEmpty ? Container() : Column(
                                children: product.additionals.where((data) => !data.selectedValue).map((e) => _buildAddsOn(e, product.quantity)).toList(),
                              ),
                            ],
                          )
                        ),
                        product.note != null ? Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tr('specialInstructions'), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black)),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                color: _.isEdit.call() ? Colors.grey.shade200 : Color(Config.WHITE),
                                child: Text(product.note.toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey))
                              ),
                            ],
                          ),
                        ) : Container(),
                        Divider(thickness: 1, color: Colors.grey.shade200),
                      ],
                    ),
                  )
                ),
              ),
              _.isEdit.call() ? Padding(padding: EdgeInsets.only(left: 5)) : Container(),
              Container(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 100),
                  child: controller.isEdit.call() ? 
                  GestureDetector(
                    key: UniqueKey(), 
                    child: Icon(Icons.cancel_outlined, color: Colors.black), onTap: () => deleteDialog(menu: '${product.quantity}x ${product.name}', uniqueId: product.uniqueId)) : Container(key: UniqueKey())
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddsOn(Additional additional, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(additional.name, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 13), textAlign: TextAlign.start),
        ),
        Text('₱' + '${(double.tryParse(additional.customerPrice.toString()) * quantity).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14))
      ],
    );
  }

  Widget _buildChoice(Choice choice, int quantity) {
    return choice.options.isNotEmpty ? Column(
      children: choice.options.where((data) => data.name == data.selectedValue).map((data) =>  _buildOptions(data, quantity)).toList()
    ) : Container();
  }

  Widget _buildOptions(Option option, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(option.name, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 13), textAlign: TextAlign.start)
        ),
        Text('₱' + double.tryParse('${(double.tryParse(option.customerPrice.toString()) * quantity).toStringAsFixed(2)}').toStringAsFixed(2), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14))
      ],
    );
  }

  deleteDialog({String menu, String uniqueId}) {
    Get.defaultDialog(
      content: GetX<CartController>(
        builder: (_) {
          return  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(tr('confirmDeleteItem'), textAlign: TextAlign.center),
              Padding(padding: EdgeInsets.symmetric(vertical: 2)),
              Text('($menu)'),
              _.isLoading.call() ? Text(tr('loading')) : Container()
            ],
          );
        },
      ),
      title: tr('deleteItem'),
      barrierDismissible: false,
      confirmTextColor: Colors.black,
      cancelTextColor: Colors.black,
      cancel: RaisedButton(
        color: Color(Config.LETSBEE_COLOR),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(tr('cancel')), 
        onPressed: () {
          if (!controller.isLoading.call()) Get.back();
        }
      ),
      confirm: RaisedButton(
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(tr('delete')), 
        onPressed: () => controller.deleteCart(uniqueId: uniqueId)
      ),
    );
  }

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
                child: Center(child:  Text(tr('selectPayment'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),),
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
                      child: Text(tr('cod'), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13)),
                    ),
                  ],
                ),
                onPressed: () => controller.paymentMethod(storeId, 'cod'),
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

  Widget _buildRequiredItem(Choice choice) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${choice.name}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18)),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(Config.LETSBEE_COLOR),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(tr('required'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: choice.options.map((e) {
                return RadioListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(e.name, style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500))),
                      Text(e.customerPrice == 0.00 ? '+ ₱0.00' : '+ ₱${e.customerPrice}', style: TextStyle(color: Colors.black.withOpacity(0.35), fontSize: 14))
                    ],
                  ),
                  value: e.name,
                  groupValue: e.selectedValue,
                  onChanged: (value) => controller.updateChoices(choice.id, e)
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOptionalItem(Additional additional) {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(additional.name, style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500))),
              Text(additional.customerPrice == 0.00 ? '+ ₱0.00' : '+ ₱${additional.customerPrice}', style: TextStyle(color: Colors.black.withOpacity(0.35), fontSize: 14))
            ],
          ),
          value: !additional.selectedValue, 
          onChanged: (value) => controller.updateAdditionals(additional.id, additional),
        ),
      ),
    );
  }

  Widget _storeProductBuild(Product product) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(product.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(product.description, style: TextStyle(fontSize: 13 ,fontWeight: FontWeight.normal), textAlign: TextAlign.start),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Text('₱ ${product.customerPrice}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                        )
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: FadeInImage.assetNetwork(
                        placeholder: cupertinoActivityIndicatorSmall, 
                        image: product.image, 
                        fit: BoxFit.fitWidth, 
                        height: 120, 
                        width: 140, 
                        placeholderScale: 5, 
                        imageErrorBuilder: (context, error, stackTrace) => Container(
                          width: 140,
                          height: 120,
                          child: Center(child: Icon(Icons.image_not_supported_outlined, size: 35)),
                        )
                      ),
                    ),
                  )
                ]
              ),
            ),
            Divider(),
            product.choices.isNotEmpty ? Column(
              mainAxisSize: MainAxisSize.min,
              children: product.choices.map((e) => _buildRequiredItem(e)).toList()
            ) : Container(),
            product.additionals.isNotEmpty ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr('addsOn'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18)),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text(tr('optional'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('${tr('selectUpTo')} ${product.additionals.length}', style: TextStyle(color: Colors.black.withOpacity(0.35), fontSize: 14)),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                  children: product.additionals.map((e) => _buildOptionalItem(e)).toList()
                ),
              ],
            ) : Container(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tr('specialInstructions'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18)),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text(tr('optional'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: TextFormField(
                    controller: controller.tFRequestController,
                    decoration: InputDecoration(
                      hintText: tr('exampleInstruction'),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 0, 
                          color: Colors.black
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 0, 
                          color: Colors.black
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: EdgeInsets.only(top: 10, left: 10, bottom: 10)
                    ),
                    keyboardType: TextInputType.text,
                    enableSuggestions: false,
                    textAlign: TextAlign.start,
                    cursorColor: Colors.black,
                  )
                ),
              ],
            ) ,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(tr('proceedIfNotAvail'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18))
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  child: GetX<CartController>(
                    builder: (_) {
                      return Column(
                        children: [
                          RadioListTile(
                            title: Text(tr('removeThisTime'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                            value: 'Remove this time',
                            groupValue: _.isSelectedProceed.call(),
                            onChanged: (value) =>  _.isSelectedProceed(value)
                          ),
                          RadioListTile(
                            title: Text(tr('cancelEntireOrder'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                            value: 'Cancel the entire order',
                            groupValue: _.isSelectedProceed.call(),
                            onChanged: (value) => _.isSelectedProceed(value)
                          )
                        ],
                      );
                    }
                  )
                ),
              ],
            ) 
          ],
        ),
      ),
    );
  }

  _bottomSheet(Product product) {
    Get.bottomSheet(
      GetX<CartController>(
        initState: (state) => controller.refreshProduct(product),
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    controller.getProducts();
                    Get.back();
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: Get.width
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Container(
                    height: Get.height * 0.85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      color: Color(Config.WHITE)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: _storeProductBuild(_.product.call())),
                        Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Container(
                            width: Get.width,
                            height: 60,
                            color: Colors.white,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(Config.WHITE)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.white
                                          ),
                                          child: IconButton(icon: Icon(Icons.remove, size: 15), onPressed: () => controller.decrement())
                                        ),
                                        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                        Text('${_.quantity.call()}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Color(Config.LETSBEE_COLOR)
                                          ),
                                          child: IconButton(icon: Icon(Icons.add, size: 15), onPressed: () => controller.increment())
                                        ),
                                        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                      ],
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => controller.updateCart(controller.product.call()),
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Color(Config.LETSBEE_COLOR)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(tr('updateCart'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                            Text('₱ ${((_.totalPriceOfChoice.call() + _.totalPriceOfAdditional.call() + double.tryParse(_.product.call().price)) * _.quantity.call()).toStringAsFixed(2)}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ],
                                        )
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
              ),
            ],
          );
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
    );
  }
}