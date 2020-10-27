import 'package:cloud_firestore/cloud_firestore.dart';

class IncidentPostModel {
  //final DocumentReference reference;
  String timestamp;
  String title;
  String place;
  String upvotes;
  String downvotes;
  String uploader;
  String id;
  String image;
  String postnum;

  DocumentReference reference;

  IncidentPostModel({this.title,this.id,this.postnum,this.timestamp,this.place,this.upvotes,this.downvotes,this.uploader,this.image});

  factory IncidentPostModel.fromSnapshot(DocumentSnapshot snapshot) {
    IncidentPostModel newPost = IncidentPostModel.fromJson(snapshot.data);
    newPost.reference = snapshot.reference;
    return newPost;
  }

  factory IncidentPostModel.fromJson(Map<String, dynamic> json) => _PostFromJson(json);

  Map<String, dynamic> toJson() => _PostToJson(this);

  @override
  String toString() => "Post<$title>";

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

IncidentPostModel _PostFromJson(Map<String,dynamic> json){
  return IncidentPostModel(
    title: json['title'] as String,
    id: json['id'] as String,
    postnum: json['postnum'] as String,
    timestamp: json['timestamp'] as String,
    place: json['place'] as String,
    upvotes: json['upvotes'] as String,
    downvotes: json['downvotes'] as String,
    uploader: json['uploader'] as String,
    image: json['image'] as String
  );
}

Map<String, dynamic> _PostToJson(IncidentPostModel instance) => <String, dynamic> {
  'title': instance.title,
  'id': instance.id,
  'postnum': instance.postnum,
  'timestamp': instance.timestamp,
  'place': instance.place,
  'upvotes': instance.upvotes,
  'downvotes': instance.downvotes,
  'uploader': instance.uploader,
  'image' :instance.image
};