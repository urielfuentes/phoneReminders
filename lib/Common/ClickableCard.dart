import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../reminders/remindersList/remindersList.dart';

class ClickableCard extends StatelessWidget {
  final String title;
  const ClickableCard({Key? key, required this.tag, this.title = ""})
      : super(key: key);

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      child: InkWell(
        onTap: () => Future(() => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => RemindersList(
                        tag: tag,
                      )),
            )),
        child: SizedBox(
          width: double.infinity,
          height: 70,
          child: Card(
              color: Colors.blue.shade400,
              elevation: 2,
              child: Center(
                  child: Text(title.isNotEmpty ? title : tag,
                      style: Theme.of(context).textTheme.headline2))),
        ),
      ),
    );
  }
}
