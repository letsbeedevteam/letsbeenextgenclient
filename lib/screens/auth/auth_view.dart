import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/screens/auth/controller/auth_controller.dart';
import 'package:letsbeeclient/_utils/config.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 130,
                width: 240,
                child: Hero(tag: 'splash', child: Image.asset(Config.PNG_PATH + 'splash_logo.png')),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                    GetBuilder<AuthController>(
                      builder: (_) {
                      return IgnorePointer(
                          ignoring: _.isLoading.value,
                          child: customSignInButton(
                            color: Colors.blue.shade400,
                            icon: Icon(FontAwesomeIcons.facebookSquare, color: Colors.white),
                            label: 'Continue with Facebook',
                            labelColor: Colors.white,
                            onTap: () => _.facebookSignIn(),
                          )
                        );
                      },
                    ),
                    GetBuilder<AuthController>(
                      builder: (_) {
                      return IgnorePointer(
                          ignoring: _.isLoading.value,
                          child: customSignInButton(
                            color: Colors.red.shade400,
                            icon: Icon(FontAwesomeIcons.google, color: Colors.white),
                            label: 'Continue with Google',
                            labelColor: Colors.white,
                            onTap: () => _.googleSignIn(),
                          )
                        );
                      },
                    ),
                    GetBuilder<AuthController>(
                      builder: (_) {
                      return IgnorePointer(
                          ignoring: _.isLoading.value,
                          child: customSignInButton(
                            color: Colors.yellow.shade600,
                            svg: SvgPicture.asset(Config.SVG_PATH + 'kakao_talk.svg'),
                            label: 'Continue with Kakao',
                            labelColor: Colors.black,
                            onTap: () => _.kakaoSignIn(),
                          )
                        );
                      },
                    ),
                    signInWithApple(),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    GetBuilder<AuthController>(
                      builder: (_) {
                        return AnimatedContainer(
                          child: _.isLoading.value ? LinearProgressIndicator(backgroundColor: Colors.yellow, valueColor: AlwaysStoppedAnimation<Color>(_.socialColor.value)) : Container(),
                          duration: Duration (seconds: 2),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width: _.isLoading.value ? Get.width : Get.width / 250 * 180,
                          height: _.isLoading.value ? 2 : 0.3,
                          color: Colors.black,
                        );
                      },
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    GetBuilder<AuthController>(
                      builder: (_) {
                      return IgnorePointer(
                          ignoring: _.isLoading.value,
                          child: customSignInButton(
                            color: Colors.grey,
                            icon: Icon(Icons.email, color: Colors.black),
                            label: 'Continue with Email',
                            labelColor: Colors.black,
                            onTap: () => Get.toNamed(Config.SIGNUP_ROUTE),
                          )
                        );
                      },
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  Widget signInWithApple() {
    return GetPlatform.isIOS ? 
    GetBuilder<AuthController>(
      builder: (_) {
      return IgnorePointer(
          ignoring: _.isLoading.value,
          child: customSignInButton(
            color: Colors.black,
            icon: Icon(FontAwesomeIcons.apple, color: Colors.white),
            label: 'Continue with Apple',
            labelColor: Colors.white,
            onTap: () => _.appleSignIn(),
          )
        );
      },
    ) : Container();
  }

  Widget customSignInButton({Color color, Icon icon, SvgPicture svg, String label, Color labelColor, @required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 40, right: 40),
      child: RaisedButton(
        color: color,
        child: Container(
          padding: EdgeInsets.all(8),
          height: 40,
          width: 280,
          child: Row(
            children: [
              icon == null ? svg : icon,
              Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
              AutoSizeText(
                label,
                textAlign: TextAlign.center,
                presetFontSizes: [15, 15, 10],
                maxLines: 2,
                style: TextStyle(
                  color: labelColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}