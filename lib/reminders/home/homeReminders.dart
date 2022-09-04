// ignore_for_file: prefer_const_constructors

import 'package:choresreminder/main.dart';
import 'package:choresreminder/reminders/remindersList/remindersList.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../Common/ClickableCard.dart';
import '../../Common/constants.dart';

class HomeReminders extends StatelessWidget {
  const HomeReminders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recordatorios.")),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<String>(tagsBoxName).listenable(),
          builder: (context, Box<String> box, _) {
            var tags = box.values.toList();
            return Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      String tag = tags[index];
                      return ClickableCard(tag: tag);
                    })
              ],
            );
          }),
    );
  }
}
