import 'package:daily_record_flutter/module/date_record.dart';
import 'package:daily_record_flutter/persistent/persistent_api.dart';

class PersistentMemory implements PersistentApi {
  var dateMap = new Map();
  var colorMap = new Map();

  @override
  Future<void> saveRecordKey(
      DateTime dateTime, String key, String value) async {
    var dayMap = dateMap[dateTime];
    if (dayMap == null) {
      dateMap[dateTime] = new Map();
    }
    dateMap[dateTime][key] = value;
  }

  @override
  Future<List<DateRecord>> dateRecordsByDate(DateTime dateTime) async {
    var dayMap = dateMap[dateTime];
    if (dayMap == null) {
      return <DateRecord>[];
    }
    return dayMap.entries
        .map<DateRecord>((entry) => DateRecord(entry.key, entry.value))
        .toList();
  }

  @override
  Future<void> deleteRecordKey(DateTime dateTime, String key) async {
    var dayMap = dateMap[dateTime];
    if (dayMap == null) {
      return;
    }
    Map aux = dayMap;
    aux.remove(key);
  }

  @override
  Future<void> saveColor(DateTime dateTime, String color) async {
    colorMap[dateTime] = color;
  }

  @override
  Future<String?> getColor(DateTime dateTime) async {
    return colorMap[dateTime];
  }

  @override
  Future<void> deleteColor(DateTime dateTime) async {
    colorMap.remove(dateTime);
  }

  @override
  Future<Map> getDateColorList() async {
    return colorMap;
  }
}
