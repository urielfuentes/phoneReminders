import 'package:choresreminder/records/add/addRecord.dart';
import 'package:choresreminder/records/home/homeRecords.dart';
import 'package:choresreminder/reminders/addChore/addChore.dart';
import 'package:choresreminder/reminders/home/homeReminders.dart';
import 'package:choresreminder/reminders/updateChore/updateChore.dart';

import 'home/home.dart';

var appRoutes = {
  '/': (context) => const Home(),
  '/reminders': (context) => const HomeReminders(),
  '/records': (context) => const HomeRecords(),
  '/addReminder': (context) => AddChore(),
  '/addRecord': (context) => AddRecord(),
  '/updateReminder': (context) => UpdateChore(),
};
