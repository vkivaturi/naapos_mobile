import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "Items.db";
  static final _databaseVersion = 1;

  static final itemTable = 'items_table';
  static final columnITCode = 'code';
  static final columnITItemDetail = 'itemDetail';
  static final columnITTax = 'tax';
  static final columnITUnitPrice = 'unitPrice';

  static final invoiceTable = 'invoice_table';
  static final columnIVtransactions = 'transactions';
  static final columnIVinvoiceDateTime = 'invoiceDateTime';
  static final columnIVoperatorId = 'operatorId';
  static final columnIVstoreId = 'storeId';
  static final columnIVinvoiceNumber = 'invoiceNumber';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $itemTable (
            $columnITCode INT PRIMARY KEY,
            $columnITItemDetail TEXT NOT NULL,
            $columnITTax TEXT NOT NULL,
            $columnITUnitPrice TEXT NOT NULL
          )
          ''');

//    await db.execute('''
//          CREATE TABLE $invoiceTable (
//            $columnIVinvoiceNumber INT PRIMARY KEY,
//            $columnIVtransactions TEXT NOT NULL,
//            $columnITTax TEXT NOT NULL,
//            $columnITUnitPrice TEXT NOT NULL
//          )
//          ''');


  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertIT(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(itemTable, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryITAllRows() async {
    Database db = await instance.database;
    return await db.query(itemTable);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryITRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $itemTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateIT(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnITCode];
    return await db.update(itemTable, row, where: '$columnITCode = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteIT(int id) async {
    Database db = await instance.database;
    return await db.delete(itemTable, where: '$columnITCode = ?', whereArgs: [id]);
  }
}
