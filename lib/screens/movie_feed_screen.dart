import 'package:feedmovies/services/notification_services.dart';
import 'package:flutter/material.dart';

class MovieFeedScreen extends StatefulWidget {
  const MovieFeedScreen({super.key});

  @override
  State<MovieFeedScreen> createState() => _MovieFeedScreenState();
}

class _MovieFeedScreenState extends State<MovieFeedScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print("token $value");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(""),
      ),
    );
  }
}
