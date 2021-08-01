import 'package:daily_record_flutter/vm/calendar_view_model.dart';
import 'package:flutter/material.dart';

class RecordAddViewModel extends ChangeNotifier {
  final DateTime dateTime;

  final CalendarViewModel calendarViewModel;

  RecordAddViewModel(this.dateTime, this.calendarViewModel);

  void saveRecord(String key, String value) {
    calendarViewModel.saveRecord(dateTime, key, value);
  }
}
