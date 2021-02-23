import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/models/getAddressResponse.dart';
import 'package:letsbeeclient/screens/address/address_controller.dart';

class AddressPage extends GetView<AddressController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () => Get.back()),
        title: const Text('Addresses', style: TextStyle(fontSize: 15, color: Colors.black)),
        centerTitle: true,
      ),
      body: Obx(() {
        return controller.isLoading.call() ? Container(
          margin: const EdgeInsets.only(top: 15),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              const CupertinoActivityIndicator(),
              const Text('Loading addresses...', style: TextStyle(fontSize: 15, color: Colors.black))
            ],
          ),
        ) : _content();
      }),
    );
  }

  Widget _content() {
    return controller.addresses.call() == null ? Container(
      margin: const EdgeInsets.only(top: 15),
      alignment: Alignment.topCenter,
      child: const Text('No list of address', style: TextStyle(fontSize: 15, color: Colors.black)),
    ) : _scrollView();
  }

  Widget _scrollView() {
    return RefreshIndicator(
      onRefresh: () => controller.refreshAddress(),
      child: Obx(() {
        return Column(
          children: [
            Flexible(
              child: ListView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                children: controller.addresses.call().data.take(3).map((address) => _buildLocationList(address)).toList(),
              ),
            ),
            SizedBox(
              width: Get.width * 0.85,
              child: RaisedButton(
                color: const Color(Config.LETSBEE_COLOR),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: const Text('Add New Address', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                onPressed: () => controller.addAddress(),
              ),
            ),
            const Padding(padding: const EdgeInsets.symmetric(vertical: 5))
          ],
        );
      }),
    );
  }

  Widget _buildLocationList(AddressData data) {
    final address = '${data.street}, ${data.barangay}, ${data.city}';
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Color(Config.WHITE)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data.name, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                GestureDetector(
                  child: const Icon(Icons.edit),
                  onTap: () => print('Edit'),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(address, style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500))
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: const Text('Note to rider: None', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.normal))
            ),
            Divider(thickness: 2, color: Colors.grey.shade200)
          ],
        ),
      ),
      onTap: () => controller.updateSelectedAddress(data: data),
    );
  }
}