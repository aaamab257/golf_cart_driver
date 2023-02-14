import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
    });
  }

  Future handleOnMessage(Map<String, dynamic> data) async {
    print("=== data = ${data.toString()}");
  }

  Future handleOnLaunch(Map<String, dynamic> data) async {
    print("=== data = ${data.toString()}");
  }

  Future handleOnResume(Map<String, dynamic> data) async {
    print("=== data = ${data.toString()}");
  }

  static Future<void> testHealth() async {}
}
