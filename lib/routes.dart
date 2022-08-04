import 'package:choresreminder/reminders/addChore/addChore.dart';
import 'package:choresreminder/reminders/home/homeReminders.dart';
import 'package:choresreminder/reminders/updateChore/updateChore.dart';

import 'home/home.dart';

var appRoutes = {
  '/': (context) => const Home(),
  '/reminders': (context) => const HomeReminders(),
  '/addReminder': (context) => AddChore(),
  '/updateReminder': (context) => UpdateChore(),
};
