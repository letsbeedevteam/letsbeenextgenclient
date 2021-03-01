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
    _apiService.cellphoneConfirmaation(token: signInData.call().token, code: currentDigit.call()).then((response) {
      if (response.status == 200) {
        _verifiedPopUp(response);
      } else {
        errorSnackBarBottom(title: 'Oops!', message: 'Invalid code');
      }

      isLoading(false);

    }).catchError((onError) {
      isLoading(false);
      errorSnackbarTop(title: 'Oops!', message: Config.SOMETHING_WENT_WRONG);
      print('Confirmation error: $onError');
    });
  }

  void _goToSetupLocation(CellphoneConfirmationResponse response) {
    _box.write(Config.USER_ID, response.data.id);
    _box.write(Config.USER_NAME, response.data.name);
    _box.write(Config.USER_EMAIL, response.data.email);
    _box.write(Config.USER_MOBILE_NUMBER, response.data.cellphoneNumber);
    _box.write(Config.USER_TOKEN, response.data.accessToken);
    _box.write(Config.USER_MOBILE_NUMBER, response.data.cellphoneNumber);
    
    if (response.data.address.isEmpty) {
      Get.offNamedUntil(Config.MAP_ROUTE, (route) => false, arguments: {'type': Config.SETUP_ADDRESS});
    } else {
      final address = response.data.address.first;
      final userCurrentAddress = '${address.street}, ${address.barangay}, ${address.city}'.trim();
      _box.write(Config.USER_CURRENT_STREET, address.street);
      _box.write(Config.USER_CURRENT_COUNTRY, address.country);
      _box.write(Config.USER_CURRENT_STATE, address.state);
      _box.write(Config.USER_CURRENT_CITY, address.city);
      _box.write(Config.USER_CURRENT_IS_CODE, address.isoCode);
      _box.write(Config.USER_CURRENT_BARANGAY, address.barangay);
      _box.write(Config.USER_CURRENT_LATITUDE, address.location.lat);
      _box.write(Config.USER_CURRENT_LONGITUDE,  address.location.lng);
      _box.write(Config.USER_CURRENT_ADDRESS, userCurrentAddress);
      _box.write(Config.USER_CURRENT_NAME_OF_LOCATION, address.name);
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
              const Text('Your contact number has been verified successfully!', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black), textAlign: TextAlign.center),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              RaisedButton(
                onPressed: () => _goToSetupLocation(response),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20) 
                ),
                color: Color(Config.LETSBEE_COLOR),
                child: Text('Dismiss', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black)),
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