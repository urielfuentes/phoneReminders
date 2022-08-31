// ignore_for_file: prefer_const_constructors

import 'package:choresreminder/main.dart';
import 'package:choresreminder/reminders/remindersList/remindersList.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeReminders extends StatelessWidget {
  const HomeReminders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recordatorios.")),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<String>(tagsBoxName).listenable(),
          builder: (context, Box<String> box, _) {
            if (box.values.isEmpty) {
              return const Center(
                child: Text("Sin recordatorios."),
              );
            }
            var tags = box.values.toList();
            return Padding(
              padding: const EdgeInsets.all(15),
              child: ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    String tag = tags[index];
                    return Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: InkWell(
                        onTap: () => Future(() => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => RemindersList(
                                        tag: tag,
                                      )),
                            )),
                        child: SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: Card(
                              color: Colors.blue.shade400,
                              elevation: 2,
                              child: Center(
                                  child: Text(tag,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1))),
                        ),
                      ),
                    );
                  }),
            );
          }),
    );
  }
}
