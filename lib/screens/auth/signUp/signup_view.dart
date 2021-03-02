import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'controller/signup_controller.dart';

class SignUpPage extends GetView<SignUpController>  {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: controller.willPopCallback),
            title: Text('User Credentials', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
            bottom: PreferredSize(
              child: Container(height: 2, color: Colors.grey.shade200),
              preferredSize: Size.fromHeight(4.0)
            ),
          ),
          body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerTitles(),
                _fields(),
                Obx(() {
                  return IgnorePointer(
                    ignoring: controller.isLoading.call() || controller.isFacebookLoading.call() || controller.isGoogleLoading.call() || controller.isKakaoLoading.call(),
                    child: _footer()
                  );
                })
              ],
            ),
          )
        ),
        onTap: () => dismissKeyboard(context),
      ),
      onWillPop: controller.willPopCallback,
    );
  }

  Widget _fields() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _emailTextField(),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          _passwordTextField(),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          _confirmPasswordTextField(),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                return Radio(
                  value: true,
                  onChanged: (isStatus) => controller.isAgreeTerms(!controller.isAgreeTerms.call()),
                  groupValue: !controller.isAgreeTerms(),
                );
              }),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                       TextSpan(text: 'I have read and agree to the ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
                       TextSpan(
                         text: 'terms and conditions', 
                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(Config.YELLOW_TEXT_COLOR)),
                         recognizer: TapGestureRecognizer()..onTap = () => print('Terms and conditions')
                        ),
                    ]
                  ),
                ),
              )
            ]
          ),
          IgnorePointer(
            ignoring: controller.isLoading.call() || controller.isFacebookLoading.call() || controller.isGoogleLoading.call() || controller.isKakaoLoading.call(),
            child: SizedBox(
              width: Get.width * 0.85,
              child: Obx(() {
                return RaisedButton(
                  onPressed: () => controller.isLoading.call() ? null : controller.signUp(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20) 
                  ),
                  color: Color(Config.LETSBEE_COLOR),
                  child: Text(controller.isLoading.call() ? 'Signing Up...' : 'Sign Up', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _headerTitles() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(Config.PNG_PATH + 'letsbee-logo.png', width: 150),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          const Text('Please enter your username and password to sign in. Enjoy your food!', style: TextStyle(fontSize: 15))
        ],
      ),
    );
  }

  Widget _footer() {
    return Column(
      children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 15)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Don\'t have an account?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
            GestureDetector(
              onTap: () => Get.toNamed(Config.SIGNUP_ROUTE),
              child: Text('Sign Up', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(Config.YELLOW_TEXT_COLOR))),
            )
          ],
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        const Text('OR', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        _socialLoginButtons(),
      ],
    );
  }

  Widget _socialLoginButtons() {
    return Container(
      child: Column(
        children: [
          Obx(() {
            return customSignInButton(
              color: Color(0xFF3B5998),
              icon: Icon(FontAwesomeIcons.facebookSquare, color: Colors.white),
              label: controller.isFacebookLoading.call() ? 'Signing Up...' : 'Sign Up with Facebook',
              labelColor: Colors.white,
              onTap: () => controller.facebookSignIn(),
            );
          }),
          Obx(() {
            return customSignInButton(
              color: Color(0xFFEA4335),
              icon: Icon(FontAwesomeIcons.google, color: Colors.white),
              label: controller.isGoogleLoading.call() ? 'Signing Up...' : 'Sign Up with Google',
              labelColor: Colors.white,
              onTap: () => controller.googleSignIn(),
            );
          }),
          Obx(() {
            return customSignInButton(
              color: Color(0xFFFFE812),
              svg: SvgPicture.asset(Config.SVG_PATH + 'kakao_talk.svg'),
              label: controller.isKakaoLoading.call() ? 'Signing Up...' : 'Sign Up with Kakao',
              labelColor: Colors.black,
              onTap: () => controller.kakaoSignIn(),
            );
          }),
          // signInWithApple(),
          Padding(padding: EdgeInsets.only(top: 30)),
        ],
      ),
    );
  }

  Widget _emailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        Obx(() {
          return SizedBox(
            height: 40,
            child: TextFormField(
              enabled: !controller.isLoading.call() || !controller.isFacebookLoading.call() || !controller.isGoogleLoading.call() || !controller.isKakaoLoading.call(),
              controller: controller.emailController,
              focusNode: controller.emailFN,
              onEditingComplete: () {
                controller.passwordController.selection = TextSelection.fromPosition(TextPosition(offset: controller.passwordController.text.length));
                controller.passwordFN.requestFocus();
              },
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18),
              keyboardType: TextInputType.emailAddress, 
              textInputAction: TextInputAction.next,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: false,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(Config.PNG_PATH + 'email.png', width: 10,),
                ),
                fillColor: !controller.isLoading.call() || !controller.isFacebookLoading.call() || !controller.isGoogleLoading.call() || !controller.isKakaoLoading.call() ? Colors.grey.shade200 : Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                ),
                contentPadding: EdgeInsets.only(left: 15)
              )
            ),
          );
        })
      ],
    );
  }

  Widget _passwordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        SizedBox(
          height: 40,
          child: Obx(() {
            return TextFormField(
              enabled: !controller.isLoading.call() || !controller.isFacebookLoading.call() || !controller.isGoogleLoading.call() || !controller.isKakaoLoading.call(),
              controller: controller.passwordController,
              focusNode: controller.passwordFN,
              onEditingComplete: () {
                controller.confirmPasswordController.selection = TextSelection.fromPosition(TextPosition(offset: controller.confirmPasswordController.text.length));
                controller.confirmPasswordFN.requestFocus();
              },
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18),
              textInputAction: TextInputAction.done,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: !controller.isShowPassword.call(),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(Config.PNG_PATH + 'password.png', width: 10,),
                ),
                suffixIcon: IconButton(
                  onPressed: () => controller.isShowPassword(!controller.isShowPassword.call()),
                  icon: controller.isShowPassword.call() ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                ),
                fillColor: !controller.isLoading.call() || !controller.isFacebookLoading.call() || !controller.isGoogleLoading.call() || !controller.isKakaoLoading.call() ? Colors.grey.shade200 : Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                ),
                contentPadding: EdgeInsets.only(left: 15)
              )
            );
          }),
        )
      ],
    );
  }

  Widget _confirmPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Repeat Password', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        SizedBox(
          height: 40,
          child: Obx(() {
            return TextFormField(
              enabled: !controller.isLoading.call() || !controller.isFacebookLoading.call() || !controller.isGoogleLoading.call() || !controller.isKakaoLoading.call(),
              controller: controller.confirmPasswordController,
              focusNode: controller.confirmPasswordFN,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18),
              textInputAction: TextInputAction.done,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: !controller.isShowConfirmPassword.call(),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(Config.PNG_PATH + 'password.png', width: 10,),
                ),
                suffixIcon: IconButton(
                  onPressed: () => controller.isShowConfirmPassword(!controller.isShowConfirmPassword.call()),
                  icon: controller.isShowConfirmPassword.call() ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                ),
                fillColor: !controller.isLoading.call() || !controller.isFacebookLoading.call() || !controller.isGoogleLoading.call() || !controller.isKakaoLoading.call() ? Colors.grey.shade200 : Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                ),
                contentPadding: EdgeInsets.only(left: 15)
              )
            );
          }),
        )
      ],
    );
  }

  Widget customSignInButton({Color color, Icon icon, SvgPicture svg, String label, Color labelColor, @required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 40, right: 40),
      child: RaisedButton(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
        ),
        child: Container(
          height: 40,
          width: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              icon == null ? svg : icon,
              Expanded(
                child: AutoSizeText(
                  label,
                  textAlign: TextAlign.center,
                  presetFontSizes: [15, 15, 10],
                  maxLines: 2,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}