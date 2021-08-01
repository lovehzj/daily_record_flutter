import 'package:daily_record_flutter/vm/record_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordAddDialog extends StatefulWidget {
  RecordAddDialog({Key? key}) : super(key: key);

  @override
  _RecordAddState createState() => _RecordAddState();
}

class _RecordAddState extends State<RecordAddDialog> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RecordAddViewModel>(context);
    var keyEditController = TextEditingController();
    var valueEditController = TextEditingController();
    return AlertDialog(
      scrollable: true,
      title: Text('Add Record Form'),
      content: Form(
          child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Key'),
            controller: keyEditController,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Value'),
            controller: valueEditController,
          ),
        ],
      )),
      actions: [
        ElevatedButton(
          child: Text('添加'),
          onPressed: () {
            vm.saveRecord(
                keyEditController.value.text, valueEditController.value.text);
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('返回'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
