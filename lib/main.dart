
import 'package:Humanely/home_page.dart';
import 'package:Humanely/utils/app_theme.dart';
import 'package:Humanely/utils/credentials.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

import 'login/otp_page.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  //print("binding: "+GestureBinding.instance.toString());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final kInitialPosition = LatLng(19.124573, 72.837319);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  /*List<DisplayMode> modes = <DisplayMode>[];

  DisplayMode selected;

  Future<void> fetchModes() async {
    try {
      modes = await FlutterDisplayMode.supported;
      modes.forEach(print);

      /// On OnePlus 7 Pro:
      /// #1 1080x2340 @ 60Hz
      /// #2 1080x2340 @ 90Hz
      /// #3 1440x3120 @ 90Hz
      /// #4 1440x3120 @ 60Hz

      /// On OnePlus 8 Pro:
      /// #1 1080x2376 @ 60Hz
      /// #2 1440x3168 @ 120Hz
      /// #3 1440x3168 @ 60Hz
      /// #4 1080x2376 @ 120Hz
    } on PlatformException catch (e) {
      print(e);

      /// e.code =>
      /// noAPI - No API support. Only Marshmallow and above.
      /// noActivity - Activity is not available. Probably app is in background
    }
    selected =
        modes.firstWhere((DisplayMode m) => m.selected, orElse: () => null);
    if (mounted) {
      setState(() {});
    }
  }*/

/*  Future<DisplayMode> getCurrentMode() async {
    return await FlutterDisplayMode.current;
  }*/

  /*@override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchModes();
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: HomePage(),
//      home: PlacePicker(
//        apiKey: PLACES_API,
//        useCurrentLocation: true,
//        initialPosition: kInitialPosition,
//      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff060606),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200.0,
                width: 500.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/earth.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.0,-0.1),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Image(
                    image: AssetImage('assets/images/logo2.png'),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 170.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => OTPPage(false,"")));},
                    child: Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.blue,
//                          gradient: LinearGradient(colors: [
//                            Color(0xFF2B79E6),
//                            Color(0xFF7CB4FF)
//                          ])
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 50.0,
                            top: 10.0,
                            right: 50.0,
                            bottom: 10.0),
                        child: Text(
                          'ALLOW',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              letterSpacing: 2.0,
                              fontSize: 24.0,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 150.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    "Learn more about why we need your location",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                  const EdgeInsets.only(top: 50.0, bottom: 20.0, left: 20.0),
                  child: SizedBox(
                    width: 300.0,
                    child: Text(
                      'Know what\'s happening around you',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24.0,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'App name uses your location to send real-time safety alerts',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w100,
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
