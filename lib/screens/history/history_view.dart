import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/orderHistoryResponse.dart';
import 'package:intl/intl.dart';
import 'package:letsbeeclient/screens/history/history_controller.dart';
import 'package:loading_gifs/loading_gifs.dart';

class HistoryPage extends GetView<HistoryController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Image.asset(Config.PNG_PATH + 'back_button.png'), onPressed: () => Get.back()),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Order History'),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          controller.fetchOrderHistory();
          return controller.refreshCompleter.future;
        },
        child: Container(
          height: Get.height,
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: GetX<HistoryController>(
                initState: controller.fetchOrderHistory(),
                builder: (_) {
                  return _.history.call() == null ? Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 20),
                    child: _.isLoading.call() ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CupertinoActivityIndicator(),
                        Text('Loading', style: TextStyle(fontSize: 18))
                      ],
                    ) : Text(_.historyMessage.call(), style: TextStyle(fontSize: 18)),
                  ) : Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: _.history.call().data.map((e) => _buildHistoryItem(e)).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(OrderHistoryData data) {
    var title = data.store.locationName.isBlank ? data.store.name : '${data.store.name} (${data.store.locationName})';
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5.0,
              offset: Offset(3,3)
            )
          ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
              height: 70.0,
              width: 70.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.black, width: 1.5),
                color: Colors.transparent
              ),
              child: ClipOval(
                child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: data.store.logoUrl, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35)))
              )
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17), textAlign: TextAlign.start,),
                    ),
                    Text(DateFormat('MMMM dd, yyyy - hh:mm a').format(data.createdAt.toUtc().toLocal()), style: TextStyle(fontSize: 13)),
                    Text(data.products.length == 1 ? '${data.products.first.quantity}x ${data.products.first.name}' : '${data.products.length}x Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Container(
                      margin: EdgeInsets.only(right: 10, bottom: 10),
                      alignment: FractionalOffset.bottomRight,
                      child: Text('₱ ${data.fee.customerTotalPrice}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    )
                ],
              )
            ),
          ],
        ),
      ),
      onTap: () => Get.toNamed(Config.HISTORY_DETAIL_ROUTE, arguments: data.toJson()),
    );
  }
}