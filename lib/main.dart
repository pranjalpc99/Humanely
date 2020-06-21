import 'package:flutter/material.dart';

import 'otp_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
                  child: Text('Logo'),
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
                          gradient: LinearGradient(colors: [
                            Color(0xFF2B79E6),
                            Color(0xFF7CB4FF)
                          ])),
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
