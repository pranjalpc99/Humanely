import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:Humanely/models/user.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static const String TABLE = 'User';
  static const String DB_NAME = 'User.db';
  static const String ID = 'number';
  static const String F_NAME = 'first_name';
  static const String L_NAME = 'last_name';

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $TABLE ("
          "$ID INTEGER PRIMARY KEY,"
          "$F_NAME TEXT,"
          "$L_NAME TEXT"
          ")");
    });
  }

  /*Future<User> save(User user) async {
    var dbUser = await database;
    user.id = await dbUser.insert(TABLE, user.toMap());
    return user;

    *//*await dbUser.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($F_NAME) VALUES ('"+ user.fName +"')";
      return await txn.rawInsert(query);
    });*//*
  }*/

  /*Future<List<User>> getUser() async {
    var dbUser = await database;
    List<Map> map = await dbUser.query(TABLE,columns:[ID,F_NAME,L_NAME]);
    List<User> user = [];
    if(map.length>0) {
      for(int i=0;i<map.length;i++){
        user.add(User.fromMap(map[i]));
      }
    }
    return user;
  }*/

  Future close() async {
    var dbUser = await database;
    dbUser.close();
  }
}