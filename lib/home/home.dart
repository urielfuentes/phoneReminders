// ignore_for_file: prefer_const_constructors

import 'package:choresreminder/main.dart';
import 'package:choresreminder/reminders/updateChore/updateChore.dart';
import 'package:choresreminder/services/date_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:choresreminder/models/chore.dart';

import '../reminders/addChore/addChore.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Reminders")),
        body: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, '/reminders'),
                      child: SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: Card(
                            color: Colors.red.shade400,
                            elevation: 2,
                            child: Center(
                                child: Text("Recordatorio",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1))),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: Card(
                            color: Colors.blue.shade400,
                            elevation: 2,
                            child: Center(
                                child: Text("Registro",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1))),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  void onFormSubmit() {}
}
