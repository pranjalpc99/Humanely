import 'package:Humanely/google_maps_place_picker.dart';
import 'package:Humanely/main.dart';
import 'package:Humanely/user_register.dart';
import 'package:Humanely/utils/credentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static final kInitialPosition = LatLng(19.124573, 72.837319);

  FirebaseUser _firebaseUser;
  String _status;

  @override
  void initState() {
    super.initState();
    _getFirebaseUser();
  }

  Future<void> _getFirebaseUser() async {
    this._firebaseUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      _status =
      (_firebaseUser == null) ? 'Not Logged In\n' : 'Already LoggedIn\n';
      if(_firebaseUser == null) {
        print("Not logged in");
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter Demo Home Page')));
      }
      else{
        print("Already logged in");
        print(PLACES_API);
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            PlacePicker(
              apiKey: PLACES_API,
              useCurrentLocation: true,
              initialPosition: kInitialPosition,
            )));
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;
    ScreenUtil.init(width: defaultScreenWidth,height: defaultScreenHeight,allowFontScaling: true);

    return Scaffold(
      backgroundColor: Color(0xff060606),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Text("Home Page",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 22.0
            ),),
          ),
        ),
      ),
    );
  }
}
