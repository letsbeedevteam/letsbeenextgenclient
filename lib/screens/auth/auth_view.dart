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
                    GetX<AuthController>(
                      builder: (_) {
                      return IgnorePointer(
                          ignoring: _.isLoading.call(),
                          child: customSignInButton(
                            color: Colors.blue.shade400,
                            icon: Icon(FontAwesomeIcons.facebookSquare, color: Colors.white),
                            label: 'Login with Facebook',
                            labelColor: Colors.white,
                            onTap: () => _.facebookSignIn(),
                          )
                        );
                      },
                    ),
                    GetX<AuthController>(
                      builder: (_) {
                      return IgnorePointer(
                          ignoring: _.isLoading.call(),
                          child: customSignInButton(
                            color: Colors.red.shade400,
                            icon: Icon(FontAwesomeIcons.google, color: Colors.white),
                            label: 'Login with Google',
                            labelColor: Colors.white,
                            onTap: () => _.googleSignIn(),
                          )
                        );
                      },
                    ),
                    GetX<AuthController>(
                      builder: (_) {
                      return IgnorePointer(
                          ignoring: _.isLoading.call(),
                          child: customSignInButton(
                            color: Colors.yellow.shade600,
                            svg: SvgPicture.asset(Config.SVG_PATH + 'kakao_talk.svg'),
                            label: 'Login with Kakao',
                            labelColor: Colors.black,
                            onTap: () => _.kakaoSignIn(),
                          )
                        );
                      },
                    ),
                    signInWithApple(),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    GetX<AuthController>(
                      builder: (_) {
                        return AnimatedContainer(
                          child: _.isLoading.call() ? LinearProgressIndicator(backgroundColor: Colors.yellow, valueColor: AlwaysStoppedAnimation<Color>(_.socialColor.call())) : Container(),
                          duration: Duration (seconds: 2),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width: _.isLoading.call() ? Get.width : Get.width / 250 * 180,
                          height: _.isLoading.call() ? 2 : 0.3,
                          color: Colors.black,
                        );
                      },
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    GetX<AuthController>(
                      builder: (_) {
                      return IgnorePointer(
                          ignoring: _.isLoading.call(),
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
    GetX<AuthController>(
      builder: (_) {
      return IgnorePointer(
          ignoring: _.isLoading.call(),
          child: customSignInButton(
            color: Colors.black,
            icon: Icon(FontAwesomeIcons.apple, color: Colors.white),
            label: 'Login with Apple',
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Container(
          height: 40,
          width: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // icon == null ? svg : icon,
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