import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/cellphoneConfirmationResponse.dart';
import 'package:letsbeeclient/models/signInResponse.dart';
import 'package:letsbeeclient/services/api_service.dart';

class VerifyNumberController extends GetxController with SingleGetTickerProviderMixin {

  final ApiService _apiService = Get.find();
  final GetStorage _box = Get.find();
  final keyboardVisibilityController = KeyboardVisibilityController();

  TabController tabController;

  var selectedIndex = 0.obs;
  var isLoading = false.obs;
  var isKeyboardVisible = false.obs;

  var numberController = TextEditingController();
  var codeController = TextEditingController();

  var signInData = SignInData().obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    if (Get.arguments != null) {
      signInData(SignInData.fromJson(Get.arguments));

      if (signInData.call().sentConfirmation) {
        changeIndex(1);
      } else {
        changeIndex(0);
      }
    } 

    keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible(visible);
    });

    super.onInit();
  }

  getUserNumber() => numberController.text;

  void changeIndex(int index) {
    selectedIndex(index);
    tabController.index = selectedIndex.call();
    update();
  }

  void sendCode() {
    isLoading(true);
    _apiService.updateCellphoneNumber(token: signInData.call().token, number: '+63${numberController.text}').then((response) {
      if (response.status == 200) {
        signInData(SignInData.fromJson(response.data.toJson()));
        changeIndex(1);
      } else {
        errorSnackBarBottom(title: 'Oops!', message: 'Invalid contact number');
      }

      isLoading(false);

    }).catchError((onError) {
      isLoading(false);
      print(onError);
      errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
    });
    // changeIndex(1);
  }

  void confirmCode() {

    if (!codeController.text.isNotEmpty) {
      isLoading(false);
      errorSnackbarTop(title: 'Oops!', message: 'Please input your confirmation code');
    } else {
      isLoading(true);
      _apiService.cellphoneConfirmaation(token: signInData.call().token, code: codeController.text).then((response) {
        if (response.status == 200) {
          _goToSetupLocation(response);
        } else {
          errorSnackBarBottom(title: 'Oops!', message: 'Invalid code');
        }

        isLoading(false);

      }).catchError((onError) {
        isLoading(false);
        errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
      });
    }
  }

  void _goToSetupLocation(CellphoneConfirmationResponse response) {
    _box.write(Config.USER_NAME, response.data.name);
    _box.write(Config.USER_EMAIL, response.data.email);
    _box.write(Config.USER_MOBILE_NUMBER, response.data.cellphoneNumber);
    _box.write(Config.USER_TOKEN, response.data.accessToken);
    _box.write(Config.USER_MOBILE_NUMBER, response.data.cellphoneNumber);
    _box.write(Config.SOCIAL_LOGIN_TYPE, Config.EMAIL);
    _box.write(Config.IS_LOGGED_IN, true);
    Get.offAllNamed(Config.SETUP_LOCATION_ROUTE);
  }

  void logout() {
    _box.write(Config.IS_LOGGED_IN, false);
    Get.offNamedUntil(Config.AUTH_ROUTE, (route) => false);
  }
}