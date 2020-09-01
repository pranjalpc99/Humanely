import 'package:Humanely/utils/sizes.dart';
import 'package:flutter/material.dart';

class NotificationFragment extends StatefulWidget {
  @override
  _NotificationFragmentState createState() => _NotificationFragmentState();
}

class _NotificationFragmentState extends State<NotificationFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 120),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Image.asset("assets/images/no_notification.png",height: 200,width: 200,fit: BoxFit.fitWidth,),
                SizedBox(height: 20,),
                Text("No Notifications",style: TextStyle(color: Colors.white),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
