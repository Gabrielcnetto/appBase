import 'dart:typed_data';

import 'package:barbershop2/classes/Estabelecimento.dart';
import 'package:barbershop2/rotas/Approutes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import notification library

class FirebaseNotifications {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // Initialize notification plugin

  Future<void> initNotifications() async {
    // ... (existing code for requesting permissions and getting token)

    // Register the background handler function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialize notification plugin settings (optional, customize as needed)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'notification_icon'); // Replace with your icon resource name
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    // You can handle messages received in the foreground here if needed
  }

  Future handleBackgroundNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // Process the FCM message
    final notificationData = message.data; // Extract data from the message
    String title =
        notificationData['title'] ?? "BarberShop2"; // Set default title
    String body = notificationData['body'] ?? "";

    // Show notification using the notification plugin
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID (optional)
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          playSound: true,
          'your_channel_id', // Add channel ID here
          'BarberShop2 Notifications', // Add channel description here
          importance: Importance.high,
          icon: '@mipmap/ic_launcher.png',
          priority: Priority.high,
        ),
      ),
    );
  }
}
