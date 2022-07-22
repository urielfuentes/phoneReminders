import 'package:choresreminder/main.dart';
import 'package:choresreminder/utils.dart';
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
                      return Card(
                          margin: const EdgeInsets.only(bottom: 15),
                          color: getBackgroundColor(chore.expiryDate),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDivider(),
                                Text(chore.name,
                                    style:
                                        Theme.of(context).textTheme.headline5),
                                if (chore.description.isNotEmpty)
                                  _buildDivider(),
                                if (chore.description.isNotEmpty)
                                  Text(chore.description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1),
                                _buildDivider(),
                                Text(
                                  getFormattedDate(chore.expiryDate),
                                )
                              ],
                            ),
                          ));
                    }),
              );
            }),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddChore()),
                );
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
