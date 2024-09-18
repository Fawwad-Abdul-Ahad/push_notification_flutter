import 'package:flutter/material.dart';
import 'package:motificationapp/services/messaging_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PushNotification notificationFirebase = PushNotification();

  @override
  void initState() {
    super.initState();
    notificationFirebase.init();
    notificationFirebase.InteractMessage(context);
    notificationFirebase.firebaseInit(context);
    notificationFirebase.getToken().then((value) {
      print("Device Token: $value");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Push Notification"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text("Push notification through Firebase"),
      ),
    );
  }
}
