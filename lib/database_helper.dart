import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:naapos/entities.dart';

class DatabaseHelper {
  static final _databaseName = "Items.db";
  static final _databaseVersion = 1;

  //Table to store item level information
  static final itemTable = 'items_table';
  static final columnITCode = 'code';
  static final columnITItemDetail = 'itemDetail';
  static final columnITTax = 'tax';
  static final columnITUnitPrice = 'unitPrice';

  //Table to store transactions that are part of an invoice. This table includes all columns from Items table
  static final transactionTable = 'transaction_table';
  static final columnTRTransactionPrice = 'transactionPrice';
  static final columnTRTransactionNumber = 'transactionNumber';

  //Table to store invoice information
  static final invoiceTable = 'invoice_table';
  static final columnIVinvoiceDateTime = 'invoiceDateTime';
  static final columnIVoperatorId = 'operatorId';
  static final columnIVstoreId = 'storeId';
  static final columnIVinvoiceNumber = 'invoiceNumber';
  static final columnIVinvoiceAmount = 'invoiceAmount';
  static final columnIVinvoiceTax = 'invoiceTax';
  static final columnIVinvoiceQuantity = 'invoiceQuantity';

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
    return await openDatabase(
      path,
      version: _databaseVersion,
      onOpen: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $itemTable (
            $columnITCode INT PRIMARY KEY,
            $columnITItemDetail TEXT NOT NULL,
            $columnITTax TEXT NOT NULL,
            $columnITUnitPrice TEXT NOT NULL
          )
          ''');

//    await db.execute('''
//DROP TABLE $transactionTable          ''');
//
//    await db.execute('''
//DROP TABLE $invoiceTable          ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS $transactionTable (
            $columnTRTransactionNumber INT NOT NULL,
            $columnIVinvoiceNumber INT NOT NULL,
            $columnTRTransactionPrice TEXT NOT NULL,
            $columnITCode INT,
            $columnITItemDetail TEXT NOT NULL,
            $columnITTax TEXT NOT NULL,
            $columnITUnitPrice TEXT NOT NULL,
            $columnIVinvoiceQuantity TEXT NOT NULL,
            PRIMARY KEY($columnIVinvoiceNumber, $columnTRTransactionNumber)
          ) 
          ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS $invoiceTable (
            $columnIVinvoiceNumber INT PRIMARY KEY,
            $columnIVinvoiceDateTime TEXT,
            $columnIVoperatorId TEXT,
            $columnIVstoreId TEXT,
            $columnIVinvoiceAmount TEXT,
            $columnIVinvoiceQuantity TEXT,
            $columnIVinvoiceTax TEXT                   
          );
          ''');
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertIT(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(itemTable, row);
  }

  Future<int> insertTR(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(transactionTable, row);
  }

  Future<int> insertIV(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(invoiceTable, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryITAllRows() async {
    Database db = await instance.database;
    return await db.query(itemTable);
  }

  Future<List<Map<String, dynamic>>> queryIVAllRows() async {
    Database db = await instance.database;
    return await db.query(invoiceTable);
  }

  // All rows with user specifed key are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryITCode(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(itemTable,
        columns: [
          columnITCode,
          columnITItemDetail,
          columnITTax,
          columnITUnitPrice
        ],
        where: '$columnITCode = ?',
        whereArgs: [id]);
    if (result.length > 0) {
      return result;
    }
    return null;
  }

  //Fetch list of transactions for a specific invoice
  Future<List<Map<String, dynamic>>> queryTRTransaction(
      int invoiceNumber) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> result = await db.query(transactionTable,
        where:
            '$columnIVinvoiceNumber = ?',
        whereArgs: [invoiceNumber]);
    print("#### Result : " + result.length.toString());
    if (result.length > 0) {
      return result;
    }
    return [];
  }

  //Fetch list of invoices based on input range
  Future<List<Map<String, dynamic>>> queryIVInvoiceRange(
      int startInv, int endInv) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> result = await db.query(invoiceTable,
        where: '$columnIVinvoiceNumber >= ? and $columnIVinvoiceNumber <= ?',
        whereArgs: [startInv, endInv]);
    print("#### Result : " + result.length.toString());
    if (result.length > 0) {
      return result;
    }
    return null;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryITRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $itemTable'));
  }

  Future<int> queryIVRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $invoiceTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateIT(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnITCode];
    return await db
        .update(itemTable, row, where: '$columnITCode = ?', whereArgs: [id]);
  }
//  Future<int> updateIV(Map<String, dynamic> row) async {
//    Database db = await instance.database;
//    int id = row[columnIVinvoiceNumber];
//    return await db
//        .update(invoiceTable, row, where: '$columnIVinvoiceNumber = ?', whereArgs: [id]);
//  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteIT(int id) async {
    Database db = await instance.database;
    return await db
        .delete(itemTable, where: '$columnITCode = ?', whereArgs: [id]);
  }

  Future<int> deleteIV(int id) async {
    Database db = await instance.database;
    return await db.delete(invoiceTable,
        where: '$columnIVinvoiceNumber = ?', whereArgs: [id]);
  }

  //Reporting queries

  //Fetch top n items sold in a specific date range
  Future<List<Map<String, dynamic>>> queryTRTopItemsSold(
      int startInv, int endInv, int reqRows) async {
    Database db = await instance.database;

    List<Map> result = await db.rawQuery(
        'SELECT $columnITItemDetail, COUNT(*) AS soldCount FROM $transactionTable '
        'WHERE $columnITItemDetail IS NOT NULL AND $columnIVinvoiceNumber >= ? AND $columnIVinvoiceNumber <= ? '
        'GROUP BY $columnITItemDetail '
        'ORDER BY COUNT(*) DESC '
        'LIMIT $reqRows',
        [startInv, endInv]);
    print("#### Result : " + result.toString());
    if (result.length > 0) {
      return result;
    }
    return null;
  }

  //Fetch top n items sold in a specific date range
  Future<List<Map<String, dynamic>>> queryTRTopOrdersSold(
      int startInv, int endInv, int reqRows) async {
    Database db = await instance.database;

    List<Map> result = await db.rawQuery(
        'SELECT $columnIVinvoiceNumber, $columnIVinvoiceAmount AS soldCount FROM $invoiceTable '
            'WHERE $columnIVinvoiceAmount IS NOT NULL AND $columnIVinvoiceNumber >= ? AND $columnIVinvoiceNumber <= ? '
            'ORDER BY $columnIVinvoiceAmount DESC '
            'LIMIT $reqRows',
        [startInv, endInv]);
    print("#### Result : " + result.toString());
    if (result.length > 0) {
      return result;
    }
    return null;
  }

  //Fetch top n items sold in a specific date range
  Future<List<Map<String, dynamic>>> queryTrends(
      int startInv, int endInv) async {
    Database db = await instance.database;

    //Manipulation of invoice date is needed since we want to group by yyyyMMdd while the invoice number format is yyyyMMddHHmmSS
    List<Map> result = await db.rawQuery(
        'SELECT CAST($columnIVinvoiceNumber/1000000 as int) as saleDate, COUNT(*) as saleCount, SUM($columnIVinvoiceAmount) as saleAmount FROM $invoiceTable '
            'WHERE $columnIVinvoiceAmount IS NOT NULL AND $columnIVinvoiceNumber >= ? AND $columnIVinvoiceNumber <= ? '
            'GROUP BY $columnIVinvoiceNumber/1000000 '
            'ORDER BY $columnIVinvoiceAmount DESC ',
        [startInv, endInv]);
    print("#### Result : " + result.toString());
    if (result.length > 0) {
      return result;
    }
    return null;
  }

}
