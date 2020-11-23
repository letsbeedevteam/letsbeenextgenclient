import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/controllers/splash/splash_controller.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
      body: GetBuilder<SplashController>(
        builder: (_) {
          return Lottie.asset(
              Config.JSONS_PATH + 'splash_animation.json',
              fit: BoxFit.fill,
              height:  Get.height,
              width: Get.width,
              repeat: false,
              reverse: false,
              animate: true
            );
          },
      ),
    );
  }
}