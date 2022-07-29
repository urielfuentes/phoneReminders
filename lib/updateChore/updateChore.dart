import 'package:choresreminder/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/chore.dart';
import '../services/date_service.dart';

enum TimeScope { days, weeks, months, years }

const timeScopes = <TimeScope, String>{
  TimeScope.days: "Dias",
  TimeScope.weeks: "Semanas",
  TimeScope.months: "Meses",
  TimeScope.years: "Años"
};

class UpdateChore extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final int choreKey;
  UpdateChore({Key? key, this.choreKey = -1}) : super(key: key);

  @override
  State<UpdateChore> createState() => _UpdateChoreState();
}

class _UpdateChoreState extends State<UpdateChore> {
  String name = "";
  String description = "";
  int days = 0;
  int weeks = 0;
  int months = 0;
  int years = 0;

  void onFormSubmit() {
    if (widget.formKey.currentState?.validate() ?? false) {
      Box<Chore> choresBox = Hive.box<Chore>(boxName);
      var now = DateTime.now();
      var today = DateTime(now.year, now.month, now.day, 0, 0);
      var expiryTime = today
          .add(Duration(days: (days + weeks * 7 + months * 30 + years * 365)));
      choresBox.put(widget.choreKey,
          Chore(widget.choreKey, name, description, expiryTime));
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    var box = Hive.box<Chore>(boxName);
    Chore updateChore;
    updateChore = box.get(widget.choreKey)!;
    List<int> timeScopes = getScopeValues(updateChore.expiryDate);
    setState(() {
      days = timeScopes[0];
      weeks = timeScopes[1];
      months = timeScopes[2];
      years = timeScopes[3];
      name = updateChore.name;
      description = updateChore.description;
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
                initialValue: name,
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
                initialValue: description,
                decoration: const InputDecoration(labelText: "Descripción"),
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                }),
            Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    margin: const EdgeInsets.only(right: 8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      initialValue: days.toString(),
                      onChanged: (value) {
                        setState(() {
                          days = int.tryParse(value) ?? days;
                        });
                      },
                    ),
                  ),
                  const Text("Dias")
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    margin: const EdgeInsets.only(right: 8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      initialValue: weeks.toString(),
                      onChanged: (value) {
                        setState(() {
                          weeks = int.tryParse(value) ?? weeks;
                        });
                      },
                    ),
                  ),
                  const Text(
                    "Semanas",
                    textAlign: TextAlign.end,
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    margin: const EdgeInsets.only(right: 8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      initialValue: months.toString(),
                      onChanged: (value) {
                        setState(() {
                          months = int.tryParse(value) ?? months;
                        });
                      },
                    ),
                  ),
                  const Text("Meses")
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    margin: const EdgeInsets.only(right: 8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      initialValue: years.toString(),
                      onChanged: (value) {
                        setState(() {
                          years = int.tryParse(value) ?? years;
                        });
                      },
                    ),
                  ),
                  const Text("Años")
                ],
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 8),
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
