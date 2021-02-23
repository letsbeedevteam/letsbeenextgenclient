import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';

class AccountSettingsPage extends GetView<DashboardController> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildAccountManagement(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildNotifications(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildOthers(),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget _buildAccountManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: const Text('Account Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15 ,right: 15, top: 15),
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(controller.box.read(Config.USER_NAME), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                  const Text('Manage your account information', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.normal))
                ],
              ),
              Icon(Icons.chevron_right)
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(Config.ADDRESS_ROUTE),
          child: Container(
            padding: const EdgeInsets.only(left: 15 ,right: 15, top: 20),
            decoration: BoxDecoration(
              color: Color(Config.WHITE)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Addresses', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                    const Text('Add, manage or remove delivery address', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.normal))
                  ],
                ),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(Config.HISTORY_ROUTE),
          child: Container(
            padding: const EdgeInsets.only(left: 15 ,right: 15, top: 20),
            decoration: BoxDecoration(
              color: Color(Config.WHITE)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order History', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                    const Text('Check your previous orders', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.normal))
                  ],
                ),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15 ,right: 15, top: 20, bottom: 10),
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Change Password', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
              const Icon(Icons.chevron_right)
            ],
          ),
        ),
      ]
    );
  }

  Widget _buildNotifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15 ,right: 15),
          child: const Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15 ,right: 15, top: 10),
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Delivery Push Notifications', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
              Obx(() {
                return Switch(
                  value: controller.isDisableDeliveryPushNotif.call(),
                  onChanged: (isStatus) {
                    controller.isDisableDeliveryPushNotif(!controller.isDisableDeliveryPushNotif.call());
                  },
                  activeTrackColor: Color(Config.LETSBEE_COLOR),
                  activeColor: Colors.white,
                );
              })
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15 ,right: 15),
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Promotional Push Notifications', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
              Obx(() {
                return Switch(
                  value: controller.isDisablePromotionalPushNotif.call(),
                  onChanged: (isStatus) {
                    controller.isDisablePromotionalPushNotif(!controller.isDisablePromotionalPushNotif.call());
                  },
                  activeTrackColor: Color(Config.LETSBEE_COLOR),
                  activeColor: Colors.white,
                );
              })
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOthers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15 ,right: 15),
          child: const Text('Others', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Container(
          width: Get.width,
          padding: const EdgeInsets.only(left: 15 ,right: 15, top: 15),
          child: const Text('Become a partner restaurant', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
        ),
        Container(
          width: Get.width,
          padding: const EdgeInsets.only(left: 15 ,right: 15, top: 20),
          child: const Text('Become a a rider', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
        ),
        Container(
          width: Get.width,
          padding: const EdgeInsets.only(left: 15 ,right: 15, top: 20),
          child: const Text('Terms and conditions', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
        ),
        GestureDetector(
          onTap: () => _logoutModal(),
          child: Container(
            width: Get.width,
            padding: const EdgeInsets.only(left: 15 ,right: 15, top: 20),
            child: const Text('Sign out', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );
  }

  _logoutModal() {
    Get.defaultDialog(
      title: 'Do you really want to log out your account?',
      backgroundColor: Color(Config.WHITE),
      titleStyle: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
      radius: 8,
      content: Container(),
      confirm: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        color: const Color(Config.LETSBEE_COLOR),
        onPressed: () =>  controller.signOut(),
        child: const Text('YES', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      cancel: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        color: const Color(Config.LETSBEE_COLOR),
        onPressed: () => Get.back(),
        child: const Text('NO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      barrierDismissible: false
    );
  }
}