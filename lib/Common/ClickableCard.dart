import 'package:choresreminder/Common/constants.dart';
import 'package:choresreminder/records/list/recordsList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../reminders/remindersList/remindersList.dart';

class ClickableCard extends StatelessWidget {
  final bool reminderCard;
  const ClickableCard({Key? key, required this.tag, this.reminderCard = true})
      : super(key: key);

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
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
        child: SizedBox(
          width: double.infinity,
          height: 70,
          child: Card(
              color: Colors.blue.shade400,
              elevation: 2,
              child: Center(
                  child: Text(tag == noTag ? noTagText : tag,
                      style: Theme.of(context).textTheme.headline2))),
        ),
      ),
    );
  }
}
