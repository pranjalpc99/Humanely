import 'package:Humanely/models/IncidentPostModel.dart';
import 'package:Humanely/utils/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'emergency_card_tile.dart';

class ExploreCard extends StatefulWidget {
  final int index;
  ExploreCard(this.index);

  @override
  _ExploreCardState createState() => _ExploreCardState();
}

class _ExploreCardState extends State<ExploreCard> {

  List time =  ["8:35 pm, 16 July, 2020","2:15 pm, 16 July, 2020","11:47 am, 13 July, 2020"];
  List title = ["Mumbai building collapse","Intense showers soak city","Couple’s fight spills onto road"];
  List place = ["Fort area , Mumbai","SV Road, Andheri West","Pedder Road, Mumbai"];

  TextEditingController commentController = TextEditingController();

  // ignore: non_constant_identifier_names
  firestore_fetch_posts()
  {

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: Firestore.instance.collection('posts').snapshots(),
          builder:  (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            var documents = snapshot.data?.documents ?? [];
            var postlist = documents.map((snapshot) => IncidentPostModel.fromJson(snapshot.data)).toList();
//            print("DATAAAAAAAAAAA");
//            print(postlist[0].title);
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator(),);
            }
            else {
              return Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: postlist.length,
                    itemBuilder: (context, index) {
                      print("DATAAAAAAAAAAA");
                      print(snapshot.data);
                      return EmergencyCard(postlist[index]);
//                  return ListTile(
//                    title: Text(
//                        snapshot.data.documents[index]["numar_telefon"]),
//                  );
                    }

                ),
              );
            }
          }
      ),
    );
//      child: Card(
//          color: HexColor("#333333"),
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(20.0),
//          ),
//          child: Container(
//            width: MediaQuery.of(context).size.width,
//            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Text(
//                    time[widget.index],
//                    style: TextStyle(
//                      fontFamily: 'Poppins',
//                      color: Colors.white,
//                    ),
//                  ),
//                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Column(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Padding(
//                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
//                          child: Text(
//                            title[widget.index],
//                            style: TextStyle(
//                                fontFamily: 'Poppins',
//                                color: Colors.white,
//                                fontSize: 18.0),
//                          ),
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
//                          child: Text(
//                            place[widget.index],
//                            style: TextStyle(
//                              fontFamily: 'Poppins',
//                              color: Colors.white,
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                    Expanded(
//                      child: Container(
//                        alignment: Alignment.centerRight,
//                          margin: EdgeInsets.only(right: 16.0),
//                          width: 24.0,
//                          height: 24.0,
//                          child: Image.asset("assets/images/pray.png")),
//                    ),
//                  ],
//                ),
//                Card(
//                  color: HexColor("#111111"),
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(20.0),
//                  ),
//                  child: Container(
//                    width: MediaQuery.of(context).size.width,
//                    //padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//                    child: Image.asset("assets/images/img${widget.index+1}.png"),
//                  ),
//                ),
//                SizedBox(height: 10.0,),
//                Row(
//                  children: <Widget>[
//                    CircleAvatar(
//                      child: Icon(Icons.person),
//                    ),
//                    SizedBox(width: 5.0,),
//                    Expanded(
//                      child: Card(
//                        color: HexColor("#888888"),
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(20.0),
//                        ),
//                        child: Padding(
//                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
//                          child: Text("Comment"),
//                        )
//                      ),
//                    ),
//                    CircleAvatar(
//                      child: Icon(Icons.share),
//                      backgroundColor: HexColor("#555555"),
//                    )
//                  ],
//                ),
//                SizedBox(height: 10.0),
//              ],
//            ),
//          )),
  }
    }
