import 'package:daily_record_flutter/module/date_record.dart';
import 'package:daily_record_flutter/persistent/persistent.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarViewModel extends ChangeNotifier {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime? selectedDay;
  DateTime focusDay = DateTime.now();
  List<DateRecord> dateRecords = <DateRecord>[];
  Map dateColorMap = new Map();

  String? getColor(DateTime datetime) {
    return dateColorMap[datetime];
  }

  Future<void> setColor(String color) async {
    await Persistent.saveColor(focusDay, color);
    this.dateColorMap = await Persistent.getDateColorMap();
    notifyListeners();
  }

  Future<void> unsetColor() async {
    await Persistent.deleteColor(focusDay);
    this.dateColorMap = await Persistent.getDateColorMap();
    notifyListeners();
  }

  Future<void> fetchColorList() async {
    this.dateColorMap = await Persistent.getDateColorMap();
    notifyListeners();
  }

  Future<void> selectDay(
      DateTime selectDateTime, DateTime focusDateTime) async {
    selectedDay = selectDateTime;
    focusDay = focusDateTime;
    dateRecords = await Persistent.dateRecordsByDate(focusDay);
    notifyListeners();
  }

  Future<void> saveRecord(DateTime dateTime, String key, String value) async {
    Persistent.saveRecord(dateTime, key, value);
    this.dateRecords = await Persistent.dateRecordsByDate(focusDay);
    notifyListeners();
  }

  Future<void> deleteRecord(String key) async {
    await Persistent.deleteRecord(focusDay, key);
    this.dateRecords = await Persistent.dateRecordsByDate(focusDay);
    notifyListeners();
  }
}
