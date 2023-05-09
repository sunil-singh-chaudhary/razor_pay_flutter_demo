import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../payment_feature/db_user.dart';
import 'encryption_helper.dart';

class DBHelper {
  static const _tableName = 'paymentTable';
  static const _databaseName = 'UserDatabase.db';
  static const _columnId = 'id';
  static const _columnEncryptedOrderId = 'encrypted_order_id';
  static const _columnPaymentId = 'payment_id';
  static const _columnOrderDetails = 'order_details';
  static const _columnNumberOfOrder = 'no_of_order';
  static const _columnOrderPrice = 'order_price';
  static const _columnOrderTotalPrice = 'order_total_price';

  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() {
    return _instance;
  }
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);
    final database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  void _createDatabase(Database database, int version) async {
    await database.execute(
        'CREATE TABLE $_tableName($_columnId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$_columnEncryptedOrderId TEXT,'
        '  $_columnPaymentId TEXT,'
        '$_columnOrderDetails TEXT,'
        ' $_columnNumberOfOrder INTEGER,'
        '$_columnOrderPrice DOUBLE,'
        '$_columnOrderTotalPrice DOUBLE)');
  }

  Future<void> insertData({
    required String orderId,
    required String paymentId,
    required String orderDetails,
    required int numberofOrder,
    required double orderPrice,
    required double totalPrice,
  }) async {
    final db = await _initDatabase();
    final encryptedOrderId = await EncryptionHelper.encrypt(orderId);
    await db.insert(
      _tableName,
      {
        _columnEncryptedOrderId: encryptedOrderId,
        _columnPaymentId: paymentId,
        _columnOrderDetails: orderDetails,
        _columnNumberOfOrder: numberofOrder,
        _columnOrderPrice: orderPrice,
        _columnOrderTotalPrice: totalPrice,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> getDataFromDatabase() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> results = await db.query(_tableName);

    final decryptedResults = await Future.wait(
      results.map(
        (result) async {
          final orderId = result[_columnEncryptedOrderId] as String;
          final paymentID = result[_columnPaymentId] as String;
          final orderPrice = result[_columnOrderPrice] as double;
          final orderDetails = result[_columnOrderDetails] as String;
          final decryptedOrderId = await EncryptionHelper.decrypt(orderId);
          // return {
          //   'orderId': decryptedOrderId,
          //   'paymentID': paymentID,
          //   'OrderPrice': OrderPrice,
          //   'orderDetails': orderDetails,
          // };
          return User(
            orderId: decryptedOrderId,
            OrderPrice: orderPrice,
            paymentID: paymentID,
            orderDetails: orderDetails,
          );
        },
      ),
    );

    return decryptedResults;
  }

  Future<void> deleteData(int id) async {
    final db = await _initDatabase();
    await db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }
}
