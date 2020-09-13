import 'package:cloud_firestore/cloud_firestore.dart';

class IncidentPostModel {
  final DocumentReference reference;
  String timestamp;
  String title;
  String place;
  String vote;

  IncidentPostModel.data(this.reference,
      [this.timestamp,
        this.title,this.place,this.vote]) {
    // Set these rather than using the default value because Firebase returns
    // null if the value is not specified.
    this.timestamp ??= "";
    this.title??="";
    this.place="";
    this.vote ??= "0";
  }

  factory IncidentPostModel.from(DocumentSnapshot document) => IncidentPostModel.data(
      document.reference,
      document.data['timestamp'],
      document.data['title'],
      document.data['place'],
     document.data['votes'],
  );

  void save() {
    reference.setData(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'title': vote,
      'place': place,
      'votes':vote,
    };
  }
}