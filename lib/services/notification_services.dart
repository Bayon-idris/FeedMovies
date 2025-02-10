import 'dart:io';
import 'dart:math';

import 'package:feedmovies/screens/message_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      // Display visual notifications (pop-ups, banners, etc.)
      announcement: true,
      // Announce notifications via VoiceOver or TalkBack for accessibility
      badge: true,
      // Show unread notifications count on app icon
      carPlay: true,
      // Allow notifications to appear on Apple CarPlay
      criticalAlert: true,
      // Send notifications that break through silent mode
      provisional: true,
      // Send notifications without full user permission
      sound: true, // Play sound with the notification
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permissions");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("user granted proviional permissions");
    } else {
      print("user not granted permissions");
    }
  }

  void initAndroidLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitialization =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialization = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitialization, iOS: iOSInitialization);

    await notifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token ?? "UNKNOWN_TOKEN";
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('refresh token  ');
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
        initAndroidLocalNotifications(context, message);
        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(1000000).toString(),
        "High Importance Notification",
        importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: "Sample description",
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            ticker: 'ticker');

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      notifications.show(0, message.notification!.title.toString(),
          message.notification!.body.toString(), notificationDetails);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msg') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessageScreen(
            id: message.data['id'],
          ),
        ),
      );
    }
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    //when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null) {
      handleMessage(context, initialMessage);
    }
    // when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event){
      handleMessage(context, event);
    });
  }
}
