import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  static FirebaseAuth auth = FirebaseAuth.instance;
  static Firestore store = Firestore.instance;
}