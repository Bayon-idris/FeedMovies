import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
      provisional: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Notifications autorisées");
    } else {
      print("Notifications refusées");
    }
  }

  Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await notifications.initialize(initSettings);
  }

  Future<void> getDeviceToken() async {
    String? token = await messaging.getToken();
    print("Mon token: $token");
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((token) {
      print("Nouveau token FCM: $token");
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    notifications.show(
      Random.secure().nextInt(100000), // ID unique
      message.notification?.title ?? "Nouveau message",
      message.notification?.body ?? "Vous avez une nouvelle notification",
      platformDetails,
    );
  }

  void setupFCMListeners() {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // handleNotificationTap(context, message);
    });
  }

// void handleNotificationTap(BuildContext context, RemoteMessage message) {
//   if (message.data['type'] == 'msg') {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => MessageScreen(id: message.data['id'])),
//     );
//   }
// }
}
