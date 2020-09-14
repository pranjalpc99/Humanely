import 'package:cloud_firestore/cloud_firestore.dart';

class IncidentPostModel {
  //final DocumentReference reference;
  String timestamp;
  String title;
  String place;
  String votes;

  IncidentPostModel({this.title,this.timestamp,this.place,this.votes});

  IncidentPostModel.fromJson(Map<String, dynamic> parsedJson)
    : title = parsedJson['title'],
      timestamp = parsedJson['timestamp'],
      place = parsedJson['place'],
      votes = parsedJson['votes'];

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