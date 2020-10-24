import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  //final DocumentReference reference;
  String id;
  String fname;
  String lname;

  DocumentReference reference;

  UserModel({this.id,this.fname,this.lname});

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    UserModel newPost = UserModel.fromJson(snapshot.data);
    newPost.reference = snapshot.reference;
    return newPost;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => _PostFromJson(json);

  Map<String, dynamic> toJson() => _PostToJson(this);

  @override
  String toString() => "Post<$fname>";

//  IncidentPostModel.fromJson(Map<String, dynamic> parsedJson)
//    : title = parsedJson['title'],
//      timestamp = parsedJson['timestamp'],
//      place = parsedJson['place'],
//      votes = parsedJson['votes'];

//  IncidentPostModel.data(this.reference,
//      [this.timestamp,
//        this.title,this.place,this.votes]) {
//    // Set these rather than using the default value because Firebase returns
//    // null if the value is not specified.
//    this.timestamp ??= "";
//    this.title??="";
//    this.place="";
//    this.votes ??= "0";
//  }
//
//  factory IncidentPostModel.from(DocumentSnapshot document) => IncidentPostModel.data(
//      document.reference,
//      document.data['timestamp'],
//      document.data['title'],
//      document.data['place'],
//     document.data['votes'],
//  );

//  void save() {
//    reference.setData(toMap());
//  }

//  Map<String, dynamic> toMap() {
//    return {
//      'timestamp': timestamp,
//      'title': title,
//      'place': place,
//      'votes':votes,
//    };
//  }
}

UserModel _PostFromJson(Map<String,dynamic> json){
  return UserModel(
    id: json['number'] as String,
    fname: json['firstName'] as String,
    lname: json['lastName'] as String,
  );
}

Map<String, dynamic> _PostToJson(UserModel instance) => <String, dynamic> {
  'number': instance.id,
  'firstName': instance.fname,
  'lastName': instance.lname,
};