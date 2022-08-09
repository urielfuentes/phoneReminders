import 'package:choresreminder/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/chore.dart';
import '../../models/record.dart';

enum TimeScope { days, weeks, months, years }

const timeScopes = <TimeScope, String>{
  TimeScope.days: "Dias",
  TimeScope.weeks: "Semanas",
  TimeScope.months: "Meses",
  TimeScope.years: "Años"
};

class AddRecord extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  AddRecord({Key? key}) : super(key: key);

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  String name = "";
  String description = "";
  void onFormSubmit() {
    if (widget.formKey.currentState?.validate() ?? false) {
      Box<Record> recordsBox = Hive.box<Record>(recordsBoxName);
      var now = DateTime.now();
      var today = DateTime(now.year, now.month, now.day, 0, 0);
      var expiryTime = today;
      if (recordsBox.keys.isNotEmpty) {
        recordsBox.add(
            Record(recordsBox.keys.first + 1, name, description, expiryTime));
      } else {
        recordsBox.add(Record(0, name, description, expiryTime));
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Recordatorio."),
      ),
      body: SafeArea(
          child: Form(
        key: widget.formKey,
        child: ListView(
          padding: const EdgeInsets.only(left: 16, right: 60, top: 8),
          children: <Widget>[
            TextFormField(
                autofocus: true,
                initialValue: "",
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa un nombre.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                }),
            TextFormField(
                initialValue: "",
                decoration: const InputDecoration(labelText: "Descripción"),
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                }),
            OutlinedButton(
              onPressed: onFormSubmit,
              child: const Text("Guardar"),
            ),
          ],
        ),
      )),
    );
  }
}
