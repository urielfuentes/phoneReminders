import 'package:choresreminder/Common/constants.dart';
import 'package:choresreminder/records/list/recordsList.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

import '../main.dart';
import '../models/chore.dart';
import '../models/record.dart';
import '../reminders/remindersList/remindersList.dart';

class ClickableCard extends StatelessWidget {
  final bool reminderCard;
  const ClickableCard({Key? key, required this.tag, this.reminderCard = true})
      : super(key: key);

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8, left: 36, right: 36),
        child: InkWell(
          onTap: () => Future(() => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  if (reminderCard) {
                    return RemindersList(
                      tag: tag,
                    );
                  } else {
                    return RecordsList(
                      tag: tag,
                    );
                  }
                }),
              )),
          child: Card(
            color: Colors.blue.shade400,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: ListTile(
                title: Text(tag == noTag ? noTagText : tag,
                    style: Theme.of(context).textTheme.headline2),
                trailing: InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      FittedBox(
                        child: Icon(FontAwesomeIcons.trash),
                      )
                    ],
                  ),
                  onTap: () {
                    if (reminderCard) {
                      var tagsBox = Hive.box<String>(tagsBoxName);
                      var choresBox = Hive.box<Chore>(choresBoxName);
                      var choresToDelete = choresBox.values
                          .where((element) => element.tag == tag);
                      for (var element in choresToDelete) {
                        choresBox.delete(element.id);
                      }
                      tagsBox.delete(tag);
                    } else {
                      var tagsBox = Hive.box<String>(recordsTagsBoxName);
                      var recordsBox = Hive.box<Record>(recordsBoxName);
                      var recordsToDelete = recordsBox.values
                          .where((element) => element.tag == tag);
                      for (var element in recordsToDelete) {
                        recordsBox.delete(element.id);
                      }
                      tagsBox.delete(tag);
                    }
                  },
                ),
              ),
            ),
          ),
        ));
  }
}
