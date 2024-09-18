import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:motificationapp/screens/message_screen.dart';

class PushNotification {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotification =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<String?> getToken() async {
    String? token = await _firebaseMessaging.getToken();
    return token; // Return token directly, null is handled
  }

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSetting =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSetting = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitializationSetting,
      iOS: iosInitializationSetting,
    );

    await _localNotification.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (response) {
      // Handle what happens when the user taps the notification
      handleMessage(context, message);
    });
  }

  void firebaseInit(BuildContext context) {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Platform.isAndroid || Platform.isIOS) {
        initLocalNotification(context, message);
        showNotification(message);
      }
      if (kDebugMode) {
        print(message.data.toString());
      }
    });

    // Handle when the app is in background and the notification is tapped
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(context, message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // Use a fixed ID for the channel
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await _localNotification.show(
      Random().nextInt(1000), // Use a unique ID for each notification
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
    );
  }

  Future<void> InteractMessage(BuildContext context)async{

    //when the app is terminated so tap on notification navigae to next screen
    RemoteMessage? initalMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initalMessage!=null){
      handleMessage(context, initalMessage);
    }

    //When the App is run on the background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context,event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    // Check the message type and navigate to the appropriate screen
    if (message.data['type'] == 'message') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  MessageScreen(id: message.data['id'],)),
      );
    }
  }
}
