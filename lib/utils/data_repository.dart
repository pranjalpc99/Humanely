import 'package:Humanely/models/IncidentPostModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataRepository{
  final CollectionReference postsReference = Firestore.instance.collection("posts");
  final CollectionReference usersReference = Firestore.instance.collection("users");

  Stream<QuerySnapshot> getPostsStream() {
    return postsReference.snapshots();
  }

  Stream<QuerySnapshot> getUsersStream() {
    return usersReference.snapshots();
  }

  Future<DocumentReference> addPost(IncidentPostModel postModel) {
    return postsReference.add(postModel.toJson());
  }
}