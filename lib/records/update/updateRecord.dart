import 'package:choresreminder/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/chore.dart';
import '../../models/record.dart';
import '../../services/date_service.dart';

enum TimeScope { days, weeks, months, years }

class UpdateRecord extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final int recordKey;
  UpdateRecord({Key? key, this.recordKey = -1}) : super(key: key);

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  Record recordToUpdateCopy = Record(0, "", "", DateTime.now());
  String dateString = "";

  void onFormSubmit() {
    if (widget.formKey.currentState?.validate() ?? false) {
      Box<Record> recordsBox = Hive.box<Record>(recordsBoxName);
      recordsBox.put(widget.recordKey, recordToUpdateCopy);
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    var box = Hive.box<Record>(recordsBoxName);
    Record recordToUpdate;
    recordToUpdate = box.get(widget.recordKey)!;
    setState(() {
      recordToUpdateCopy = recordToUpdate;
      dateString = "Fecha: ${getDateStringRecord(recordToUpdate.entryDate)}";
    });
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
                initialValue: recordToUpdateCopy.name,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa un nombre.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    recordToUpdateCopy.name = value;
                  });
                }),
            TextFormField(
                initialValue: recordToUpdateCopy.description,
                decoration: const InputDecoration(labelText: "Descripción"),
                onChanged: (value) {
                  setState(() {
                    recordToUpdateCopy.description = value;
                  });
                }),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(dateString)),
              InkWell(
                onTap: () async {
                  var newDate = await showDatePicker(
                      context: context,
                      initialDate: recordToUpdateCopy.entryDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  if (newDate == null) return;
                  setState(() {
                    recordToUpdateCopy.entryDate = DateTime(
                        newDate.year, newDate.month, newDate.day, 0, 0);
                    dateString = "Fecha: ${getDateStringRecord(newDate)}";
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 12, top: 10),
                  child: Icon(
                    FontAwesomeIcons.calendar,
                    size: 25,
                  ),
                ),
              )
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: OutlinedButton(
                onPressed: onFormSubmit,
                child: const Text("Guardar"),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
