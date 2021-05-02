import 'dart:io';

import 'package:Grab_Link/models/CustomLink.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String tableName = 'customlinks';
  String colId = 'id';
  String colTitle = 'title';
  String colLink = 'link';
  String colCategory = 'category';
  String colDateAdded = 'dateAdded';

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createinstance();
    }
    return _databaseHelper;
  }

  DatabaseHelper._createinstance();

  get database async {
    if (_database == null) {
      _database = await initalizeDatabase();
    }
    return _database;
  }

  Future<Database> initalizeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'customlinks.db';

    var transactionDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return transactionDatabase;
  }

  _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,$colLink TEXT,$colCategory TEXT,$colDateAdded TEXT)');
  }

  // Fetch
  Future<List<Map<String, dynamic>>> getCustomLinks() async {
    Database db = await this.database;
    var result = await db.query(
      tableName,
      orderBy: '$colId DESC',
    );
    return result;
  }

  // Insert
  Future<int> insertLink(CustomLink customLink) async {
    Database db = await this.database;
    var result = await db.insert(tableName, customLink.toJson());
    return result;
  }

  // Delete
  Future<int> deleteLink(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $tableName WHERE $colId = $id');
    return result;
  }
}
