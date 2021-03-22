import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/screens/dashboard/controller/dashboard_controller.dart';

class AccountSettingsPage extends GetView<DashboardController> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<DashboardController>(
        builder: (_) {
          return Container(
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
          );
        },
      )
    );
  }

  Widget _buildAccountManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(tr('accountManagement'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(Config.ACCOUNT_INFO_ROUTE),
          child: Container(
            padding: const EdgeInsets.only(left: 15 ,right: 15, top: 15),
            decoration: BoxDecoration(
              color: Color(Config.WHITE)
            ),
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.box.read(Config.USER_NAME), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                    Text(tr('manageInfo'), style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.normal))
                  ],
                ),
                const Icon(Icons.chevron_right)
              ],
            ),
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
                    Text(tr('addresses'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                    Text(tr('addressDesc'), style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.normal))
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
                    Text(tr('orderHistory'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                    Text(tr('previousOrders'), style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.normal))
                  ],
                ),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(Config.CHANGE_PASS_ROUTE),
          child: Container(
            padding: const EdgeInsets.only(left: 15 ,right: 15, top: 20, bottom: 10),
            decoration: BoxDecoration(
              color: Color(Config.WHITE)
            ),
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tr('changePass'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _translationBottomsheet(),
          child: Container(
            padding: const EdgeInsets.only(left: 15 ,right: 15, top: 20, bottom: 10),
            decoration: BoxDecoration(
              color: Color(Config.WHITE)
            ),
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tr('language'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                const Icon(Icons.chevron_right)
              ],
            ),
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
          child: Text(tr('notifications'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15 ,right: 15, top: 10),
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tr('deliveryPushNotif'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
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
              Text(tr('promotionalPushNotif'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
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
          child: Text(tr('others'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Container(
          width: Get.width,
          padding: const EdgeInsets.only(left: 15 ,right: 15, top: 15),
          child: Text(tr('becomePartner'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
        ),
        Container(
          width: Get.width,
          padding: const EdgeInsets.only(left: 15 ,right: 15, top: 20),
          child: Text(tr('becomeRider'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
        ),
        Container(
          width: Get.width,
          padding: const EdgeInsets.only(left: 15 ,right: 15, top: 20),
          child: Text(tr('termsConditions'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
        ),
        GestureDetector(
          onTap: () => _logoutModal(),
          child: Container(
            width: Get.width,
            padding: const EdgeInsets.only(left: 15 ,right: 15, top: 20),
            child: Text(tr('signOut'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );
  }

  _logoutModal() {
    Get.defaultDialog(
      title: tr('signOutMessage'),
      backgroundColor: Color(Config.WHITE),
      titleStyle: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
      radius: 8,
      content: Container(),
      confirm: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        color: const Color(Config.LETSBEE_COLOR),
        onPressed: () =>  controller.isSigningOut.call() ? null : controller.signOut(),
        child: Obx(() => Text(controller.isSigningOut.call() ? tr('signingOut') : tr('yes'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))),
      ),
      cancel: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        color: const Color(Config.LETSBEE_COLOR),
        onPressed: () => controller.isSigningOut.call() ? null : Get.back(),
        child: Text(tr('no'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
      barrierDismissible: false
    );
  }

  _translationBottomsheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Color(Config.WHITE),
        ),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: Text('English', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                value: 'EN',
                groupValue: controller.language.call(),
                onChanged: controller.changeLanguage,
              ),
              RadioListTile(
                title: Text('Korea', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
                value: 'KR',
                groupValue: controller.language.call(),
                onChanged: controller.changeLanguage,
              )
            ],
          );
        }),
      )
    );
  }
}