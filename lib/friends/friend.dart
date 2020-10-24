import 'package:Humanely/models/UserModel.dart';
import 'package:Humanely/utils/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class Friend extends StatefulWidget {
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
            getContacts(),
          ],
        ),
      ),
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
          print(frienList);

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
        });
  }

  Widget getContacts() {

    return Container(
      padding: EdgeInsets.only(left: 20,right: 20),
      child: ListView.builder(
        shrinkWrap: true,
          itemCount: contacts.length,
          itemBuilder: (context,index){
            Contact contact = contacts[index];
            return ListTile(
              title: Text(contact.displayName,style: TextStyle(color: Colors.white, fontSize: 16),),
              subtitle: Text(contact.phones.elementAt(0).value,style: TextStyle(color: Colors.white54, fontSize: 14),),
              trailing: inviteBtn(),
            );
          }),
    );
  }

  Widget inviteBtn(){
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Colors.blue)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "INVITE",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
