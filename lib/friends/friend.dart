import 'package:Humanely/models/UserModel.dart';
import 'package:Humanely/utils/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Friend extends StatefulWidget {
  @override
  _FriendState createState() => _FriendState();
}

class _FriendState extends State<Friend> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.chevron_left),
          title: Text("Friends"),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Connected",
              ),
              Tab(
                text: "Add Friend",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            getConnected(),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }

  Widget getConnected() {
    return StreamBuilder(
        stream: Firestore.instance.collection('Users').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot){
          var documents = snapshot.data?.documents ?? [];
          var frienList = documents.map((snapshot) => UserModel.fromJson(snapshot.data)).toList();
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          print(frienList);

          frienList.sort((a,b) => a.fname.compareTo(b.fname));
            return ListView.builder(
            itemCount: frienList.length,
            itemBuilder: (context,index){
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:HexColor("#333333"),
                  child: Icon(Icons.person),
                ),
                title: Text(frienList[index].fname+" "+frienList[index].lname,style: TextStyle(color: Colors.white, fontSize: 20),),
                subtitle: Text(frienList[index].id,style: TextStyle(color: Colors.white54, fontSize: 16),),
              );
            },
          );
        });
  }
}
