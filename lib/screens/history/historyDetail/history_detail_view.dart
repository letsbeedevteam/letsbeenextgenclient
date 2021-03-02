import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/orderHistoryResponse.dart';
import 'package:letsbeeclient/screens/history/historyDetail/history_detail_controller.dart';
import 'package:intl/intl.dart';
import 'package:loading_gifs/loading_gifs.dart';

class HistoryDetailPage extends GetView<HistoryDetailController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () => Get.back()),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Order Details', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
         child: Container(height: 2, color: Colors.grey.shade200),
          preferredSize: Size.fromHeight(4.0)
        ),
      ),
      body: GetX<HistoryDetailController>(
        builder: (_) {
          return Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text(_.title.call(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17), textAlign: TextAlign.start,),
                                ),
                                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                                Text(DateFormat('MMMM dd, yyyy - hh:mm a').format(_.data.call().createdAt.toUtc().toLocal()), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                Text(_.data.call().products.length == 1 ? '${_.data.call().products.first.quantity}x ${_.data.call().products.first.name}' : '${_.data.call().products.length}x Items', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                                Container(
                                  margin: EdgeInsets.only(right: 10, bottom: 10),
                                  child: Text('₱${_.data.call().fee.customerTotalPrice}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ),
                                _buildStatus(_.data.call().status)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.black, width: 1.5),
                            color: Colors.transparent
                          ),
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: _.data.call().store.logoUrl, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35)))
                          )
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      ],
                    ),
                    Divider(thickness: 2, color: Colors.grey.shade200)
                  ],
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_.data.call().status == 'delivered' ? 'Delivered to:' : 'Deliver to:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                      Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                      Row(
                        children: [
                          Image.asset(Config.PNG_PATH + 'address.png', height: 18, width: 18),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                          Expanded(child: Text('${_.data.call().address.street} ${_.data.call().address.barangay} ${_.data.call().address.city} ${_.data.call().address.state}', style: TextStyle(fontSize: 14, color: Color(Config.USER_CURRENT_ADDRESS_TEXT_COLOR), fontWeight: FontWeight.normal), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Divider(thickness: 2, color: Colors.grey.shade200),
                ),
                Text('Order Summary:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Column(
                  children: _.data.call().products.map((e) => _buildMenu(e)).toList(),
                ),
                _.data.call().reason == null ? Container() : Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Special Instructions', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                      Text(_.data.call().reason, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 13)),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Divider(thickness: 2, color: Colors.grey.shade200),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sub Total:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                          Text('₱${_.data.call().fee.subTotal}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery Fee:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                          Text('₱${_.data.call().fee.delivery}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
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
                            Text('₱${_.data.call().fee.customerTotalPrice}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      )
    );
  }

  Widget _buildStatus(String status) {
    switch (status) {
      case 'store-declined': return Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.red
          ),
          child: Text('Restaurant Declined', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13))
        );
        break;
      case 'delivered': return Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color(Config.LETSBEE_COLOR)
          ),
          child: Text('Delivered', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13))
        );
        break;
      case 'cancelled': return Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.red
          ),
          child: Text('Cancelled', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13))
        );
        break;
      default: return Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.red
          ),
          child: Text('Cancelled', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13))
        );
    }
  }

  Widget _buildMenu(OrderHistoryMenu menu) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: Text('${menu.quantity}x ${menu.name}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15)),
                ),
              ),
              Text('₱${(double.tryParse(menu.customerPrice) * menu.quantity).toStringAsFixed(2)}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15))
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
                  )
                ],
              ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Column(
                  children: menu.choices.map((e) => _buildChoice(e, menu.quantity)).toList(),
                ),
              ],
            )
          ),
          Container(
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
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(additional.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.start),
            ),
          ),
        ),
        Text('₱ ' + double.parse('${(double.tryParse(additional.customerPrice) * quantity).toStringAsFixed(2)}').toStringAsFixed(2), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13))
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
}