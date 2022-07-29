import 'dart:isolate';

import 'package:choresreminder/routes.dart';
import 'package:choresreminder/theme.dart';
import 'package:choresreminder/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/chore.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

const boxName = "chores";
const applicationName = "Chores Reminder";

void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var notifService = NotificationService();
  notifService.init();
  await AndroidAlarmManager.initialize();
  await Hive.initFlutter();
  Hive.registerAdapter(ChoreAdapter());
  await Hive.openBox<Chore>(boxName);
  runApp(const MyApp());
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
      title: 'Flutter Demo',
      theme: appTheme,
      routes: appRoutes,
    );
  }
}
