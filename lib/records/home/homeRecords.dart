// ignore_for_file: prefer_const_constructors

import 'package:choresreminder/main.dart';
import 'package:choresreminder/records/update/updateRecord.dart';
import 'package:choresreminder/reminders/updateChore/updateChore.dart';
import 'package:choresreminder/services/date_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/record.dart';

class HomeRecords extends StatelessWidget {
  const HomeRecords({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Registros.")),
        body: ValueListenableBuilder(
            valueListenable: Hive.box<Record>(recordsBoxName).listenable(),
            builder: (context, Box<Record> box, _) {
              if (box.values.isEmpty) {
                return const Center(
                  child: Text("Sin registros."),
                );
              }
              var orderedRecords = box.values.toList();
              orderedRecords.sort((a, b) => a.entryDate.compareTo(b.entryDate));
              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      Record record = orderedRecords[index];
                      String choreString;
                      String dateString = getDateStringRecord(record.entryDate);
                      if (record.description.isNotEmpty) {
                        choreString = "${record.description} \n$dateString";
                      } else {
                        choreString = dateString;
                      }

                      return Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: ListTile(
                          tileColor: Colors.blue.shade400,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          title: Text(record.name,
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
                                            builder: (context) => UpdateRecord(
                                                  recordKey: box.keyAt(index),
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
                Navigator.pushNamed(context, '/addRecord');
              },
            );
          },
        ));
  }
}
