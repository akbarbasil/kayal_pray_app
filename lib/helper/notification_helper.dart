import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    const AndroidInitializationSettings _androidInitializationSettings = AndroidInitializationSettings("app_icon");
    final InitializationSettings _initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(_initializationSettings);
  }

  requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  showNotification(int id, String title, String body) async {
    const AndroidNotificationDetails _androidNotificationDetails = AndroidNotificationDetails(
      'Prayer_Alert',
      'Prayer Alert',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      ongoing: true,
      autoCancel: false,
    );

    const NotificationDetails _notificationDetails = NotificationDetails(
      android: _androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails,
      payload: 'payload',
    );
  }
}
