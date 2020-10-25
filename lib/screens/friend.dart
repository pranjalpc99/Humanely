import 'package:Humanely/models/UserModel.dart';
import 'package:Humanely/utils/auth.dart';
import 'package:Humanely/utils/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class Friend extends StatefulWidget {
  final String number;
  final int seletedPage;
  Friend(this.number,this.seletedPage);

  @override
  _FriendState createState() => _FriendState();
}

class _FriendState extends State<Friend> {

  List<Contact> contacts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus != PermissionStatus.granted) {
      _handleInvalidPermissions(permissionStatus);
    } else {
      //print("Permission granted");
      getAllContacts();
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus =
      await Permission.contacts.request();
      return permissionStatus ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      throw PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }


  getAllContacts() async {
    Iterable<Contact> _contacts = (await ContactsService.getContacts(
        withThumbnails: false)).toList();
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex:widget.seletedPage,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.chevron_left),
          title: Text("Friends"),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Friends",
              ),
              Tab(
                text: "Connect",
              ),
              Tab(
                text: "Add Friend",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            getFriends(),
            getConnected(),
            getContacts(),
          ],
        ),
      ),
    );
  }

  Widget getFriends() {
    return StreamBuilder(
        stream:Firestore.instance.collection('Users').document(widget.number).collection('friends').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          var documents = snapshot.data?.documents ?? [];
          //print(documents.length);
          if(documents.isEmpty){
            return Center(child:Text("No Friends",style: TextStyle(color: Colors.white),));
          }
          var frienList = documents.map((snapshot) =>
              UserModel.fromJson(snapshot.data)).toList();
          frienList.sort((a, b) => a.fname.compareTo(b.fname));
          return ListView.builder(
            itemCount: frienList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: HexColor("#333333"),
                  child: Icon(Icons.person),
                ),
                title: Text(
                  frienList[index].fname + " " + frienList[index].lname,
                  style: TextStyle(color: Colors.white, fontSize: 16),),
                subtitle: Text(frienList[index].id,
                  style: TextStyle(color: Colors.white54, fontSize: 14),),
              );
            },
          );
        }
    );
  }

  Widget getConnected() {
    return StreamBuilder(
        stream: Firestore.instance.collection('Users').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          var documents = snapshot.data?.documents ?? [];
          var frienList = documents.map((snapshot) =>
              UserModel.fromJson(snapshot.data)).toList();
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          //print(frienList);
          frienList.sort((a, b) => a.fname.compareTo(b.fname));

          return ListView.builder(
            itemCount: frienList.length,
            itemBuilder: (context, index) {
              /*String name;
              final snap = Firestore.instance.collection('Users').document(widget.number).collection('friends').document(frienList[index].id);
              snap.get().then((value) => name = value.data['firstName']);*/
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: HexColor("#333333"),
                  child: Icon(Icons.person),
                ),
                title: Text(
                  frienList[index].fname + " " + frienList[index].lname,
                  style: TextStyle(color: Colors.white, fontSize: 16),),
                subtitle: Text(frienList[index].id,
                  style: TextStyle(color: Colors.white54, fontSize: 14),),
                trailing: connectBtn(),
                onTap: (){connectToContact(frienList[index].id,frienList[index].fname,frienList[index].lname);},
              );
            },
          );
        });
  }

  Widget getContacts() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            Contact contact = contacts[index];
            return ListTile(
              title: Text(contact.displayName,
                style: TextStyle(color: Colors.white, fontSize: 16),),
              subtitle: Text(contact.phones
                  .elementAt(0)
                  .value,
                style: TextStyle(color: Colors.white54, fontSize: 14),),
              trailing: inviteBtn(),
            );
          }),
    );
  }

  Widget connectBtn() {
    return InkWell(
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.blue)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "CONNECT", style: TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  connectToContact(String num,String fname,String lname){
    Auth.store.collection('Users').document(widget.number).collection('friends').document(num).setData({
      'firstName':fname,
      'lastName':lname,
      'number': num
    });
    String count;
    int c;
    Auth.store.collection('Users').document(widget.number).get().then((value) {
      count = value.data['friends'];
      c = int.parse(count) + 1;
    }).then((value) {
      Auth.store.collection('Users').document(widget.number).updateData({
        'friends': c.toString(),
      });
    });

  }

  Widget inviteBtn() {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.blue)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "INVITE", style: TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
