import 'package:daily_record_flutter/module/date_record.dart';

abstract class PersistentApi {
  Future<void> saveRecordKey(DateTime dateTime, String key, String value);

  Future<List<DateRecord>> dateRecordsByDate(DateTime dateTime);

  Future<void> deleteRecordKey(DateTime dateTime, String key);

  Future<void> saveColor(DateTime dateTime, String color);

  Future<String?> getColor(DateTime dateTime);

  Future<void> deleteColor(DateTime dateTime);

  Future<Map> getDateColorList();
}
