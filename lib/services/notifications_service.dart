import 'package:choresreminder/services/date_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart';
import '../models/chore.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final String notificationsChannel = "choresChannel";

  void init() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);

    initializeLocalNotificationsPlugin(initializationSettings);

    tz.initializeTimeZones();
  }

  void initializeLocalNotificationsPlugin(
      InitializationSettings initializationSettings) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  selectNotification(String? payload) {}

  void showNotification(int choreId, String notificationMessage) async {
    await flutterLocalNotificationsPlugin.show(
      choreId,
      applicationName,
      notificationMessage,
      NotificationDetails(
          android: AndroidNotificationDetails(
              notificationsChannel, applicationName,
              channelDescription: 'To remind you about upcoming chores')),
    );
  }

  static Future<void> checkForExpiredChores() async {
    print("In notification callback.");
    var notifService = NotificationService();
    var now = DateTime.now();
    var yesterdayAtMidNight = DateTime(now.year, now.month, now.day, 0, 1);
    await Hive.initFlutter();
    await Hive.openBox<Chore>(choresBoxName);
    var box = Hive.box<Chore>(choresBoxName);
    List<Chore> chores = box.values.toList();
    List<Chore> expiredChores = chores
        .where((chore) => chore.expiryDate.isBefore(yesterdayAtMidNight))
        .toList();
    for (var chore in expiredChores) {
      notifService.showNotification(chore.id, getNotifMessage(chore));
    }
  }
}
