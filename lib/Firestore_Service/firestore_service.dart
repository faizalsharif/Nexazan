import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TokenService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _firestore = FirebaseFirestore.instance;

  /// Save FCM token under a specific mosque
  Future<void> saveToken(String mosqueId, String userId) async {
    try {
      // Get device token
      String? token = await _firebaseMessaging.getToken();
      if (token == null) {
        print("❌ Failed to get FCM token");
        return;
      }
      else{

 print("📱 Current FCM Token: $token ================================");
      }

     

      // Save into Firestore
      await _firestore
          .collection("mosques")
          .doc(mosqueId)
          .collection("tokens")
          .doc(userId) // use userId to avoid duplicates
          .set({
        "token": token,
        "timestamp": DateTime.now(),
      });

      print("✅ Token saved successfully for $userId in $mosqueId");
    } catch (e, st) {
      print("❌ Error saving token: $e");
      print(st);
    }
  }
}
