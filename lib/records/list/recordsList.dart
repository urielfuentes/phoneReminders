// ignore_for_file: prefer_const_constructors

import 'package:choresreminder/main.dart';
import 'package:choresreminder/records/add/addRecord.dart';
import 'package:choresreminder/records/update/updateRecord.dart';
import 'package:choresreminder/reminders/addChore/addChore.dart';
import 'package:choresreminder/services/date_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Common/constants.dart';
import '../../models/record.dart';

class RecordsList extends StatelessWidget {
  final String tag;
  const RecordsList({Key? key, this.tag = noTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(tag == noTag ? noTagText : tag)),
        body: ValueListenableBuilder(
            valueListenable: Hive.box<Record>(recordsBoxName).listenable(),
            builder: (context, Box<Record> box, _) {
              var orderedRecords =
                  box.values.where((element) => element.tag == tag).toList();
              if (orderedRecords.isEmpty) {
                return const Center(
                  child: Text("Sin registros."),
                );
              }
              orderedRecords.sort((a, b) => a.entryDate.compareTo(b.entryDate));
              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.builder(
                    itemCount: orderedRecords.length,
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
                                  onTap: () =>
                                      Future(() => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateRecord(
                                                      recordKey: record.id,
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
              onPressed: () => Future(() => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => AddRecord(
                              launcherTag: tag,
                            )),
                  )),
            );
          },
        ));
  }
}
