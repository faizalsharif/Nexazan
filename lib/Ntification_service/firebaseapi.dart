import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // Ask for permission (iOS) – Android grants automatically
    await _firebaseMessaging.requestPermission();

    // Get FCM token
    String? fcmToken = await _firebaseMessaging.getToken();

    print("📱 Your FCM Token: $fcmToken");
  }
}
