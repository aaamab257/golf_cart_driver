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
}
