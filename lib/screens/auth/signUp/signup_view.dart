import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'controller/signup_controller.dart';
import 'package:easy_localization/easy_localization.dart';

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
            title: Text(tr('signUp'), style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500)),
            bottom: PreferredSize(
              child: Container(height: 1, color: Colors.grey.shade200),
              preferredSize: Size.fromHeight(4.0)
            ),
          ),
          body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                return IconButton(
                  color: !controller.isAgreeTerms.call() ? Color(Config.LETSBEE_COLOR) : Colors.black,
                  icon: Icon(!controller.isAgreeTerms.call() ? Icons.radio_button_on : Icons.radio_button_off),
                  onPressed: () => controller.isAgreeTerms(!controller.isAgreeTerms.call()),
                );
              }),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                       TextSpan(text: tr('agree'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
                       TextSpan(
                         text: tr('termsConditions'), 
                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(Config.YELLOW_TEXT_COLOR)),
                         recognizer: TapGestureRecognizer()..onTap = () => print('Terms and conditions')
                        ),
                    ]
                  ),
                ),
              )
            ]
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Obx(() {
            return IgnorePointer(
              ignoring: controller.isLoading.call() || controller.isFacebookLoading.call() || controller.isGoogleLoading.call() || controller.isKakaoLoading.call(),
              child: SizedBox(
                width: Get.width * 0.85,
                child: RaisedButton(
                  onPressed: () => controller.isLoading.call() ? null : controller.signUp(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20) 
                  ),
                  color: Color(Config.LETSBEE_COLOR),
                  child: Text(tr(controller.isLoading.call() ? 'signingUp' : 'signUp'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
                )
              ),
            );
          }),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        ],
      ),
    );
  }

  Widget _headerTitles() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(Config.PNG_PATH + 'letsbee-logo.png', width: 150),
          const Padding(padding: const EdgeInsets.symmetric(vertical: 8)),
          Text(tr('signUpTitleHeader'), style: TextStyle(fontSize: 15, color: Color(Config.GREY_TEXT_COLOR))),
          RichText(
            text: TextSpan(
              children: [
                  TextSpan(text: tr('alreadyHaveAnAccount'), style: TextStyle(fontSize: 15, color: Color(Config.GREY_TEXT_COLOR))),
                  TextSpan(
                    text: tr('signIn'), 
                    style: TextStyle(fontSize: 15, color: Color(Config.YELLOW_TEXT_COLOR)),
                    recognizer: TapGestureRecognizer()..onTap = () => Get.back()
                  ),
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: _socialLoginButtons(),
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
              label: controller.isFacebookLoading.call() ? 'signingUp' : 'signUpWithFacebook',
              labelColor: Colors.white,
              onTap: () => controller.facebookSignIn(),
            );
          }),
          Obx(() {
            return customSignInButton(
              color: Color(0xFFEA4335),
              icon: Icon(FontAwesomeIcons.google, color: Colors.white),
              label: controller.isGoogleLoading.call() ? 'signingUp' : 'signUpWithGoogle',
              labelColor: Colors.white,
              onTap: () => controller.googleSignIn(),
            );
          }),
          Obx(() {
            return customSignInButton(
              color: Color(0xFFFFE812),
              svg: SvgPicture.asset(Config.SVG_PATH + 'kakao_talk.svg'),
              label: controller.isKakaoLoading.call() ? 'signingUp' : 'signUpWithKakao',
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
        Text(tr('email'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
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
                contentPadding: EdgeInsets.only(left: 15, right: 15)
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
        Text(tr('password'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
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
                contentPadding: EdgeInsets.only(left: 15, right: 15)
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
        Text(tr('repeatPassword'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        SizedBox(
          height: 40,
          child: Obx(() {
            return TextFormField(
              enabled: !controller.isLoading.call() || !controller.isFacebookLoading.call() || !controller.isGoogleLoading.call() || !controller.isKakaoLoading.call(),
              controller: controller.confirmPasswordController,
              focusNode: controller.confirmPasswordFN,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
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
                contentPadding: EdgeInsets.only(left: 15, right: 15)
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
                child: Text(
                  tr(label),
                  textAlign: TextAlign.center,
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