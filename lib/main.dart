import 'package:feedmovies/screens/movie_feed_screen.dart';
import 'package:feedmovies/services/notification_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final NotificationServices notificationServices = NotificationServices();
  await notificationServices.initLocalNotifications();
  await notificationServices.getDeviceToken();
  await notificationServices.requestNotificationPermission();
  notificationServices.isTokenRefresh();

  notificationServices.setupFCMListeners();

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Gestion des notifications en arrière-plan
  await Firebase.initializeApp();
  final NotificationServices notificationServices = NotificationServices();
  notificationServices.showNotification(message);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feed Movies',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MovieFeedScreen(),
    );
  }
}
