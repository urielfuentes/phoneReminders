// ignore_for_file: prefer_const_constructors

import 'package:choresreminder/main.dart';
import 'package:choresreminder/updateChore/updateChore.dart';
import 'package:choresreminder/services/date_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:choresreminder/models/chore.dart';

import '../addChore/addChore.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildDivider() => const SizedBox(height: 5);

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
              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      Chore chore = box.getAt(index)!;
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
                Navigator.pushNamed(context, '/add');
              },
            );
          },
        ));
  }

  Color getBackgroundColor(DateTime expiryDate) {
    var now = DateTime.now();
    var yesterdayAtMidNight = DateTime(now.year, now.month, now.day, 0, 1);
    if (expiryDate.isAfter(yesterdayAtMidNight)) {
      return Colors.blue.shade400;
    } else {
      return Colors.red.shade400;
    }
  }
}
