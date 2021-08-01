import 'package:daily_record_flutter/ui/dialog/record_add_dialog.dart';
import 'package:daily_record_flutter/vm/calendar_view_model.dart';
import 'package:daily_record_flutter/vm/record_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<CalendarViewModel>(context, listen: false);
    vm.fetchColorList();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarViewModel>(context);
    var tableView = SingleChildScrollView(
      child: DataTable(
        showCheckboxColumn: false,
        columns: [
          DataColumn(label: Text('Key')),
          DataColumn(label: Text('Value')),
          DataColumn(label: Text('Delete')),
        ],
        rows: vm.dateRecords
            .map((itemRow) => DataRow(cells: [
                  DataCell(Text(itemRow.key)),
                  DataCell(Text(itemRow.value)),
                  DataCell(TextButton(
                    child: Text('Delete'),
                    onPressed: () {
                      vm.deleteRecord(itemRow.key);
                    },
                  )),
                ]))
            .toList(),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Calendar'),
      ),
      body: ListView(
        children: [
          Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              selectedDayPredicate: (day) {
                return isSameDay(vm.selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                vm.selectDay(selectedDay, focusedDay);
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  var calendarStyle = const CalendarStyle();
                  final duration = const Duration(milliseconds: 250);
                  final margin = calendarStyle.cellMargin;
                  final text = '${day.day}';
                  var dayColor = vm.getColor(day);
                  if (dayColor == null) {
                    return AnimatedContainer(
                      duration: duration,
                      margin: margin,
                      decoration: calendarStyle.defaultDecoration,
                      alignment: Alignment.center,
                      child: Text(
                        text,
                        style: calendarStyle.defaultTextStyle,
                      ),
                    );
                  } else {
                    var color = Colors.black;
                    if (dayColor == "Red") {
                      color = Colors.red;
                    } else if (dayColor == "Blue") {
                      color = Colors.blue;
                    }
                    return Container(
                      margin: const EdgeInsets.all(1.0),
                      padding: const EdgeInsets.all(1.0),
                      decoration:
                          BoxDecoration(border: Border.all(color: color)),
                      child: AnimatedContainer(
                        duration: duration,
                        margin: margin,
                        decoration: calendarStyle.defaultDecoration,
                        alignment: Alignment.center,
                        child: Text(
                          text,
                          style: calendarStyle.defaultTextStyle,
                        ),
                      ),
                    );
                  }
                },
                dowBuilder: (context, day) {
                  if (day.weekday == DateTime.sunday) {
                    return Center(
                      child: Text(
                        'Sun',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  width: 100,
                  child: Text(
                    'Mark as Color',
                  ),
                ),
                Container(
                  width: 70,
                  child: TextButton(
                      onPressed: () {
                        vm.setColor("Red");
                      },
                      child: Text('Red')),
                ),
                Container(
                  width: 70,
                  child: TextButton(
                      onPressed: () {
                        vm.setColor("Blue");
                      },
                      child: Text('Blue')),
                ),
                Container(
                  width: 70,
                  child: TextButton(
                      onPressed: () {
                        vm.unsetColor();
                      },
                      child: Text('Unset')),
                ),
              ],
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {
                addRecord();
              },
              child: Text('Add Record'),
            ),
          ),
          tableView,
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void addRecord() {
    final vm = Provider.of<CalendarViewModel>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) => ChangeNotifierProvider(
              create: (context) => RecordAddViewModel(vm.focusDay, vm),
              child: RecordAddDialog(),
            ));
  }
}
