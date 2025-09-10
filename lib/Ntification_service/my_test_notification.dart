

// this is just for the emergency code no implementation
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize the notification plugin and create channel
  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse response) async {
        print("onDidReceiveNotificationResponse");
        if (response.payload != null && response.payload!.isNotEmpty) {
          print("Router Value1234 ${response.payload}");
          // TODO: Navigate to a specific screen if required
        }
      },
    );

    // 👇 Explicitly create notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      "pushnotificationapp", // Must match Manifest value
      "pushnotificationappchannel", // Visible name in system settings
      description: "Default channel for app notifications",
      importance: Importance.high,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Show notification when a message is received
  static Future<void> createanddisplaynotification(
      RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "pushnotificationapp", // Must match channel ID
          "pushnotificationappchannel",
          channelDescription: "Default channel for app notifications",
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification?.title ?? "No Title",
        message.notification?.body ?? "No Body",
        notificationDetails,
        payload: message.data['_id'] ?? "",
      );
    } on Exception catch (e) {
      print("❌ Error showing notification: $e");
    }
  }
}
