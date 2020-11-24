import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/controllers/splash/splash_controller.dart';
import 'package:letsbeeclient/_utils/config.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SplashController>(
        builder: (_) {
          return Center(
            child: SizedBox(
              height: 130,
              width: 240,
              child: Hero(tag: 'splash', child: Image.asset(Config.PNG_PATH + 'splash_logo.png')),
            ),
          );
        },
      ),
    );
  }
}