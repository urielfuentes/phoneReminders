import 'package:choresreminder/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../Common/constants.dart';
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
  Record recordToUpdate = Record(0, "", "", DateTime.now(), noTag);
  String dateString = "";
  String initTag = noTag;
  List<String> tags = [];
  bool addTag = false;

  void onFormSubmit() {
    if (widget.formKey.currentState?.validate() ?? false) {
      var tagBox = Hive.box<String>(recordsTagsBoxName);
      tagBox.put(recordToUpdate.tag, recordToUpdate.tag);
      Box<Record> recordsBox = Hive.box<Record>(recordsBoxName);
      recordsBox.put(widget.recordKey, recordToUpdate);
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    var box = Hive.box<Record>(recordsBoxName);
    var tagsBox = Hive.box<String>(recordsTagsBoxName);
    var tempTags = tagsBox.values.where((element) => element != noTag).toList();
    tempTags.add(noTagText);

    setState(() {
      recordToUpdate = box.get(widget.recordKey)!;
      dateString = "Fecha: ${getDateStringRecord(recordToUpdate.entryDate)}";
      tags = tempTags;
      initTag = recordToUpdate.tag;
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
                initialValue: recordToUpdate.name,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa un nombre.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    recordToUpdate.name = value;
                  });
                }),
            TextFormField(
                initialValue: recordToUpdate.description,
                decoration: const InputDecoration(labelText: "Descripción"),
                onChanged: (value) {
                  setState(() {
                    recordToUpdate.description = value;
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
                      initialDate: recordToUpdate.entryDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  if (newDate == null) return;
                  setState(() {
                    recordToUpdate.entryDate = DateTime(
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
            Row(children: [
              SizedBox(
                width: 130,
                child: DropdownButtonFormField(
                  items: [
                    ...tags
                        .map((tag) => DropdownMenuItem<String>(
                              value: tag == noTagText ? noTag : tag,
                              onTap: () => {
                                setState(() {
                                  addTag = false;
                                })
                              },
                              child: Text(tag),
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
                  value: initTag,
                  onChanged: (String? value) => {
                    setState(() {
                      recordToUpdate.tag = value ?? noTag;
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
                        recordToUpdate.tag = value;
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
