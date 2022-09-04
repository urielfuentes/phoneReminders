import 'package:choresreminder/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../Common/constants.dart';
import '../../models/chore.dart';

enum TimeScope { days, weeks, months, years }

const timeScopes = <TimeScope, String>{
  TimeScope.days: "Dias",
  TimeScope.weeks: "Semanas",
  TimeScope.months: "Meses",
  TimeScope.years: "Años"
};

class AddChore extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  AddChore({Key? key}) : super(key: key);

  @override
  State<AddChore> createState() => _AddChoreState();
}

class _AddChoreState extends State<AddChore> {
  String name = "";
  String description = "";
  bool addTag = false;
  int timeQuantity = 0;
  TimeScope timeScope = TimeScope.months;
  List<String> tags = [];
  String choreTag = noTag;

  String? timeQuantityValidator(value) {
    var quantity = int.tryParse(value ?? "");
    if (quantity != null) {
      if (quantity < 1) {
        return 'Ingresa un numero positivo.';
      }
    } else {
      return 'Debes ingresar un numero entero.';
    }
    return null;
  }

  void onFormSubmit() {
    if (widget.formKey.currentState?.validate() ?? false) {
      Box<Chore> choresBox = Hive.box<Chore>(choresBoxName);
      if (choreTag != noTag) {
        var tagBox = Hive.box<String>(tagsBoxName);
        tagBox.put(choreTag, choreTag);
      }

      var now = DateTime.now();
      var today = DateTime(now.year, now.month, now.day, 0, 0);
      var expiryTime = now;
      switch (timeScope) {
        case TimeScope.days:
          expiryTime = today.add(Duration(days: timeQuantity));
          break;
        case TimeScope.weeks:
          expiryTime = today.add(Duration(days: timeQuantity * 7));
          break;
        case TimeScope.months:
          expiryTime = today.add(Duration(days: timeQuantity * 30));
          break;
        case TimeScope.years:
          expiryTime = today.add(Duration(days: timeQuantity * 365));
          break;
      }
      if (choresBox.keys.isNotEmpty) {
        choresBox.put(
            choresBox.keys.last + 1,
            Chore(choresBox.keys.last + 1, name, description, choreTag,
                expiryTime));
      } else {
        choresBox.put(0, Chore(0, name, description, choreTag, expiryTime));
      }
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    var box = Hive.box<String>(tagsBoxName);
    setState(() {
      tags = box.values.where((element) => element != noTag).toList();
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
            Row(
              children: [
                Container(
                  width: 40,
                  margin: const EdgeInsets.only(right: 8),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    initialValue: "",
                    validator: timeQuantityValidator,
                    onChanged: (value) {
                      setState(() {
                        timeQuantity = int.tryParse(value) ?? timeQuantity;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: DropdownButtonFormField(
                    items: timeScopes.keys.map((TimeScope value) {
                      return DropdownMenuItem<TimeScope>(
                        value: value,
                        child: Text(timeScopes[value]!),
                      );
                    }).toList(),
                    value: timeScope,
                    hint: const Text("Periodo"),
                    onChanged: (TimeScope? value) {
                      setState(() {
                        timeScope = value ?? TimeScope.months;
                      });
                    },
                  ),
                ),
              ],
            ),
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
                              child: Text(tag),
                            ))
                        .toList(),
                    DropdownMenuItem<String>(
                      value: noTag,
                      onTap: () => {
                        setState(() {
                          addTag = false;
                        })
                      },
                      child: const Text(noTagText),
                    ),
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
                  value: noTag,
                  onChanged: (String? value) => {
                    setState(() {
                      choreTag = value ?? noTag;
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
                        choreTag = value;
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
