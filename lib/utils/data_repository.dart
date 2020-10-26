import 'package:Humanely/models/IncidentPostModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DataRepository{
  final CollectionReference postsReference = Firestore.instance.collection("posts");
  final CollectionReference usersReference = Firestore.instance.collection("users");
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  var storage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getPostsStream() {
    return postsReference.snapshots();
  }

  Stream<QuerySnapshot> getUsersStream() {
    return usersReference.snapshots();
  }

  Future<DocumentReference> addPost(IncidentPostModel postModel) {
    //return postsReference.document().setData(postModel.toJson());
    return postsReference.add(postModel.toJson());
  }

//  Future uploadPic( ) async{
//
//    String fileName = basename(_image.path);
//    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
//    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
//    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
//    setState(() {
//      print("Profile Picture uploaded");
//      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
//    });
//
//  }


}