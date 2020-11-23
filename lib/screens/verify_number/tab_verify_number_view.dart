import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/controllers/verify_number/verify_number_controller.dart';
import 'package:letsbeeclient/screens/verify_number/confirm_code_view.dart';
import 'package:letsbeeclient/screens/verify_number/contact_number_view.dart';

class VerifyNumberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GetBuilder<VerifyNumberController>(builder: (_) => IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
            dismissKeyboard(context);
            if (_.selectedIndex.value == 0) {
              Get.back(closeOverlays: true);
            } else {
              _.changeIndex(0);
            }
          })),
        ),
        body: GetBuilder<VerifyNumberController>(
          builder: (_) {
            return TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _.tabController,
              children: [
                ContactNumberPage(),
                ConfirmCodePage()
              ]
            );
          },
        )
      ),
      onTap: () => dismissKeyboard(context),
    );
  }
}