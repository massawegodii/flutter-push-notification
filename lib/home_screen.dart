import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notification_with_onesignal/main.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Request Notification Permission
    requestNotificationPermission();

    // Get FCM Token
    FirebaseMessaging.instance.getToken().then((token) {
      print("🔑 Device FCM Token: $token");
    });

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        String title = message.notification!.title ?? "Notification";
        String body = message.notification!.body ?? "New Message";

        showNotification(title, body);
      }
    });
  }

  void requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted permission');
    } else {
      print('❌ User denied permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Push Notifications")),
      body: Center(child: Text("Waiting for notifications...")),
    );
  }
}

// Function to Show Notification
void showNotification(String title, String body) async {
  var androidDetails = AndroidNotificationDetails(
    "channelId",
    "Custom Channel Name",
    importance: Importance.high,
    priority: Priority.high,
    styleInformation: BigTextStyleInformation(body),
  );

  var notificationDetails = NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(
    0, title, body, notificationDetails);
}
