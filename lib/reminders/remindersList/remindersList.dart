// ignore_for_file: prefer_const_constructors

import 'package:choresreminder/Common/constants.dart';
import 'package:choresreminder/main.dart';
import 'package:choresreminder/reminders/updateChore/updateChore.dart';
import 'package:choresreminder/services/date_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:choresreminder/models/chore.dart';

class RemindersList extends StatelessWidget {
  final String tag;
  const RemindersList({Key? key, this.tag = noTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(tag == noTag ? noTagText : tag)),
        body: ValueListenableBuilder(
            valueListenable: Hive.box<Chore>(choresBoxName).listenable(),
            builder: (context, Box<Chore> box, _) {
              var temp = box.keys.toList();
              var orderedChores =
                  box.values.where((element) => element.tag == tag).toList();
              orderedChores
                  .sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
              if (orderedChores.isEmpty) {
                return const Center(
                  child: Text("Sin recordatorios."),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.builder(
                    itemCount: orderedChores.length,
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
                                  box.delete(chore.id);
                                },
                              ),
                              if (isDateNotExpired(chore.expiryDate))
                                PopupMenuItem(
                                    child: const Text("Editar"),
                                    onTap: () =>
                                        Future(() => Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateChore(
                                                        choreKey: chore.id,
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
