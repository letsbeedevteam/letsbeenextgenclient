import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeeclient/_utils/config.dart';

class SignUpPage extends StatelessWidget {

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFN = FocusNode();
  final _nameFN = FocusNode();
  final _passwordFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            FlatButton(
              child: Text('Next', style: TextStyle(fontSize: 18)), color: Colors.white, highlightColor: Colors.transparent,
              onPressed: () => Get.toNamed(Config.SIGNUP_CONFIRMATION_ROUTE), 
            )
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('What\'s your email?', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), textAlign: TextAlign.left),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('We\'ll if you have an account', style: TextStyle(fontSize: 18)),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('Email:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                            SizedBox(
                              height: 40,
                              child: TextFormField(
                                controller: _emailController,
                                focusNode: _emailFN,
                                onEditingComplete: () => _nameFN.requestFocus(),
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 18),
                                keyboardType: TextInputType.emailAddress, 
                                textInputAction: TextInputAction.next,
                                enableSuggestions: false,
                                autocorrect: false,
                                obscureText: false,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  // filled: true,
                                  // fillColor: Color(Config.LETSBEE_COLOR).withOpacity(0.5),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.black)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15)
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('Name:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                            SizedBox(
                              height: 40,
                              child: TextFormField(
                                controller: _nameController,
                                focusNode: _nameFN,
                                onEditingComplete: () => _passwordFN.requestFocus(),
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 18),
                                keyboardType: TextInputType.text, 
                                textInputAction: TextInputAction.next,
                                enableSuggestions: false,
                                autocorrect: false,
                                obscureText: false,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  // filled: true,
                                  // fillColor: Color(Config.LETSBEE_COLOR).withOpacity(0.5),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.black)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15)
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('Password:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                            SizedBox(
                              height: 40,
                              child: TextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFN,
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 18),
                                keyboardType: TextInputType.text, 
                                textInputAction: TextInputAction.done,
                                enableSuggestions: false,
                                autocorrect: false,
                                obscureText: true,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  // filled: true,
                                  // fillColor: Color(Config.LETSBEE_COLOR).withOpacity(0.5),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.black)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ),
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
    );
  }
}