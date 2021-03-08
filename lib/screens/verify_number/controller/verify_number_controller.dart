import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';
import 'package:letsbeeclient/_utils/extensions.dart';
import 'package:letsbeeclient/models/cellphoneConfirmationResponse.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/models/signInResponse.dart';
import 'package:letsbeeclient/services/api_service.dart';

class VerifyNumberController extends GetxController with SingleGetTickerProviderMixin {

  final ApiService _apiService = Get.find();
  final GetStorage _box = Get.find();
  final keyboardVisibilityController = KeyboardVisibilityController();

  var selectedIndex = 0.obs;
  var isLoading = false.obs;
  var isKeyboardVisible = false.obs;

  var signInData = SignInData().obs;

  RxString firstDigit = ''.obs;
  RxString secondDigit = ''.obs;
  RxString thirdDigit = ''.obs;
  RxString fourthDigit = ''.obs;
  RxString fifthDigit = ''.obs;
  RxString sixthDigit = ''.obs;
  RxString currentDigit = ''.obs;

  var first = TextEditingController();
  var second = TextEditingController();
  var third = TextEditingController();
  var fourth = TextEditingController();
  var fifth = TextEditingController();
  var sixth = TextEditingController();

  var firstFN = FocusNode();
  var secondFN = FocusNode();
  var thirdFN = FocusNode();
  var fourthFN = FocusNode();
  var fifthFN = FocusNode();
  var sixthFN = FocusNode();

  @override
  void onInit() {
    
    signInData(SignInData.fromJson(Get.arguments));

    keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible(visible);
    });

    super.onInit();
  }

  void changeIndex(int index) {
    selectedIndex(index);
    update();
  }

  void confirmCode() {

    currentDigit('${first.text}${second.text}${third.text}${fourth.text}${fifth.text}${sixth.text}');

     isLoading(true);
    _apiService.cellphoneConfirmation(token: signInData.call().token, code: currentDigit.call()).then((response) {
      if (response.status == 200) {
        _verifiedPopUp(response);
      } else {
        errorSnackBarBottom(title: Config.oops, message: Config.invalidCode);
      }

      isLoading(false);

    }).catchError((onError) {
      isLoading(false);
      errorSnackbarTop(title: Config.oops, message: Config.somethingWentWrong);
      print('Confirmation error: $onError');
    });
  }

  void _goToSetupLocation(CellphoneConfirmationResponse response) {
    _box.write(Config.USER_ID, response.data.id);
    _box.write(Config.USER_NAME, response.data.name);
    _box.write(Config.USER_EMAIL, response.data.email);
    _box.write(Config.USER_MOBILE_NUMBER, response.data.cellphoneNumber);
    _box.write(Config.USER_TOKEN, response.data.accessToken);
    
    if (response.data.address.isEmpty) {
      Get.offNamedUntil(Config.MAP_ROUTE, (route) => false, arguments: {'type': Config.SETUP_ADDRESS});
    } else {
      final data = response.data.address.first;
      _box.write(Config.NOTE_TO_RIDER, data.note);
      _box.write(Config.USER_ADDRESS_ID, data.id);
      _box.write(Config.USER_CURRENT_LATITUDE, data.location.lat);
      _box.write(Config.USER_CURRENT_LONGITUDE,  data.location.lng);
      _box.write(Config.USER_CURRENT_ADDRESS, data.address);
      _box.write(Config.USER_CURRENT_NAME_OF_LOCATION, data.name);
      _box.write(Config.IS_LOGGED_IN, true);
      Get.offAllNamed(Config.DASHBOARD_ROUTE);
    }
  }

  _verifiedPopUp(CellphoneConfirmationResponse response) {
    Get.dialog(
      AlertDialog(
        content: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Config.PNG_PATH + 'verified.png'),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Text(tr('contactVerifiedSuccess'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.center),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              RaisedButton(
                onPressed: () => _goToSetupLocation(response),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20) 
                ),
                color: Color(Config.LETSBEE_COLOR),
                child: Text(tr('dismiss'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
              )
            ]
          )
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
        )
      ),
    );
  }
}