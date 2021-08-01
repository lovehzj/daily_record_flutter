import 'dart:developer';

import 'package:daily_record_flutter/module/date_record.dart';
import 'package:daily_record_flutter/persistent/persistent_api.dart';
import 'package:daily_record_flutter/persistent/po/date_color_po.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PersistentDb implements PersistentApi {
  static const String TABLE_DAILY_COLOR = 'daily_color';

  static const String TABLE_DAILY_RECORD = 'daily_record';

  static PersistentDb? _dbProvider;

  final Database database;

  PersistentDb(this.database);

  static Future<PersistentDb> getInstance() async {
    if (_dbProvider != null) {
      return _dbProvider!;
    }
    var dbPath = await getDatabasesPath();
    log('dbPath: $dbPath');
    Database database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(dbPath, 'daily_record.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return initTable(db);
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    _dbProvider = new PersistentDb(database);
    return _dbProvider!;
  }

  static initTable(Database db) async {
    log('init tables start');
    await db.execute(
      'CREATE TABLE $TABLE_DAILY_RECORD(id INTEGER PRIMARY KEY, day TEXT, key TEXT, value TEXT)',
    );
    await db.execute(
      'CREATE TABLE $TABLE_DAILY_COLOR(id INTEGER PRIMARY KEY, day TEXT, color TEXT)',
    );
  }

  @override
  Future<void> saveRecordKey(
      DateTime dateTime, String key, String value) async {
    var aux = await getInstance();
    var list = [dateTime.toString(), key, value];
    aux.database.execute(
        'INSERT INTO $TABLE_DAILY_RECORD (day, key, value) VALUES (?, ?, ?)',
        list);
  }

  @override
  Future<List<DateRecord>> dateRecordsByDate(DateTime dateTime) async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps = await aux.database.query(
        TABLE_DAILY_RECORD,
        where: 'day = ?',
        whereArgs: [dateTime.toString()]);
    return List.generate(maps.length, (i) {
      var aux = maps[i];
      return DateRecord(aux['key'], aux['value']);
    });
  }

  @override
  Future<void> deleteRecordKey(DateTime dateTime, String key) async {
    var aux = await getInstance();
    aux.database.delete(TABLE_DAILY_RECORD,
        where: 'day = ?', whereArgs: [dateTime.toString()]);
  }

  @override
  Future<void> deleteColor(DateTime dateTime) async {
    var aux = await getInstance();
    aux.database.delete(TABLE_DAILY_COLOR,
        where: 'day = ?', whereArgs: [dateTime.toString()]);
  }

  @override
  Future<String?> getColor(DateTime dateTime) async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps = await aux.database.query(
        TABLE_DAILY_COLOR,
        where: 'day = ?',
        whereArgs: [dateTime.toString()]);
    List<DateColorPo> resultList = List.generate(maps.length, (i) {
      var aux = maps[i];
      return DateColorPo(aux['day'], aux['color']);
    });
    if (resultList.length == 0) {
      return null;
    }
    var result = resultList[0];
    return result.color;
  }

  @override
  Future<Map> getDateColorList() async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps =
        await aux.database.query(TABLE_DAILY_COLOR);
    List<DateColorPo> resultList = List.generate(maps.length, (i) {
      var aux = maps[i];
      return DateColorPo(DateTime.parse(aux['day']), aux['color']);
    });
    Map resultMap = new Map();
    for (var value in resultList) {
      resultMap[value.time] = value.color;
    }
    return resultMap;
  }

  @override
  Future<void> saveColor(DateTime dateTime, String color) async {
    var aux = await getInstance();
    var list = [dateTime.toString(), color];
    aux.database.execute(
        'INSERT INTO $TABLE_DAILY_COLOR (day, color) VALUES (?, ?)', list);
  }
}
