import 'package:choresreminder/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../Common/constants.dart';
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
  final String launcherTag;
  AddRecord({Key? key, this.launcherTag = noTag}) : super(key: key);

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  String name = "";
  String description = "";
  bool addTag = false;
  List<String> tags = [];
  String recordTag = noTag;

  void onFormSubmit() {
    if (widget.formKey.currentState?.validate() ?? false) {
      Box<Record> recordsBox = Hive.box<Record>(recordsBoxName);
      var tagBox = Hive.box<String>(recordsTagsBoxName);
      tagBox.put(recordTag, recordTag);
      var now = DateTime.now();
      var today = DateTime(now.year, now.month, now.day, 0, 0);
      var expiryTime = today;
      if (recordsBox.keys.isNotEmpty) {
        recordsBox.put(
            recordsBox.keys.last + 1,
            Record(recordsBox.keys.last + 1, name, description, expiryTime,
                recordTag));
      } else {
        recordsBox.put(0, Record(0, name, description, expiryTime, recordTag));
      }
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    setState(() {
      tags = Hive.box<String>(recordsTagsBoxName).values.toList();
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
            Row(children: [
              SizedBox(
                width: 130,
                child: DropdownButtonFormField(
                  items: [
                    ...tags
                        .map((tag) => DropdownMenuItem<String>(
                              value: tag,
                              onTap: () => {
                                setState(() {
                                  addTag = false;
                                })
                              },
                              child: Text(tag == noTag ? noTagText : tag),
                            ))
                        .toList(),
                    DropdownMenuItem<String>(
                      value: "",
                      onTap: () => {
                        setState(() {
                          addTag = true;
                        })
                      },
                      child: const Text("Agregar"),
                    ),
                  ],
                  value: widget.launcherTag,
                  onChanged: (String? value) => {
                    setState(() {
                      recordTag = value ?? noTag;
                    })
                  },
                ),
              ),
              if (addTag)
                Container(
                  width: 150,
                  margin: const EdgeInsets.only(left: 12),
                  child: TextFormField(
                    initialValue: "",
                    decoration: const InputDecoration(labelText: "Etiqueta"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa una etiqueta.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        recordTag = value;
                      });
                    },
                  ),
                ),
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
