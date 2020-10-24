
import 'package:Humanely/camerascreen/camera_screen.dart';
import 'package:Humanely/fragments/explore.dart';
import 'package:Humanely/fragments/notification.dart';
import 'package:Humanely/fragments/profile.dart';
import 'package:Humanely/google_maps_place_picker.dart';
import 'package:Humanely/main.dart';
import 'package:Humanely/utils/credentials.dart';
import 'package:Humanely/utils/hexcolor.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  static final kInitialPosition = LatLng(19.124573, 72.837319);

  FirebaseUser _firebaseUser;
  String _status;

  var _bottomNavIndex = 0; //default index of first screen

  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
    _getFirebaseUser();

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
          () => _animationController.forward(),
    );
  }

  Future<void> _getFirebaseUser() async {
    this._firebaseUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      _status =
      (_firebaseUser == null) ? 'Not Logged In Home Page\n' : 'Already LoggedIn Home page\n';
      if(_firebaseUser == null) {
        print("Not logged in Home page if condition");
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter Demo Home Page')));
      }
      else{
        print("Already logged in home page else condition");
        print(PLACES_API);
//        Navigator.push(context, MaterialPageRoute(builder: (context) =>
//            PlacePicker(
//              apiKey: PLACES_API,
//              useCurrentLocation: true,
//              initialPosition: kInitialPosition,
//            )));
      }

    });
  }


  final iconList = <IconData>[
    Icons.home,
    Icons.flash_on,
    Icons.notifications,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;
    ScreenUtil.init(width: defaultScreenWidth,height: defaultScreenHeight,allowFontScaling: true);
    Widget child;
    switch (_bottomNavIndex) {
      case 0:
        child = PlacePicker(
        apiKey: PLACES_API,
        useCurrentLocation: true,
        initialPosition: kInitialPosition,
      );
        break;
      case 1:
        child = Explore();
        break;
      case 2:
        child = NotificationFragment();
        break;
      case 3:
        child = Profile();
        break;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff060606),
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: SizedBox.expand(child: child),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()));
            },
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar : AnimatedBottomNavigationBar(
            icons: iconList,
            backgroundColor: HexColor('#444444'),
            activeIndex: _bottomNavIndex,
            leftCornerRadius: 24,
            rightCornerRadius: 24,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.defaultEdge,
            notchAndCornersAnimation: animation,
            notchMargin: 8.0,
            onTap: (index) => setState(() {
              _bottomNavIndex = index;
              print(_bottomNavIndex);
            }),
          ),
      ),
    );
  }
}
