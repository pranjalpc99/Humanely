import 'package:Humanely/home_page.dart';
import 'package:Humanely/main.dart';
import 'package:Humanely/utils/auth.dart';
import 'package:Humanely/utils/colors.dart';
import 'package:Humanely/utils/size_config.dart';
import 'package:Humanely/utils/sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserRegister extends StatefulWidget {
  final String number;

  UserRegister(this.number);

  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  String firstName;
  String lastName;
  FirebaseUser _firebaseUser;
  String _status;
  String phoneNumber;
  bool showSpinner = false;

  @override
  void initState() {
    //_getFirebaseUser();
    super.initState();
    phoneNumber = widget.number;
  }

  getPhoneNumber() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String num = preferences.getString("phoneNumber");
    return num;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primary,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: Colors.blue,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            color: Colors.blue,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Back',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20.0),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Welcome",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: FontSize.s28,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "The world is safe when together",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w100,
                                  color: Colors.white,
                                  fontSize: FontSize.s18,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Enter First Name",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    color: Colors.blue),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Card(
                              color: Color(0xff060606),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: Colors.blue),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  onChanged: (value) {
                                    //print(value);
                                    firstName = value;
                                  },
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18.0,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Enter Last Name",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    color: Colors.blue),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Card(
                              color: Color(0xff060606),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: Colors.blue),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  onChanged: (value) {
                                    //print(value);
                                    lastName = value;
                                  },
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18.0,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
             Align(
               alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0,bottom: 30.0,right: 20.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blue,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          showSpinner = true;
                        });
                        //print(firstName);
                       // print(lastName);
                        //print(phoneNumber);
                        Auth.store.collection('Users').document(phoneNumber).setData({
                          'firstName' : firstName,
                          'lastName' : lastName,
                        }).whenComplete(() {
                          setState(() {
                            showSpinner = false;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Continue',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20.0,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
