import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';

class VerifyNumberPage extends StatelessWidget {

  final _focusNode = FocusNode();

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
              Center(child: Text('Please verify your contact number.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              SizedBox(
                width: Get.width * 0.70,
                height: 40,
                child: TextField(
                  focusNode: _focusNode,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.number, 
                  maxLength: 10,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    prefixIcon: SizedBox(
                      child: Center(
                        widthFactor: 1.2,
                        child: Padding(padding: EdgeInsets.only(left: 20), child: Text('+63', style: TextStyle(fontSize: 18)),),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    counterText: "",
                    contentPadding: EdgeInsets.all(0)
                  ),
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
                      child: Text('SEND CONFIRMATION CODE'),
                    ),
                    onPressed: _goToConfirmationCodePage,
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

  _goToConfirmationCodePage() => Get.toNamed(Config.CONFIRM_CODE_ROUTE);
}