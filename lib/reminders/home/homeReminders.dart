// ignore_for_file: prefer_const_constructors

import 'package:choresreminder/main.dart';
import 'package:choresreminder/reminders/updateChore/updateChore.dart';
import 'package:choresreminder/services/date_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:choresreminder/models/chore.dart';

import '../addChore/addChore.dart';

class HomeReminders extends StatelessWidget {
  const HomeReminders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ChoresReminder")),
        body: ValueListenableBuilder(
            valueListenable: Hive.box<Chore>(boxName).listenable(),
            builder: (context, Box<Chore> box, _) {
              if (box.values.isEmpty) {
                return const Center(
                  child: Text("Sin recordatorios."),
                );
              }
              var orderedChores = box.values.toList();
              orderedChores
                  .sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      Chore chore = orderedChores[index];
                      String choreString;
                      if (chore.description.isNotEmpty) {
                        choreString =
                            "${chore.description}\n ${getFormattedDate(chore.expiryDate)}";
                      } else {
                        choreString = getFormattedDate(chore.expiryDate);
                      }

                      return Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: ListTile(
                          tileColor: getBackgroundColor(chore.expiryDate),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          title: Text(chore.name,
                              style: Theme.of(context).textTheme.headline5),
                          subtitle: Text(choreString),
                          isThreeLine: true,
                          trailing: PopupMenuButton(
                            itemBuilder: (ctx) => [
                              PopupMenuItem(
                                child: const Text("Eliminar"),
                                onTap: () {
                                  box.deleteAt(index);
                                },
                              ),
                              if (isDateNotExpired(chore.expiryDate))
                                PopupMenuItem(
                                    child: const Text("Editar"),
                                    onTap: () => Future(() =>
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => UpdateChore(
                                                    choreKey: box.keyAt(index),
                                                  )),
                                        ))),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/addReminder');
              },
            );
          },
        ));
  }

  Color getBackgroundColor(DateTime expiryDate) {
    if (isDateNotExpired(expiryDate)) {
      return Colors.blue.shade400;
    } else {
      return Colors.red.shade400;
    }
  }

  bool isDateNotExpired(DateTime expiryDate) {
    var now = DateTime.now();
    var yesterdayAtMidNight = DateTime(now.year, now.month, now.day, 0, 1);
    return expiryDate.isAfter(yesterdayAtMidNight);
  }
}
