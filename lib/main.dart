import 'package:daily_record_flutter/ui/screen/calendar_screen.dart';
import 'package:daily_record_flutter/vm/calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => CalendarViewModel(),
        child: CalendarScreen(),
      ).build(context),
    );
  }
}
