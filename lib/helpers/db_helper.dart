import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'todolist.db'),
        onCreate: (db, version) => _createDb(db), version: 1);
  }

  static void _createDb(Database db) async {
    await db.execute(
        'CREATE TABLE category(CategoryId INTEGER PRIMARY KEY,CategoryName TEXT, IsDeleted INTEGER DEFAULT 0)');
    await db.execute(
        'CREATE TABLE item(ItemId INTEGER PRIMARY KEY, CategoryId_FK INTEGER, ItemName TEXT, IsCompleted INTEGER DEFAULT 0, IsDeleted INTEGER DEFAULT 0, DateAdded TEXT, FOREIGN KEY (CategoryId_FK) REFERENCES category(CategoryId))');
  }

  static Future<void> updateWithId(
    String table,
    String whereClause,
    int? filterId,
    Map<String, Object> dataToUpdate,
  ) async {
    final db = await DBHelper.database();
    db.update(table, dataToUpdate, where: whereClause, whereArgs: [filterId]);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<int> insertReturnId(
      String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    final int insertedId = await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    return insertedId;
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getDataWithId(
      String table, String whereClause, String orderBy, int idFilter) async {
    final db = await DBHelper.database();

    return db.query(
      table,
      where: whereClause,
      orderBy: orderBy,
      whereArgs: [idFilter],
    );
  }

  static Future<List<Map<String, dynamic>>> getDataNotDeleted(
      String table, String whereClause) async {
    final db = await DBHelper.database();

    return db.query(
      table,
      where: whereClause,
    );
  }
}
