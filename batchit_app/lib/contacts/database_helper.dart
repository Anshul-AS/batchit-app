//db helper file for adding data to contacts
//methods name are defined according to their working
import 'Contact.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String contactTable = 'contact_table';
  String colID = 'id';
  String colFirstname = 'firstname';
  String colLastname = 'lastname';
  String colPhone = 'phone';
  String colEmail = 'email';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }
  Future<Database> get database async {
    if(_database == null){
      _database = await initalizeDatabase();
    }
    return _database;
  }
  Future<Database>initalizeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path +'contacts.db';

    var contactsDatabase = await openDatabase(
      path, version: 1, onCreate: _createDb
    );
    return contactsDatabase;
  }
  void _createDb(Database db,int newVersion) async{
    await db.execute(
      'CREATE TABLE $contactTable($colID INTEGER PRIMARY KEY AUTOINCREMENT, $colFirstname TEXT, $colLastname TEXT,$colPhone TEXT,$colEmail TEXT)'
    );
  }

  Future<List<Map<String, dynamic>>> getContactMapList() async {
    Database db = await this.database;
    var result = await db.query(contactTable,orderBy: '$colFirstname ASC');
    return result;
  }  
  Future<int> insertContact(Contact contact) async {
    Database db = await this.database;
    var result = await db.insert(contactTable, contact.toMap());
    return result;
  }

  Future<int> updatetContact(Contact contact) async {
    Database db = await this.database;
    var result = await db.update(contactTable, contact.toMap(),
    where: '$colID = ?', whereArgs: [contact.id]);
    return result;
  }

  Future<int> deleteContact(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $contactTable WHERE $colID = $id');
    return result;
  }  

  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $contactTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
  Future<List<Contact>> getContactList() async {
    var contactMapList = await getContactMapList();
    int count = contactMapList.length;
    List<Contact> contactList = List<Contact>();
    for(var i=0;i<count;i++){
      contactList.add(Contact.fromMapObject(contactMapList[i]));
    }
    return contactList;
  }



}