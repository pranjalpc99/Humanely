import 'package:cloud_firestore/cloud_firestore.dart';

class MarkerModel {
  //final DocumentReference reference;
  String lat;
  String lng;

  DocumentReference reference;

  MarkerModel({this.lat,this.lng});

  factory MarkerModel.fromSnapshot(DocumentSnapshot snapshot) {
    MarkerModel newPost = MarkerModel.fromJson(snapshot.data);
    newPost.reference = snapshot.reference;
    return newPost;
  }

  factory MarkerModel.fromJson(Map<String, dynamic> json) => _PostFromJson(json);

  Map<String, dynamic> toJson() => _PostToJson(this);

  @override
  String toString() => "Post<$lat>";

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

MarkerModel _PostFromJson(Map<String,dynamic> json){
  return MarkerModel(
    lat: json['lat'] as String,
    lng: json['lng'] as String,
  );
}

Map<String, dynamic> _PostToJson(MarkerModel instance) => <String, dynamic> {
  'lat': instance.lat,
  'lng': instance.lng,
};