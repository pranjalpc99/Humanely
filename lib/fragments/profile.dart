import 'package:Humanely/screens/friend.dart';
import 'package:Humanely/home_page.dart';
import 'package:Humanely/utils/auth.dart';
import 'package:Humanely/utils/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Humanely/models/user.dart';
import 'dart:async';

enum Menu { Settings, LogOut }

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String number="";
  String name="";
  String badgesCount="";
  String friendCount="";
  String postCount="";
  int nflag = 0;
  int bflag = 0;
  int fflag = 0;
  int pflag = 0;


  /* Future<List<User>> user;
  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;*/

  Future<bool> getPhoneNumber() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    number = preferences.getString("phoneNumber");
    return number == null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //dbHelper = DBProvider();
    //isUpdating = false;
    number = "";
    name = "";
    getPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
          future: getPhoneNumber(),
          builder: (buildContext, snapshot) {
            if (snapshot.hasData) {
              //print("got number "+number);
              Firestore.instance
                  .collection('Users')
                  .document(number)
                  .get()
                  .then((value) {
                name = value.data['firstName'] + " " + value.data['lastName'];
                friendCount = value.data['friends'];
                postCount = value.data['posts'];
                badgesCount = value.data['badges'];
                //print("Name now is "+name);
                  setState(() {
                    name = name;
                    friendCount = friendCount;
                  });

              });

              return Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              // _signOut();
                            },
                            child: Card(
                                color: HexColor("#333333"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Icon(
                                    Icons.person,
                                    size: 56,
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            name,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Card(
                                      color: HexColor("#D1C4E9"),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(50.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Icon(
                                          Icons.stars,
                                          size: 24,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    badgesCount,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Badges",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Friend(number, 0)));
                                    },
                                    child: Card(
                                        color: HexColor("#C8E6C9"),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(50.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Icon(
                                            Icons.people_alt,
                                            size: 24,
                                            color: Colors.green,
                                          ),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    friendCount,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Friends",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Card(
                                      color: HexColor("#FFE0B2"),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(50.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Icon(
                                          Icons.remove_red_eye,
                                          size: 24,
                                          color: HexColor("#F57C00"),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    postCount,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Posts",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          _buildInviteBar(),
                          _buildFindBar(),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
      appBar: AppBar(
        leading: Icon(Icons.chevron_left),
        title: Text("Profile"),
        actions: <Widget>[
          openPopUpMenu(),
        ],
      ),
    );
  }

  Widget openPopUpMenu(){
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(child: Text('Settings'),value: 1,),
        PopupMenuItem(child: Text('Log Out'),value: 2,),
      ],
      icon: Icon(Icons.tune),
      onSelected: (value){
        switch(value) {
          case 1: break;
          case 2: _signOut();break;
        }
      },
      //offset: Offset(0, 100),
    );
  }

  Widget _buildInviteBar() {
    return InkWell(
      onTap:() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Friend(number,2)));
      },
      child: Padding(
        padding:
        const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 32.0, right: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
                color: HexColor("#333333"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.share,
                    size: 18,
                    color: Colors.green,
                  ),
                )),
            SizedBox(
              width: 10,
            ),
            Text(
              "Invite friends",
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFindBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Friend(number,1)));
      },
      child: Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 8.0, left: 32.0, right: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
                color: HexColor("#333333"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.search,
                    size: 18,
                    color: Colors.blue,
                  ),
                )),
            SizedBox(
              width: 10,
            ),
            Text(
              "Find friends",
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await Auth.auth.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
