import 'package:Humanely/utils/hexcolor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostDetail extends StatefulWidget {
  final String title;
  final String timestamp;
  final String place;
  final String image;

  PostDetail(this.title,this.image,this.place,this.timestamp);

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(imageUrl: widget.image),
          SafeArea(
            child: Container(
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  setLeadPostDetail(),
                  Spacer(),
                  setBottomDetails(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget setLeadPostDetail() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Card(
            color: HexColor('#C0C0C0'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.remove_red_eye,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("512"),
                    Text(" views")
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          Card(
            color: HexColor('#E4FFED'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: HexColor('#009933'),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Verified",
                      style: TextStyle(
                          color: HexColor('#009933'),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget setBottomDetails(){
    return Container(
      child: Card(
        margin: EdgeInsets.all(0),
        color: HexColor('#060606'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 16.0,bottom: 8.0),
                  child: Text(widget.timestamp,style: TextStyle(color: Colors.white),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.title,style: TextStyle(fontSize: 20,color: Colors.white),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: Text(widget.place,style: TextStyle(color: Colors.white),),
                ),
                SizedBox(height: 30,),
                Container(
                  child: Row(
                    children: [
                      Icon(Icons.notifications_active_rounded),
                      SizedBox(width: 10,),
                      Text("415 people notified",style: TextStyle(color: Colors.white),),
                      SizedBox(width: 70,),
                      Text("Alert your friends",style: TextStyle(color: Colors.blue),),
                      Icon(Icons.chevron_right_rounded,color: Colors.blue,),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
