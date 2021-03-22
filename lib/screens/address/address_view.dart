import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/get_address_response.dart';
import 'package:letsbeeclient/screens/address/address_controller.dart';

class AddressPage extends GetView<AddressController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: controller.onWillPopBack),
        title: Text(tr('addresses'), style: TextStyle(fontSize: 15, color: Colors.black)),
        centerTitle: true,
      ),
      body: Obx(() {
        return controller.isLoading.call() ? Container(
          margin: const EdgeInsets.only(top: 15),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              const CupertinoActivityIndicator(),
              Text(tr('loadingAddresses'), style: TextStyle(fontSize: 15, color: Colors.black))
            ],
          ),
        ) : Column(
          children: [
            Flexible(child: _content()),
            SizedBox(
              width: Get.width * 0.85,
              child: RaisedButton(
                color: const Color(Config.LETSBEE_COLOR),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text(tr('addNewAddress'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                onPressed: () => controller.addAddress(),
              ),
            ),
            const Padding(padding: const EdgeInsets.symmetric(vertical: 5))
          ],
        );
      }),
    );
  }

  Widget _content() {
    return controller.addresses.call() == null ? Container(
      margin: const EdgeInsets.only(top: 15),
      alignment: Alignment.topCenter,
      child: Text(tr('emptyAddresses'), style: TextStyle(fontSize: 15, color: Colors.black)),
    ) : _scrollView();
  }

  Widget _scrollView() {
    return RefreshIndicator(
      onRefresh: () => controller.refreshAddress(),
      child: Obx(() {
        return ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: controller.addresses.call().data.map((address) => _buildLocationList(address)).toList(),
        );
      }),
    );
  }

  Widget _buildLocationList(AddressData data) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
        decoration: BoxDecoration(
          color: Color(Config.WHITE)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(data.name, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                    data.isSelected ? Icon(Icons.check_circle, color: Colors.green, size: 15) : Container()
                  ],
                ),
                GestureDetector(
                  child: const Icon(Icons.edit),
                  onTap: () => controller.editAddress(data),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(data.address, style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500))
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('${tr('noteToRider')}: ${data.note}', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.normal))
            ),
            Divider(thickness: 1, color: Colors.grey.shade200)
          ],
        ),
      ),
      onTap: () => controller.checkCartBeforeChangeAddress(data: data),
    );
  }
}