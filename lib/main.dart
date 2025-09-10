import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_live_azan/Firestore_Service/firestore_service.dart';

import 'Ntification_service/notification_service.dart';
import 'firebase_options.dart';
import 'views/home_screen.dart';

// Background handler for FCM
@pragma('vm:entry-point')

Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  LocalNotificationService.createAndDisplayNotification(message);
  print("📩 BG Message: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
  final status = await Permission.notification.request();
  if (!status.isGranted) {
    print("❌ Notification permission not granted");
  }
}

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize notifications
  await LocalNotificationService.initialize();

  // Register background message handler
    // 3️⃣ Listen for foreground FCM messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.data.isNotEmpty) {
      LocalNotificationService.createAndDisplayNotification(message);
    }
  });

  // Get & save FCM token
  final tokenService = TokenService();
  await tokenService.saveToken("Noorani Masjid", "user_001");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Azan Notification App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Azan App Home'),
    );
  }
}
