// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> ko_KR = {
    "signIn": "로그인",
    "signingIn": "로그인 에"
  };

  static const Map<String,dynamic> en_US = {
    "signIn": "Sign In",
    "signingIn": "Signing In...",
    "signUp": "Sign Up",
    "signingUp": "Signing Up...",
    "signIntitleHeader": "Please enter your username and password to sign in. Enjoy your food!",
    "signInFooter": "Don't have an account?",
    "email": "Email",
    "password": "Password",
    "repeatPassword": "Repeat Password",
    "or": "OR",
    "rememberMe": "Remember Me",
    "forgotPassword": "Forgot Password",
    "signInWithFacebook": "Sign In with Facebook",
    "signInWithGoogle": "Sign In with Google",
    "signInWithKakao": "Sign In with Kakao",
    "signUpWithFacebook": "Sign Up with Facebook",
    "signUpWithGoogle": "Sign Up with Google",
    "signUpWithKakao": "Sign Up with Kakao",
    "userCredentials": "User Credentials",
    "signUpTitleHeader": "Please enter your user details to sign up.",
    "alreadyHaveAnAccount": "Already have an account? ",
    "agree": "I have read and agree to the ",
    "termsConditions": "terms and conditions",
    "noInternetConnection": "No internet connection",
    "somethingWentWrong": "Something went wrong. Please try again",
    "timedOut": "Operation timed out. Please try again",
    "tokenExpired": "Token Expired!",
    "oops": "Oops!",
    "inputFields": "Please input your required field(s)",
    "signInFailed": "Sign In Failed. Please try again.",
    "accountNotExist": "Your Let\'s Bee Account doesn\'t exist.",
    "emailInvalid": "Your email address is invalid",
    "incorrectRepeatPassword": "Your repeat password is incorrect.",
    "registeredSuccess": "Registered successfully! Please sign in your account.",
    "yay": "Yay!",
    "userDetails": "User Details",
    "loading": "Loading...",
    "next": "Next",
    "name": "Name",
    "contactNumber": "Contact Number",
    "verification": "Verification",
    "enterCode": "Enter the code",
    "enterOtp": "Enter the OTP code sent to your number",
    "didntSendCode": "Didn\'t received any code?",
    "resendCode": "Resend a new code"
  };
  static const Map<String, Map<String,dynamic>> mapLocales = {"ko_KR": ko_KR, "en_US": en_US};
}
