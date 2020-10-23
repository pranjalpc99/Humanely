

import 'package:Humanely/home_page.dart';
import 'package:Humanely/utils/auth.dart';
import 'package:Humanely/utils/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String number="";

  getPhoneNumber() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String num = preferences.getString("phoneNumber");
    number = num;
    return num;
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getPhoneNumber().then((result){
      print(result+" in init res");
      number = result.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("number in profile "+number);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top:30),
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
                      _signOut();
                    },
                    child: Card(
                      color: HexColor("#333333"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(Icons.person,size: 56,),
                        )
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text("Pranjal Chaudhari",style: TextStyle(color: Colors.white,fontSize: 20),),
                  SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Card(
                              color: HexColor("#D1C4E9"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.stars,size: 24,color: Colors.deepPurpleAccent,),
                              )
                          ),
                          SizedBox(height: 10,),
                          Text("20",style: TextStyle(color: Colors.white,fontSize: 24),),
                          SizedBox(height: 10,),
                          Text("Total",style: TextStyle(color: Colors.white),),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Card(
                              color: HexColor("#C8E6C9"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.verified_user,size: 24,color: Colors.green,),
                              )
                          ),
                          SizedBox(height: 10,),
                          Text("20",style: TextStyle(color: Colors.white,fontSize: 24),),
                          SizedBox(height: 10,),
                          Text("Verified",style: TextStyle(color: Colors.white),),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Card(
                              color: HexColor("#FFE0B2"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.remove_red_eye,size: 24,color: HexColor("#F57C00"),),
                              )
                          ),
                          SizedBox(height: 10,),
                          Text("20",style: TextStyle(color: Colors.white,fontSize: 24),),
                          SizedBox(height: 10,),
                          Text("Views",style: TextStyle(color: Colors.white),),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 50,),
                  _buildInviteBar(),
                  _buildFindBar(),
                ],
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        leading: Icon(Icons.chevron_left),
        title: Text("Profile"),
        actions: <Widget>[
          Icon(Icons.tune)
        ],
      ),
    );
  }

  Widget _buildInviteBar(){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 32.0,right: 32.0),
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
                child: Icon(Icons.share,size: 18,color: Colors.green,),
              )
          ),
          SizedBox(width: 10,),
          Text("Invite friends",style: TextStyle(color: Colors.green,fontSize: 16),),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(Icons.chevron_right,color: Colors.white,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFindBar(){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 32.0,right: 32.0),
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
                child: Icon(Icons.search,size: 18,color: Colors.blue,),
              )
          ),
          SizedBox(width: 10,),
          Text("Find friends",style: TextStyle(color: Colors.blue,fontSize: 16),),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(Icons.chevron_right,color: Colors.white,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async{
    await Auth.auth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
