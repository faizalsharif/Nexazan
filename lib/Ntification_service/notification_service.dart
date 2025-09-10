import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications
  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse:
          (NotificationResponse response) async {
        print("onDidReceiveNotificationResponse");
        if (response.payload != null && response.payload!.isNotEmpty) {
          print("Router Value1234: ${response.payload}");
        }
      },
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      "pushnotificationapp",
      "pushnotificationappchannel",
      description: "Channel for Azan notifications",
      importance: Importance.high,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Display notification
  static Future<void> createAndDisplayNotification(
      RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        "pushnotificationapp",
        "pushnotificationappchannel",
        importance: Importance.max,
        priority: Priority.high,
        // Custom sound: Add your bismillah.mp3 in android/app/src/main/res/raw/
        playSound: true,
      );

      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidDetails);

      await _notificationsPlugin.show(
        id,
        message.notification?.title ,
        message.notification?.body,
        notificationDetails,
        payload: message.data['_id'],
      );
    } catch (e) {
      print("❌ Notification error: $e");
    }
  }
}
