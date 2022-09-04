import 'dart:isolate';

import 'package:choresreminder/models/record.dart';
import 'package:choresreminder/routes.dart';
import 'package:choresreminder/theme.dart';
import 'package:choresreminder/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Common/constants.dart';
import 'models/chore.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

const choresBoxName = "chores";
const recordsBoxName = "records";
const applicationName = "Reminders and Records";
const tagsBoxName = "tags";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var notifService = NotificationService();
  notifService.init();
  await AndroidAlarmManager.initialize();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ChoreAdapter());
  }
  await Hive.openBox<Chore>(choresBoxName);
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(RecordAdapter());
  }
  await Hive.openBox<Record>(recordsBoxName);
  await Hive.openBox<String>(tagsBoxName);
  var tagsBox = Hive.box<String>(tagsBoxName);
  tagsBox.put(noTag, noTag);

  runApp(const MyApp());
  await NotificationService.checkForExpiredChores();
  const int choresRemID = 0;
  await AndroidAlarmManager.periodic(const Duration(days: 1), choresRemID,
      NotificationService.checkForExpiredChores);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminders',
      theme: appTheme,
      routes: appRoutes,
    );
  }
}
