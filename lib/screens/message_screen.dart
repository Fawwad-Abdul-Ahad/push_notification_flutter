import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageScreen extends StatelessWidget {
  String id;
   MessageScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message Screen $id"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
    );
  }
}