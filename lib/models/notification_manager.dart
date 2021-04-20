import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager
{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AndroidInitializationSettings initializationSettingsAndroid;
  MacOSInitializationSettings initializationSettingsMacOS;
  InitializationSettings initializationSettings;

  void initNotificationManager()
  {
    initializationSettingsAndroid = new AndroidInitializationSettings('@drawable/ic_stat_onesignal_default');
    initializationSettingsMacOS = new MacOSInitializationSettings();
    initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, macOS: initializationSettingsMacOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(String title, String body)
  {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'breathing connection channel id',
      'breathing connection channel',
      'breathing connection push notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    var macOSPlatformChannelSpecifics = new MacOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics, macOS: macOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics);
  }
}