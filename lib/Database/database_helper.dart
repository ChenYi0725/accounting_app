import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _accountDatabase;
  static Database? _insertTypeDatabase;
  static Database? _vehicleDatabase;

  // 獲取 accounts 資料庫
  Future<Database> get accountDatabase async {
    if (_accountDatabase != null) return _accountDatabase!;
    _accountDatabase = await _initAccountDatabase();
    return _accountDatabase!;
  }

  Future<Map<String, dynamic>?> fetchAccountById(int id) async {
    final db = await _accountDatabase;
    final result = await db!.query(
      'accounts',
      where: '_id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<Database> get insertTypeDatabase async {
    if (_insertTypeDatabase != null) return _insertTypeDatabase!;
    _insertTypeDatabase = await _initInsertTypeDatabase();
    return _insertTypeDatabase!;
  }

  Future<Database> get vehicleDatabase async {
    if (_vehicleDatabase != null) return _vehicleDatabase!;
    _vehicleDatabase = await _initVehicleDatabase();
    return _vehicleDatabase!;
  }

  // 初始化 accounts.db
  Future<Database> _initAccountDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'accounts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE accounts (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            money INTEGER NOT NULL,
            isExpense BOOLEAN NOT NULL,
            date INTEGER NOT NULL,
            description TEXT
          )
        ''');
      },
    );
  }

// 初始化 insertType.db
  Future<Database> _initInsertTypeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'insertType.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE custom_types (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          isExpense INTEGER NOT NULL,  -- 是否為支出 (0 或 1)
          iconName TEXT NOT NULL       -- 儲存圖標名稱
        )
      ''');
      },
    );
  }

  // 初始化 vehicles.db
  Future<Database> _initVehicleDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'vehicles.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE vehicles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            number TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // 修改 accounts
  Future<int> updateAccount(int id, String type, int money, bool isExpense,
      int date, String description) async {
    final db = await accountDatabase;
    return await db.update(
      'accounts',
      {
        'type': type,
        'money': money,
        'isExpense': isExpense ? 1 : 0,
        'date': date,
        'description': description,
      },
      where: '_id = ?',
      whereArgs: [id],
    );
  }

  // 抓出固定時間段資料
  Future<List<Map<String, dynamic>>> fetchAccountsByDateRange(
      int startDate, int endDate) async {
    final db = await accountDatabase;
    return await db.query(
      'accounts',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
      orderBy: 'date DESC',
    );
  }

  Future<int> fetchTotalByDateRange(
      int startDate, int endDate, bool isExpense) async {
    final db = await accountDatabase;

    final result = await db.rawQuery(
      '''
      SELECT SUM(money) as total 
      FROM accounts 
      WHERE date BETWEEN ? AND ? AND isExpense = ?
      ''',
      [startDate, endDate, isExpense ? 1 : 0],
    );

    // 返回總和，若為 null 則返回 0
    return result.first['total'] != null ? result.first['total'] as int : 0;
  }

  // 插入 accounts
  Future<int> insertAccount(String type, int money, bool isExpense, int date,
      String description) async {
    final db = await accountDatabase;
    return await db.insert('accounts', {
      'type': type,
      'money': money,
      'isExpense': isExpense ? 1 : 0,
      'date': date,
      'description': description,
    });
  }

  // 查詢 accounts
  Future<List<Map<String, dynamic>>> fetchAccounts() async {
    final db = await accountDatabase;
    return await db.query('accounts', orderBy: 'date DESC');
  }

  // 刪除 accounts
  Future<int> deleteAccount(int id) async {
    final db = await accountDatabase;
    return await db.delete('accounts', where: '_id = ?', whereArgs: [id]);
  }

//------------------
  // 插入 custom_types 資料表
  Future<int> insertType(String name, bool isExpense, String iconData) async {
    final db = await insertTypeDatabase;
    return await db.insert('custom_types', {
      'name': name,
      'isExpense': isExpense ? 1 : 0,
      'iconName': iconData, // 儲存圖標的 codePoint
    });
  }

// // 從資料庫中獲取圖標並顯示
//   Future<Icon> getIcon(int id) async {
//     final db = await insertTypeDatabase;
//     List<Map<String, dynamic>> result =
//         await db.query('custom_types', where: 'id = ?', whereArgs: [id]);
//
//     if (result.isNotEmpty) {
//       String iconName = result[0]['iconName']; // 讀取圖標名稱
//       return Icon(_getIconData(iconName)); // 使用對應的 Icon
//     }
//
//     return Icon(Icons.help_outline); // 如果找不到圖標，返回預設圖標
//   }
//
// // 根據圖標名稱返回對應的 IconData
//   IconData _getIconData(String iconName) {
//     switch (iconName) {
//       case 'Icons.home':
//         return Icons.home;
//       case 'Icons.account_circle':
//         return Icons.account_circle;
//       default:
//         return Icons.help_outline; // 預設圖標
//     }
//   }

  // 查詢所有 insertType
  Future<List<Map<String, dynamic>>> fetchInsertTypes(int isExpense) async {
    final db = await insertTypeDatabase;
    return await db.query(
      'custom_types',
      where: 'isExpense = ?',
      whereArgs: [isExpense], // 1 代表支出
    );
  }

  Future<List<Map<String, dynamic>>> _fetchInsertTypesToList(
      int isExpense) async {
    final dbHelper = DatabaseHelper();
    final rawTypes = await dbHelper.fetchInsertTypes(isExpense); // 0 表示收入
    return rawTypes
        .map((type) => {
              'name': type['name'] as String,
              'icon': IconData(
                int.parse(type['iconName']),
                fontFamily: 'MaterialIcons',
              )
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchTypes() async {
    final db = await insertTypeDatabase;
    return await db.query('custom_types');
  }

  Future<int> deleteType(int id) async {
    final db = await insertTypeDatabase;
    return await db.delete('custom_types', where: 'id = ?', whereArgs: [id]);
  }

  // 插入 vehicles 資料表
  Future<int> insertVehicle(String number) async {
    final db = await vehicleDatabase;
    return await db.insert('vehicles', {
      'number': number,
    });
  }

  Future<Map<String, dynamic>?> fetchVehicle() async {
    final db = await vehicleDatabase;
    final result = await db.query('vehicles');

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<int> updateVehicle(String number) async {
    final db = await vehicleDatabase;
    final vehicle = await fetchVehicle();

    if (vehicle != null) {
      return await db.update(
        'vehicles',
        {
          'number': number,
        },
        where: 'id = ?',
        whereArgs: [vehicle['id']],
      );
    } else {
      return await insertVehicle(number);
    }
  }

  Future<int> deleteVehicle(int id) async {
    final db = await vehicleDatabase;
    return await db.delete('vehicles', where: 'id = ?', whereArgs: [id]);
  }
}
