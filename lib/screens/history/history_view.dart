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
        leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () => Get.back()),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Order History', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          child: Container(height: 2, color: Colors.grey.shade200),
          preferredSize: Size.fromHeight(4.0)
        ),
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
                        Text('Loading history...', style: TextStyle(fontSize: 15))
                      ],
                    ) : Text(_.historyMessage.call(), style: TextStyle(fontSize: 15)),
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
        color: Color(Config.WHITE),
        child: Column(
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
                          child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17), textAlign: TextAlign.start,),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Text(DateFormat('MMMM dd, yyyy - hh:mm a').format(data.createdAt.toUtc().toLocal()), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        Text(data.products.length == 1 ? '${data.products.first.quantity}x ${data.products.first.name}' : '${data.products.length}x Items', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                         Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                        Container(
                          margin: EdgeInsets.only(right: 10, bottom: 10),
                          child: Text('₱${data.fee.customerTotalPrice}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                        _buildStatus(data.status)
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
                    child: FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicatorSmall, image: data.store.logoUrl, placeholderScale: 5, imageErrorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, size: 35)))
                  )
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              ],
            ),
            Divider(thickness: 2, color: Colors.grey.shade200)
          ],
        ),
      ),
      onTap: () => Get.toNamed(Config.HISTORY_DETAIL_ROUTE, arguments: data.toJson()),
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
}