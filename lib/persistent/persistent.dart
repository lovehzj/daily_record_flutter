import 'package:daily_record_flutter/module/date_record.dart';
import 'package:daily_record_flutter/persistent/persistent_api.dart';
import 'package:daily_record_flutter/persistent/persistent_memory.dart';

class Persistent {
  static PersistentApi? api;

  static Future<PersistentApi> getApi() async {
    if (api == null) {
      api = new PersistentMemory();
    }
    return api!;
  }

  static Future<void> saveRecord(
      DateTime dateTime, String key, String value) async {
    return (await getApi()).saveRecordKey(dateTime, key, value);
  }

  static Future<List<DateRecord>> dateRecordsByDate(DateTime dateTime) async {
    return (await getApi()).dateRecordsByDate(dateTime);
  }

  static Future<void> deleteRecord(DateTime dateTime, String key) async {
    return (await getApi()).deleteRecordKey(dateTime, key);
  }

  static Future<void> saveColor(DateTime dateTime, String color) async {
    return (await getApi()).saveColor(dateTime, color);
  }

  static Future<String?> getColor(DateTime dateTime) async {
    return (await getApi()).getColor(dateTime);
  }

  static Future<void> deleteColor(DateTime dateTime) async {
    return (await getApi()).deleteColor(dateTime);
  }

  static Future<Map> getDateColorMap() async {
    return (await getApi()).getDateColorList();
  }
}
