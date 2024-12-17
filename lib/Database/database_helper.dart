import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _accountDatabase;
  static Database? _insertTypeDatabase;

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
            icon TEXT NOT NULL
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

  // 插入 custom_types 資料表
  Future<int> insertType(String name, String icon) async {
    final db = await insertTypeDatabase;
    return await db.insert('custom_types', {
      'name': name,
      'icon': icon,
    });
  }

  Future<List<Map<String, dynamic>>> fetchTypes() async {
    final db = await insertTypeDatabase;
    return await db.query('custom_types');
  }

  Future<int> deleteType(int id) async {
    final db = await insertTypeDatabase;
    return await db.delete('custom_types', where: 'id = ?', whereArgs: [id]);
  }
}
