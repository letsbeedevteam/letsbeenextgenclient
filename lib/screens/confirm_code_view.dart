import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeeclient/_utils/config.dart';

class ConfirmCodePage extends StatelessWidget {

  final GetStorage _box = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Text('Please enter your confirmation code.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              SizedBox(
                width: Get.width * 0.50,
                height: 40,
                child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black)
                    ),
                    hintText: 'Code',
                    counterText: "",
                    contentPadding: EdgeInsets.all(0)
                  ),
                  maxLength: 5,
                  cursorColor: Colors.black,
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0,2)
                    )
                  ]
                ),
                child: SizedBox(
                  height: 40,
                  child: RaisedButton(
                    color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(13),
                      child: Text('CONFIRM'),
                    ),
                    onPressed: _goToDashboardPage,
                  ),
                  width: Get.width * 0.80,
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0,2)
                    )
                  ]
                ),
                child: SizedBox(
                  height: 40,
                  child: RaisedButton(
                    color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(13),
                      child: Text('RESEND CONFIRMATION CODE'),
                    ),
                    onPressed: () {
                      print('Resend confirmation code');
                    },
                  ),
                  width: Get.width * 0.80,
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 30)),
            ],
          ),
        ),
      ),
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
    );
  }

  _goToDashboardPage() {
    _box.write(Config.IS_SETUP_LOCATION, true);
    Get.offAllNamed(Config.DASHBOARD_ROUTE);
  }
}