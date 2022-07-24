import 'package:choresreminder/routes.dart';
import 'package:choresreminder/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/chore.dart';

const boxName = "chores";
const applicationName = "chores Reminder";
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ChoreAdapter());
  await Hive.openBox<Chore>(boxName);
  runApp(const MyApp());
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
