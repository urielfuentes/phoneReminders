import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class NotificationServiceImpl {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final String notificationsChannel = "choresChannel";

  void init(
      Future<dynamic> Function(int, String?, String?, String?)? onDidReceive) {
    final AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
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
}
